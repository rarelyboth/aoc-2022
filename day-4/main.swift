//
// Advent of Code 2022
// Day 4: Camp Cleanup
//

import Foundation

struct SectionAssignment: CustomStringConvertible, Equatable {
    var sections: ClosedRange<Int>
    
    var firstSection: Int {
        return sections.lowerBound
    }
    
    var lastSection: Int {
        return sections.upperBound
    }
    
    var description: String {
        return "\(sections.lowerBound)-\(sections.upperBound)"
    }
    
    init(from firstSection: Int, to lastSection: Int) {
        sections = firstSection ... lastSection
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.sections == rhs.sections
    }
    
    func overlaps(_ otherSectionAssignment: Self) -> Bool {
        return sections.overlaps(otherSectionAssignment.sections)
    }
}

struct AssignmentPair: CustomStringConvertible {
    var first: SectionAssignment
    var second: SectionAssignment
    
    var description: String {
        return "\(first),\(second)"
    }
    
    func isFullyContained() -> Bool {
        let minFirstSection = min(first.firstSection, second.firstSection)
        let maxLastSection = max(first.lastSection, second.lastSection)
        
        let minMaxSection = SectionAssignment(from: minFirstSection, to: maxLastSection)
        
        return minMaxSection == first || minMaxSection == second
    }
    
    func overlaps() -> Bool {
        return first.overlaps(second)
    }
}

func parseAssignmentPairs(_ inputData: String) -> [AssignmentPair] {
    var assignmentPairs: [AssignmentPair] = []
    
    for assignmentPair in inputData.split(separator: /\n/) {
        let rawSectionAssignments = assignmentPair.split(separator: ",")
        
        if rawSectionAssignments.count != 2 {
            fatalError("Assignments must be in pairs! Got: \(assignmentPair)")
        }
        
        var sectionAssignments: [SectionAssignment] = []

        for sectionAssignment in rawSectionAssignments {
            let assignedSections = sectionAssignment.split(separator: "-")
            
            let firstSection = Int(assignedSections.first!)!
            let lastSection = Int(assignedSections.last!)!
            
            sectionAssignments.append(SectionAssignment(from: firstSection, to: lastSection))
        }
        
        assignmentPairs.append(AssignmentPair(first: sectionAssignments.first!, second: sectionAssignments.last!))
    }
    
    return assignmentPairs
}

func countFullyContainedAssignmentPairs(_ assignmentPairs: [AssignmentPair]) -> Int {
    return assignmentPairs.reduce(0, {(sum, assignmentPair) -> Int in
        return assignmentPair.isFullyContained() ? sum + 1 : sum
    })
}

func countOverlappingAssignmentPairs(_ assignmentPairs: [AssignmentPair]) -> Int {
    return assignmentPairs.reduce(0, {(sum, assignmentPair) -> Int in
        return assignmentPair.overlaps() ? sum + 1 : sum
    })
}

func partOne(assignmentPairs: [AssignmentPair]) -> Int {
    return countFullyContainedAssignmentPairs(assignmentPairs)
}

func partTwo(assignmentPairs: [AssignmentPair]) -> Int {
    return countOverlappingAssignmentPairs(assignmentPairs)
}

func main() {
    let inputData = readStringFromBundledInput(fileName: "input.txt")
    
    let assignmentPairs = parseAssignmentPairs(inputData)
    
    let partOne = partOne(assignmentPairs: assignmentPairs)
    let partTwo = partTwo(assignmentPairs: assignmentPairs)
    
    print("Part One: \(partOne)")
    print("Part Two: \(partTwo)")
}

main()
