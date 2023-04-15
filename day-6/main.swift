//
// Advent of Code 2022
// Day 6: Tuning Trouble
//

import Foundation

/// Returns the index **following** the first occurrence of n unique, consecutive characters.
///
/// - Parameters:
///     -  n: The number of unique consecutive characters to identify.
///     - datastream: The string in which to search.
/// - Returns: An integer equal to the index following the identified characters.
func findIndexAfterNUniqueConsecutiveCharacters(_ n: Int, in datastream: String) -> Int {
    var firstPacketStartMarker: Int = 0
    
    for (index, _) in datastream.enumerated() {
        let start = datastream.index(datastream.startIndex, offsetBy: index)
        let end = datastream.index(start, offsetBy: n, limitedBy: datastream.endIndex) ?? datastream.endIndex
        
        /// Construct a set of n consecutive characters
        let startMarker = Set(datastream[start ..< end])
        
        /// If the set is still of size n, they must be unique
        if startMarker.count == n {
            firstPacketStartMarker = index + n
            break
        }
    }
    
    return firstPacketStartMarker
}

func findPacketStartMarker(in datastream: String) -> Int {
    return findIndexAfterNUniqueConsecutiveCharacters(4, in: datastream)
}

func findMessageStartMarker(in datasteram: String) -> Int {
    return findIndexAfterNUniqueConsecutiveCharacters(14, in: datasteram)
}

func partOne(datastream: String) -> Int {
    return findPacketStartMarker(in: datastream)
}

func partTwo(datastream: String) -> Int {
    return findMessageStartMarker(in: datastream)
}

func main() {
    let rawInput = readStringFromBundledInput(fileName: "input.txt")
    
    let partOne = partOne(datastream: rawInput)
    let partTwo = partTwo(datastream: rawInput)
    
    print("Part One: \(partOne)")
    print("Part Two: \(partTwo)")
}

main()
