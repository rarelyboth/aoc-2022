//
// Advent of Code 2022
// Day 8: Treetop Tree House
//

import Foundation

enum Direction: CaseIterable {
    case north
    case south
    case east
    case west
}


class Tree: CustomStringConvertible {
    let height: Int
    
    var northVisible: Bool = false
    var southVisible: Bool = false
    var eastVisible: Bool = false
    var westVisible: Bool = false
    
    var north: Tree? = nil
    weak var south: Tree? = nil
    var east: Tree? = nil
    weak var west: Tree? = nil
    
    var description: String {
        return String(height)
    }
    
    var visible: Bool {
        return northVisible || southVisible || eastVisible || westVisible
    }
    
    var scenicScore: Int {
        return Direction.allCases.reduce(1, {(score: Int, direction: Direction) -> Int in
            return score * calculateSightDistance(in: direction)
        })
    }
    
    init(height: Int) {
        self.height = height
    }
    
    func next(_ direction: Direction) -> Tree? {
        switch direction {
        case .north:
            return self.north
        case .south:
            return self.south
        case .east:
            return self.east
        case .west:
            return self.west
        }
    }
    
    func calculateSightDistance(in direction: Direction) -> Int {
        var distance = 0
        
        var next = next(direction)
        while next != nil {
            distance += 1
            
            if height > next!.height {
                next = next!.next(direction)
            } else {
                break
            }
        }
        
        return distance
    }
}
