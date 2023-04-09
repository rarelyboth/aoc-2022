//
// Advent of Code 2022
// Day 2: Rock Paper Scissors
//

import Foundation

enum Outcome: Int {
    case loss = 0
    case draw = 3
    case win = 6
    
    var score: Int {
        return rawValue
    }
    
    init(_ outcomeCode: String) {
        switch outcomeCode {
        case "X":
            self = .loss
        case "Y":
            self = .draw
        case "Z":
            self = .win
        default:
            fatalError("Unknown outcome code: \(outcomeCode)!")
        }
    }
}

enum Move: Int {
    case rock = 1
    case paper = 2
    case scissors = 3
    
    var score: Int {
        return rawValue
    }
    
    func winsAgainst() -> Move {
        return Move(rawValue: (rawValue - 1 + 2) % 3 + 1)!
    }
    
    func losesTo() -> Move {
        return Move(rawValue: (rawValue - 1 + 1) % 3 + 1)!
    }
    
    init(_ moveCode: String) {
        switch moveCode {
        case "A", "X":
            self = .rock
        case "B", "Y":
            self = .paper
        case "C", "Z":
            self = .scissors
        default:
            fatalError("Unknown move code: \(moveCode)!")
        }
    }
}

struct Game {
    var opponentMove: Move
    var move: Move
    
    var score: Int {
        return move.score + outcome.score
    }
    
    var outcome: Outcome {
        get {
            if move == opponentMove {
                return .draw
            } else {
                switch (move, opponentMove) {
                case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
                    return .win
                default:
                    return .loss
                }
            }
        }
        set (desiredOutcome) {
            switch desiredOutcome {
            case .draw:
                move = opponentMove
            case .loss:
                move = opponentMove.winsAgainst()
            case .win:
                move = opponentMove.losesTo()
            }
        }
    }
    
    init(opponentMoveCode: String, moveCode: String) {
        opponentMove = Move(opponentMoveCode)
        move = Move(moveCode)
    }
    
    static func +(lhs: Int, rhs: Game) -> Int {
        return lhs + rhs.score
    }
}

func parseRockPaperScissorsGames(rawInput: String, secondCodeDenotesOutcome: Bool = false) -> [Game]{
    let rawGames = rawInput.split(separator: /\n/)
    
    var games: [Game] = []
    for rawGame in rawGames {
        let rawCodes = rawGame.split(separator: " ")
        
        if rawCodes.count != 2 {
            assertionFailure("Invalid number of moves in game: \(String(rawGame))!")
        }
        
        let opponentMoveCode = String(rawCodes[0])
        let secondCode = String(rawCodes[1])
        
        var game = Game(opponentMoveCode: opponentMoveCode, moveCode: secondCode)
        if secondCodeDenotesOutcome {
            game.outcome = Outcome(secondCode)
        }
        
        games.append(game)
    }
    
    return games
}

func calculateTotalScore(games: [Game]) -> Int {
    return games.reduce(0, +)
}

func partOne(rawInput: String) -> Int {
    let games = parseRockPaperScissorsGames(rawInput: rawInput)
    return calculateTotalScore(games: games)
}

func partTwo(rawInput: String) -> Int {
    let games = parseRockPaperScissorsGames(rawInput: rawInput, secondCodeDenotesOutcome: true)
    return calculateTotalScore(games: games)
}

func main() {
    let rawInput = readStringFromBundledInput(fileName: "input.txt")
    
    let partOne = partOne(rawInput: rawInput)
    let partTwo = partTwo(rawInput: rawInput)
    
    print("Part One: \(partOne)")
    print("Part Two: \(partTwo)")
}

main()
