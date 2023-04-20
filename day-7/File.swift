//
// Advent of Code 2022
// Day 7: No Space Left On Device
//

import Foundation

struct File: CustomStringConvertible {
    var name: String
    var size: Int
    var parent: Directory
    
    static let regexPattern = /(?<fileSize>\d+) (?<fileName>[a-zA-Z.]+)/
    
    var description: String {
        return "\(name) (file, size=\(size)"
    }
    
    init(name: String, size: Int, parent: Directory) {
        self.name = name
        self.size = size
        self.parent = parent
    }
    
    init(from rawInfo: String, in parent: Directory) {
        let fileInfo = File.parseInformation(rawInfo)
        
        name = fileInfo.name
        size = fileInfo.size
        self.parent = parent
        
        parent.files.append(self)
    }
    
    static func parseInformation(_ rawInfo: String) -> (name: String, size: Int) {
        guard let fileInfo = try? regexPattern.wholeMatch(in: rawInfo) else {
            fatalError("Invalid directory information format!")
        }
        
        let fileName = String(fileInfo.output.fileName)
        let fileSize = Int(String(fileInfo.output.fileSize))!
        
        return (name: fileName, size: fileSize)
    }
}
