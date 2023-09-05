//
// Advent of Code 2022
// Day 9: Rope Bridge
//

import Foundation

func parseRopeMovements(input: String) -> [Point] {
    let movementPattern = /(?<direction>[UDLR]) (?<steps>\d+)/
    
    let startingPosition = Point(x: 0, y: 0)
    var headPositions = [startingPosition]
    
    for movement in input.components(separatedBy: "\n") {
        if movement == "" {
            break
        }
        
        guard let matches = try? movementPattern.wholeMatch(in: movement) else {
            fatalError("Unknown movement: \(movement)")
        }
        
        let direction = Direction(String(matches.output.direction))
        let steps = Int(String(matches.output.steps))!
        
        for _ in 1...steps {
            let newPoint = headPositions.last!.move(direction: direction, by: 1)
            
            headPositions.append(newPoint)
        }
    }
    
    return headPositions
}

func calculateTailPositions(headPositions: [Point]) -> [Point] {
    var tail = headPositions.first!
    
    var tailPositions = [tail]
    for head in headPositions {
        if head.x - tail.x >= 2 {
            tail = Point(x: head.x - 1, y: head.y)
        } else if tail.x - head.x >= 2 {
            tail = Point(x: head.x + 1, y: head.y)
        } else if head.y - tail.y >= 2 {
            tail = Point(x: head.x, y: head.y - 1)
        } else if tail.y - head.y >= 2 {
            tail = Point(x: head.x, y: head.y + 1)
        }
        
        tailPositions.append(tail)
    }
    
    return tailPositions
}

func partOne(_ headPositions: [Point]) -> Int {
    return Set(calculateTailPositions(headPositions: headPositions)).count
}

func partTwo(_ headPositions: [Point]) -> Int {
    var previousPositions = headPositions
    
    for _ in 1...9 {
        previousPositions = calculateTailPositions(headPositions: previousPositions)
    }
    
    return Set(previousPositions).count
}

func main() {
    let rawInput = readStringFromBundledInput(fileName: "input.txt")
    let headPositions = parseRopeMovements(input: rawInput)
    
    let partOne = partOne(headPositions)
    let partTwo = partTwo(headPositions)
    
    print("Part One: \(partOne)")
    print("Part Two: \(partTwo)")
}

main()
