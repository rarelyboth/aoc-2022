//
// Advent of Code 2022
// Day 7: No Space Left On Device
//

import Foundation

func partOne(_ fileSystem: FileSystem) -> Int {
    return fileSystem.calculateSizeOfDirectories(where: {(directory: Directory) -> Bool in
        directory.size < 100_000
    })
}

func partTwo(_ fileSystem: FileSystem) -> Int {
    return fileSystem.calculateSizeOfSmallestDirectory(where: {(directory: Directory) -> Bool in
        return directory.size >= 30_000_000 - fileSystem.remainingSpace
    })
}

func main() {
    let rawInput = readStringFromBundledInput(fileName: "input.txt")
    
    var fileSystem = FileSystem()
    fileSystem.parseFileSystem(input: rawInput)
    
    let partOne = partOne(fileSystem)
    let partTwo = partTwo(fileSystem)
    
    print("Part One: \(partOne)")
    print("Part Two: \(partTwo)")
}

main()
