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
    
    enum State: Equatable { case valid, invalid, optionallyValid }
    var keyStates: [Character: State] = .init()
    
    func isInvalid(char: Character) -> Bool { keyStates[char] == .invalid }
    func isOptionallyValid(char: Character) -> Bool { keyStates[char] == .optionallyValid }
    func isValid(char: Character) -> Bool { keyStates[char] == .valid }
    
    func getKeyColor(for char: Character) -> UIColor {
        isValid(char: char) ? .systemGreen : isOptionallyValid(char: char) ? .systemOrange : isInvalid(char: char) ? .systemGray : .white
    }
}


struct GameState: Equatable {
    
    var guessState: GuessState = .init()
    var currentWord: [Character] = Array(Words.randomElement()!.uppercased())
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
    
    var currentKeyStates = gameState.usedChars.keyStates
    
    currentGuesses
        .enumerated()
        .forEach { charElement in
            let char = charElement.element
            if gameState.currentWord.contains(charElement.element) {
                currentKeyStates[char] = .optionallyValid
            }
            if charElement.element == gameState.currentWord[charElement.offset] {
                currentKeyStates[char] = .valid
            }
            if (currentKeyStates[char] == .valid) || (currentKeyStates[char] == .optionallyValid) {
                return
            }
            currentKeyStates[char] = .invalid
        }
    
    charState.keyStates = currentKeyStates
    
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


private let Words: [String] = [
    "Amber",
    "Angel",
    "Brave",
    "Cloud",
    "Coral",
    "Flute",
    "Ghost",
    "Grasp",
    "Jewel",
    "Karma",
    "Lemon",
    "Maple",
    "Mirth",
    "Olive",
    "Onset",
    "Peach",
    "Quiet",
    "Rhino",
    "Spade",
    "Surge",
    "Tonic",
    "Vixen",
    "Wagon",
    "Yacht",
    "Abide",
    "Alloy",
    "Blush",
    "Chant",
    "Fable",
    "Glide",
    "Apple",
    "House",
    "Bread",
    "River",
    "Phone",
    "Hotel",
    "Beach",
    "Tiger",
    "Happy",
    "Dance",
    "Plant",
    "Smile",
    "Music",
    "Party",
    "Ocean",
    "Train",
    "Earth",
    "Chair",
    "Watch",
    "Money"
]
