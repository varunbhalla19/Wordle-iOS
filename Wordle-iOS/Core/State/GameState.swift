//
//  GameState.swift
//  Wordle-iOS
//

import ReSwift


struct GuessState: Equatable {
    
    var guesses: [Int: [Character]] = .init()
    var currentRow = 0

    func getChar(at section: Int, row: Int) -> Character? {
        guard let guessRow = guesses[section] else { return nil }
        return guessRow.isEmpty ? nil : (guessRow.count <= row) ? nil : guessRow[row]
    }
 
    var isRowComplete: Bool {
        guesses[currentRow]?.count == 5
    }
    
    func color(for indexPath: IndexPath) -> UIColor {
        
        guard indexPath.section < currentRow else { return .clear }
        
        guard let char = guesses[indexPath.section]?[indexPath.row] else { return .clear }
        
        if gameStore.state.currentWord[indexPath.row] == char {
            return .systemGreen
        }
        
        if gameStore.state.currentWord.contains(char) {
            return .systemOrange
        }
        
        return .clear
    }
    
}


struct UsedChars: Equatable {
    
    var valid: [Character] = .init()
    
    var optionallyValid: [Character] = .init()
    
}


struct GameState: Equatable {
    
    var guessState: GuessState = .init()
    var currentWord: [Character] = ["W", "O", "R", "S", "T"]
    var usedChars: UsedChars = .init()
    
}

enum GameAction: Action {
    
    case backSpace
    
    case addChar(Character)
    
    case lineEnded
    
}

func GuessStateReducer(state: GuessState?, action: GameAction?) -> GuessState {
    var state = state ?? .init()
    
    guard let action else { return state }
    
    switch action {
        case .backSpace:
            var temp = state.guesses[state.currentRow] ?? []
            if !temp.isEmpty {
                temp.removeLast()
            }
            state.guesses[state.currentRow] = temp
        case .addChar(let character):
            var temp = state.guesses[state.currentRow] ?? []
            temp.append(character)
            state.guesses[state.currentRow] = temp
        case .lineEnded:
            state.currentRow += 1
    }
    
    return state
}

func UsedCharsReducer(state: GameState) -> UsedChars {
    let gameState = state
    let guessState = state.guessState
    var charState = state.usedChars
    
    guard let currentGuesses = guessState.guesses[guessState.currentRow], !currentGuesses.isEmpty else { return charState }
    
    let valid = currentGuesses
        .enumerated()
        .filter { charElement in (charElement.element == gameState.currentWord[charElement.offset]) && !charState.valid.contains(charElement.element) }
        .map(\.element)

    charState.valid += valid
    
    let optionallyValid = currentGuesses
        .filter { char in gameState.currentWord.contains(char) && !charState.optionallyValid.contains(char) }
    
    
    var result = charState.optionallyValid + optionallyValid
    result.removeAll { char in charState.valid.contains(char) }
    
    charState.optionallyValid = result
    
    print(charState)
    
    return charState
}

func AppReducer(action: Action?, state: GameState?) -> GameState {
    
    print("action: ", action)
    
    var appState = state ?? .init()
    
    guard let action = action as? GameAction else { return appState }
    
    switch action {
        case .backSpace:
            appState.guessState = GuessStateReducer(state: appState.guessState, action: action)
        case .addChar(_):
            appState.guessState = GuessStateReducer(state: appState.guessState, action: action)
        case .lineEnded:
            appState.usedChars = UsedCharsReducer(state: appState)
            appState.guessState = GuessStateReducer(state: appState.guessState, action: action)
    }
    
    return appState
    
}


let gameStore = Store(reducer: AppReducer, state: GameState(), middleware: [])

