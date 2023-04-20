//
// Advent of Code 2022
// Day 7: No Space Left On Device
//

import Foundation

extension String {
    func matchesPattern<R>(_ regex: R) -> Bool where R : RegexComponent {
        self.wholeMatch(of: regex) != nil
    }
}

struct FileSystem {
    var files: [File]
    var directories: [Directory]
    
    var workingDirectory: Directory? = nil
    
    let changeDirectoryRegex: Regex = /\$ cd (?<directoryName>[a-zA-Z.\/]+)/
    let listDirectoryRegex: Regex = /\$ ls/
    let emptyLineRegex: Regex = /^$/
    let diskSize: Int = 70_000_000
    
    var size: Int {
        return directories.first!.size
    }
    
    var remainingSpace: Int {
        return diskSize - size
    }
    
    init() {
        let rootDirectory = Directory(name: "/") /// Assume the root directory exists
        
        directories = [rootDirectory]
        files = []
    }
    
    mutating func parseFileSystem(input: String) {
        let terminalLines: [String] = input.components(separatedBy: "\n")
        
        for line in terminalLines {
            if line.matchesPattern(File.regexPattern) {
                guard let directory = workingDirectory else {
                    fatalError("Files cannot exist at root level!")
                }
                
                let file = File(from: line, in: directory)
                
                files.append(file)
            } else if line.matchesPattern(Directory.regexPattern) {
                let directory = Directory(from: line, in: workingDirectory)
                
                directories.append(directory)
            } else if line.matchesPattern(changeDirectoryRegex) {
                let directoryName = try! changeDirectoryRegex.wholeMatch(in: line)!.output.directoryName
                
                switch directoryName {
                case "..":
                    workingDirectory = workingDirectory!.parent
                case "/":
                    workingDirectory = directories.first
                default:
                    workingDirectory = workingDirectory!.directories.first(where: { (directory: Directory) -> Bool in
                        directory.name == directoryName
                    })
                }
            } else if line.matchesPattern(listDirectoryRegex) || line.matchesPattern(emptyLineRegex) {
                continue
            } else {
                fatalError("Unknown terminal output: \(line)")
            }
        }
    }
    
    func calculateSizeOfDirectories(where condition: (Directory) -> Bool) -> Int {
        return directories.reduce(0, {(sum: Int, directory: Directory) -> Int in
            return condition(directory) ? sum + directory.size : sum
        })
    }
    
    func calculateSizeOfSmallestDirectory(where condition: (Directory) -> Bool) -> Int {
        return directories.filter(condition).min(by: {(lhs: Directory, rhs: Directory) -> Bool in
            return lhs.size < rhs.size
        })!.size
    }
}
