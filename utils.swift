//
// Advent of Code 2022
// Utilities
//

import Foundation

func readStringFromBundledInput(fileName: String) -> String {
    guard let inputURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            fatalError("Failed to create URL for bundled input \(fileName)!")
    }
    
    do {
        return try String(contentsOf: inputURL)
    } catch {
        fatalError("Failed to read from URL: \(inputURL)!")
    }
}
