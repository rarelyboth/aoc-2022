//
// Advent of Code 2022
// Day 3: Rucksack Reorganisation
//

import Foundation

struct Item: Hashable, CustomStringConvertible {
    var name: Character
    
    var description: String {
        return String(name)
    }
    
    init(named name: Character) {
        if !name.isLetter {
            fatalError("Expected alpha Item name! Got: \(name)")
        }
        
        self.name = name
    }
    
    var priority: Int {
        if name.isUppercase {
            return Int(name.asciiValue!) - 65 + 27
        } else {
            return Int(name.asciiValue!) - 97 + 1
        }
    }
}

struct Compartment: CustomStringConvertible {
    var contents: [Item]
    
    var description: String {
        contents.reduce("", {(desc, item) -> String in
            desc + item.description
        })
    }
    
    var uniqueItems: Set<Item> {
        return Set(contents)
    }
    
    init(containing contents: [Item]) {
        self.contents = contents
    }
}

struct Rucksack: CustomStringConvertible {
    var compartments: [Compartment]
    static let numCompartments = 2
    
    var description: String {
        compartments.reduce("", {(desc, compartment) -> String in
            desc + compartment.description
        })
    }
    
    init(withCompartments compartments: [Compartment]) {
        self.compartments = compartments
    }
    
    func getItemsCommonToAllCompartments() -> Set<Item> {
        let firstCompartmentItems = compartments.first!.uniqueItems
        
        return compartments.dropFirst().reduce(firstCompartmentItems, {(commonSet, compartment) -> Set<Item> in
            return commonSet.intersection(compartment.uniqueItems)
        })
    }
    
    func getItemsInAllCompartments() -> Set<Item> {
        let firstCompartmentItems = compartments.first!.uniqueItems
        
        return compartments.dropFirst().reduce(firstCompartmentItems, {(commonSet, compartment) -> Set<Item> in
            return commonSet.union(compartment.uniqueItems)
        })
    }
}

struct RucksackGroup: CustomStringConvertible {
    var rucksacks: [Rucksack]
    static let numRucksacks = 3
    
    var description: String {
        rucksacks.reduce("", {(desc, rucksack) -> String in
            desc + rucksack.description + "\n"
        })
    }
    
    init(withRucksacks rucksacks: [Rucksack]) {
        self.rucksacks = rucksacks
    }
    
    func getItemsCommonToAllRucksacks() -> Set<Item> {
        let firstRucksackItems = rucksacks.first!.getItemsInAllCompartments()
        
        return rucksacks.dropFirst().reduce(firstRucksackItems, {(commonSet, rucksack) -> Set<Item> in
            return commonSet.intersection(rucksack.getItemsInAllCompartments())
        })
    }
}

extension String {
    func subStrings(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map({ (currentIndex) -> String in
            let start = self.index(self.startIndex, offsetBy: currentIndex)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start ..< end])
        })
    }
}

func parseRucksacksContents(rawInput: String) -> [Rucksack] {
    let rawRucksacks = rawInput.split(separator: /\n/)
    
    var rucksacks: [Rucksack] = []
    for rawRucksack in rawRucksacks {
        let numRucksackItems = String(rawRucksack).count
        if numRucksackItems % 2 != 0 {
            fatalError("Rucksack contains an odd number of items: \(rawRucksack)!)")
        }
        let compartmentSize = numRucksackItems / Rucksack.numCompartments
        
        let rawCompartments = String(rawRucksack).subStrings(withLength: compartmentSize)
        
        var compartments: [Compartment] = []
        for rawCompartment in rawCompartments {
            var items: [Item] = []
            
            for rawItem in rawCompartment {
                items.append(Item(named: rawItem))
            }
            
            compartments.append(Compartment(containing: items))
        }
        
        rucksacks.append(Rucksack(withCompartments: compartments))
    }
                         
    return rucksacks
}

func groupNConsecutiveRucksacks(rucksacks: [Rucksack], n: Int) -> [RucksackGroup] {
    return stride(from: 0, to: rucksacks.count, by: n).map({(currentIndex) -> RucksackGroup in
        let start = rucksacks.index(rucksacks.startIndex, offsetBy: currentIndex)
        let end = rucksacks.index(start, offsetBy: n, limitedBy: rucksacks.endIndex) ?? rucksacks.endIndex
        return RucksackGroup(withRucksacks: Array(rucksacks[start ..< end]))
    })
}

func calculateTotalPrioritiesOfUniqueItemsInEachRucksackGroup(rucksackGroups: [RucksackGroup]) -> Int {
    var totalPriority = 0
    for rucksackGroup in rucksackGroups {
        let groupPriority = rucksackGroup.getItemsCommonToAllRucksacks().reduce(0, {(rollingSum, item) -> Int in
            return rollingSum + item.priority
        })
        
        totalPriority += groupPriority
    }
    
    return totalPriority
}

func calculateTotalPrioritiesOfItemsInAllCompartmentsOfEachRucksack(rucksacks: [Rucksack]) -> Int {
    var totalPriority = 0
    for rucksack in rucksacks {
        let rucksackPriority = rucksack.getItemsCommonToAllCompartments().reduce(0, {(rollingSum, item) -> Int in
            return rollingSum + item.priority
        })

        totalPriority += rucksackPriority
    }
    
    return totalPriority
}

func partOne(rucksacks: [Rucksack]) -> Int {
    return calculateTotalPrioritiesOfItemsInAllCompartmentsOfEachRucksack(rucksacks: rucksacks)
}

func partTwo(rucksacks: [Rucksack]) -> Int {
    let rucksackGroups = groupNConsecutiveRucksacks(rucksacks: rucksacks, n: 3)
    
    return calculateTotalPrioritiesOfUniqueItemsInEachRucksackGroup(rucksackGroups: rucksackGroups)
}

func main() {
    let rawInput = readStringFromBundledInput(fileName: "input.txt")
    
    let rucksacks = parseRucksacksContents(rawInput: rawInput)
    
    let partOne = partOne(rucksacks: rucksacks)
    let partTwo = partTwo(rucksacks: rucksacks)
    
    print("Part One: \(partOne)")
    print("Part Two: \(partTwo)")
}

main()
