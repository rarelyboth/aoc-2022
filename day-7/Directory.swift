//
// Advent of Code 2022
// Day 7: No Space Left On Device
//

import Foundation

class Directory: CustomStringConvertible {
    var name: String
    var parent: Directory?
    
    var files: [File] = []
    var directories: [Directory] = []
    
    var description: String {
        return "\(name) (dir)"
    }
    
    var size: Int {
        let fileSize = files.reduce(0, {(sum: Int, file: File) -> Int in
            return sum + file.size
        })
        
        let directorySize = directories.reduce(0, {(sum: Int, directory: Directory) -> Int in
            return sum + directory.size
        })
        
        return fileSize + directorySize
        
    }
    
    static let regexPattern: Regex = /dir (?<directoryName>[a-zA-Z]+)/
    
    init(name: String, parent: Directory? = nil) {
        self.name = name
        self.parent = parent
    }
    
    init(from rawInfo: String, in parent: Directory? = nil) {
        let directoryName = Directory.parseInformation(rawInfo)
        
        name = directoryName
        self.parent = parent
        
        if let parent = parent {
            parent.directories.append(self)
        }
    }
    
    static func parseInformation(_ rawInfo: String) -> String {
        guard let fileInfo = try? regexPattern.wholeMatch(in: rawInfo) else {
            fatalError("Invalid directory information format!")
        }
        
        return String(fileInfo.output.directoryName)
    }
}
