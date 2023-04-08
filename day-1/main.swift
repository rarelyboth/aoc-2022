//
// Advent of Code 2022
// Day 1: Calorie Counting
//

import Foundation

struct CalorificInventory: Comparable {
    var items: [Int] = []
    
    var totalCalories: Int {
        return items.reduce(0, +)
    }
    
    mutating func append(_ newItem: Int) {
        items.append(newItem)
    }
    
    static func < (lhs: CalorificInventory, rhs: CalorificInventory) -> Bool {
        return lhs.totalCalories < rhs.totalCalories
    }
    
    static func + (lhs: Int, rhs: CalorificInventory) -> Int {
        return lhs + rhs.totalCalories
    }
}

func parseCalorificInventories(rawInput input: String) -> [CalorificInventory] {
    var inventories: [CalorificInventory] = []
    let rawInventories = input.split(separator: /\n{2,}/)
    
    for rawInventory in rawInventories {
        var inventory = CalorificInventory()
        let rawItems = rawInventory.split(separator: /\n/)
        
        for rawCalories in rawItems {
            if let calories = Int(rawCalories) {
                inventory.append(calories)
            }
        }
        
        inventories.append(inventory)
    }
    
    return inventories
}

func calculateCalorificValueOfMostCalorificElfsInventory(_ inventories: [CalorificInventory]) -> Int {
    return inventories.max()?.totalCalories ?? 0
}

func calculateCalorificValueOfNMostCalorificInventories(_ inventories: [CalorificInventory], n: Int) -> Int {
    let sortedInventories = inventories.sorted()
    
    let topNInventories = sortedInventories.suffix(n)
    
    return topNInventories.reduce(0, +)
}

func readStringFromBundledInput(fileName: String) -> String {
    guard let inputURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            fatalError("Failed to create URL for bundled input \(fileName)!")
    }
    
    do {
        return try String(contentsOf: inputURL)
    } catch {
        fatalError("Failed to read from URL: \(inputURL).")
    }
}

func partOne(inventories: [CalorificInventory]) -> Int {
    return calculateCalorificValueOfMostCalorificElfsInventory(inventories)
}

func partTwo(inventories: [CalorificInventory]) -> Int {
    return calculateCalorificValueOfNMostCalorificInventories(inventories, n: 3)
}

func main() {
    let rawInput = readStringFromBundledInput(fileName: "day_1_input.txt")
    let inventories = parseCalorificInventories(rawInput: rawInput)
    
    let partOne = partOne(inventories: inventories)
    let partTwo = partTwo(inventories: inventories)
    
    print("Part One: \(partOne)")
    print("Part Two: \(partTwo)")
}

main()
