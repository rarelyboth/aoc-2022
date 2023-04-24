//
// Advent of Code 2022
// Day 8: Treetop Tree House
//

import Foundation

func partOne(_ forest: Forest) -> Int {
    return forest.rows.reduce(0, { (sum: Int, row: [Tree]) -> Int in
        return sum + row.reduce(0, { (sum: Int, tree: Tree) -> Int in
            return tree.visible ? sum + 1 : sum
        })
    })
}

func partTwo(_ forest: Forest) -> Int {
    return forest.rows.flatMap {$0}.max(by: {(lhs: Tree, rhs: Tree) -> Bool in
        return lhs.scenicScore < rhs.scenicScore
    })!.scenicScore
}

func main() {
    let rawInput = readStringFromBundledInput(fileName: "input.txt")
    
    let forest = Forest(from: rawInput)
    forest.calculateVisibility()
    
    let partOne = partOne(forest)
    let partTwo = partTwo(forest)
    
    print("Part One: \(partOne)")
    print("Part Two: \(partTwo)")
}

main()


