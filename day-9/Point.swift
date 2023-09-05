//
// Advent of Code 2022
// Day 9: Rope Bridge
//

import Foundation

enum Direction {
    case up
    case down
    case left
    case right
    
    init(_ directionCode: String) {
        switch directionCode {
        case "U":
            self = .up
        case "D":
            self = .down
        case "L":
            self = .left
        case "R":
            self = .right
        default:
            fatalError("Unknown direction code: \(directionCode)")
        }
    }
}

struct Point: Equatable, Hashable {
    let x: Int
    let y: Int
    
    func move(direction: Direction, by steps: Int) -> Point {
        var newX = x
        var newY = y
        
        switch direction {
        case .up:
            newY += steps
        case .down:
            newY -= steps
        case .left:
            newX += steps
        case .right:
            newX -= steps
        }
        
        return Point(x: newX, y: newY)
    }
    
    func move(directionCode: String, by steps: Int) -> Point {
        let direction = Direction(directionCode)
        return move(direction: direction, by: steps)
    }
}
