//
// Advent of Code 2022
// Day 5: Supply Stacks
//

import Foundation

struct Crate: CustomStringConvertible {
    let name: Character
    
    var description: String {
        return String(name)
    }
}

struct CrateStack: CustomStringConvertible {
    var label: Int
    var crates: [Crate] = []
    
    var description: String {
        let crateDescriptions = crates.reversed().reduce("", {(desc, crate) -> String in
            return desc + " \(crate.description)"
        })
        
        return "\(label): \(crateDescriptions)"
    }
    
    var topCrate: Crate? {
        return crates.first
    }
    
    init(label: Int) {
        self.label = label
    }
    
    mutating func emplace(_ crate: Crate) {
        crates.insert(crate, at: crates.startIndex)
    }
    
    mutating func emplaceMultiple(crates: [Crate]) {
        for crate in crates {
            emplace(crate)
        }
    }
    
    mutating func emplaceMultipleEnBloc(crates: [Crate]) {
        emplaceMultiple(crates: crates.reversed())
    }
    
    mutating func reclaim() -> Crate {
        return crates.removeFirst()
    }
    
    mutating func reclaimMultiple(_ k: Int) -> [Crate] {
        var reclaimedCrates: [Crate] = []
        
        for _ in 0 ..< k {
            reclaimedCrates.append(reclaim())
        }
        
        return reclaimedCrates
    }
}

struct CraneProcedure: CustomStringConvertible {
    let nCrates: Int
    let fromStack: Int
    let toStack: Int
    
    var description: String {
        return "Move \(nCrates) from \(fromStack) to \(toStack)"
    }
}

func separateCrateStackLabels(_ rawCrateState: String) -> (crateState: [String], stackLabels: String) {
    var splitCrateStateLabels = rawCrateState.components(separatedBy: "\n")
    if splitCrateStateLabels.count < 1 {
        fatalError("No stack state provided!")
    }
    
    let stackLabels = splitCrateStateLabels.popLast()!
    let crateState = splitCrateStateLabels
    
    return (crateState: crateState, stackLabels: stackLabels)
}

func parseStackLabels(_ rawStackLabels: String) -> [Int: CrateStack] {
    if rawStackLabels.contains(/[^0-9\W]/) {
        fatalError("Stack labels must be numeric!")
    }
    
    var crateStacks: [Int: CrateStack] = [:]
    for (index, rawLabel) in rawStackLabels.enumerated() {
        if rawLabel.isNumber {
            crateStacks[index] = CrateStack(label: Int(String(rawLabel))!)
        }
    }
    
    return crateStacks
}

func parseInitialCrateStackState(rawCrateState: String) -> [Int : CrateStack] {
    let (crateState, stackLabels) = separateCrateStackLabels(rawCrateState)
    
    var indexedCrateStacks = parseStackLabels(stackLabels)
    
    for stackLevel in crateState {
        for (index, crateLabel) in stackLevel.enumerated() {
            if crateLabel.isLetter {
                let crate = Crate(name: crateLabel)
                
                indexedCrateStacks[index]!.crates.append(crate)
            }
        }
    }
    
    var crateStacks: [Int : CrateStack] = [:]
    
    for (_, crateStack) in indexedCrateStacks {
        crateStacks[crateStack.label] = crateStack
    }
    
    return crateStacks
}

func parseCraneProcedure(_ rawCraneProcedure: String) -> [CraneProcedure] {
    let rawProcedures = rawCraneProcedure.components(separatedBy: "\n")
    
    var procedures: [CraneProcedure] = []
    for rawProcedure in rawProcedures {
        if rawProcedure.isEmpty {
            break
        }
        
        let procedureDetails = rawProcedure.matches(of: /(?:\d+)/)
        
        if procedureDetails.count != 3 {
            fatalError("Crane procedures must contain 3 numbers!")
        }
        
        let nCrates = Int(String(procedureDetails[0].output))!
        let fromStack = Int(String(procedureDetails[1].output))!
        let toStack = Int(String(procedureDetails[2].output))!

        procedures.append(CraneProcedure(nCrates: nCrates, fromStack: fromStack, toStack: toStack))
    }
    
    return procedures
}

func executeCraneProcedures9000OnCrateStacks(crateStacks: inout [Int : CrateStack], craneProcedures: [CraneProcedure]) {
    for craneProcedure in craneProcedures {
        let reclaimedCrates = crateStacks[craneProcedure.fromStack]!.reclaimMultiple(craneProcedure.nCrates)
        
        crateStacks[craneProcedure.toStack]!.emplaceMultiple(crates: reclaimedCrates)
    }
}

func executeCraneProcedures9001OnCrateStacks(crateStacks: inout [Int : CrateStack], craneProcedures: [CraneProcedure]) {
    for craneProcedure in craneProcedures {
        let reclaimedCrates = crateStacks[craneProcedure.fromStack]!.reclaimMultiple(craneProcedure.nCrates)
        
        crateStacks[craneProcedure.toStack]!.emplaceMultipleEnBloc(crates: reclaimedCrates)
    }
}

func separateCrateStateCraneProcedure(_ rawInput: String) -> (crateState: String, craneProcedure: String) {
    let splitInput = rawInput.split(separator: /\n\n/)
    
    if splitInput.count != 2 {
        fatalError("Invalid state & procedure format!")
    }
    
    let crateState = String(splitInput.first!)
    let craneProcedure = String(splitInput.last!)
    
    return (crateState, craneProcedure)
}

func partOne(crateStacks: [Int : CrateStack], craneProcedures: [CraneProcedure]) {
    var stacks = crateStacks
    
    executeCraneProcedures9000OnCrateStacks(crateStacks: &stacks, craneProcedures: craneProcedures)
    
    var orderedCrateStacks: [CrateStack] = []
    for (_, crateStack) in stacks {
        orderedCrateStacks.append(crateStack)
    }
    
    orderedCrateStacks.sort(by: { (lhs: CrateStack, rhs: CrateStack) -> Bool in
        return lhs.label < rhs.label
    })
    
    for crateStack in orderedCrateStacks {
        print(crateStack.label, terminator: ": ")

        if let topCrate = crateStack.topCrate {
            print(topCrate)
        } else {
            print(" ")
        }
    }
}

func partTwo(crateStacks: [Int : CrateStack], craneProcedures: [CraneProcedure]) {
    var stacks = crateStacks
    
    executeCraneProcedures9001OnCrateStacks(crateStacks: &stacks, craneProcedures: craneProcedures)
    
    var orderedCrateStacks: [CrateStack] = []
    for (_, crateStack) in stacks {
        orderedCrateStacks.append(crateStack)
    }
    
    orderedCrateStacks.sort(by: { (lhs: CrateStack, rhs: CrateStack) -> Bool in
        return lhs.label < rhs.label
    })
    
    for crateStack in orderedCrateStacks {
        print(crateStack.label, terminator: ": ")

        if let topCrate = crateStack.topCrate {
            print(topCrate)
        } else {
            print(" ")
        }
    }
}

func main() {
    let rawInput = readStringFromBundledInput(fileName: "input.txt")
    
    let input = separateCrateStateCraneProcedure(rawInput)
    var initialState = parseInitialCrateStackState(rawCrateState: input.crateState)
    
    let craneProcedure = parseCraneProcedure(input.craneProcedure)
    
    print("Part One:")
    partOne(crateStacks: initialState, craneProcedures: craneProcedure)
    
    print("Part Two:")
    partTwo(crateStacks: initialState, craneProcedures: craneProcedure)
}

main()
