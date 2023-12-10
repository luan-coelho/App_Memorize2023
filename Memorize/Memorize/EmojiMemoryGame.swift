import SwiftUI
import Combine

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    
    @Published var showEndGameDialog = false
    @Published var isGameWon = false
    @Published var timeRemaining: Int = 0
    
    private var timer: Timer?
    private var difficulty: Difficulty
    
    var isGameFinished: Bool {
        model.isGameFinished
    }
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        self.model = EmojiMemoryGame.createMemoryGame(difficulty: difficulty)
        self.timeRemaining = self.getTimeLimit(for: difficulty)
        self.startTimer()
    }
    
    private func getTimeLimit(for difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy:
            return 60 // Exemplo: 60 segundos para fácil
        case .medium:
            return 40 // Exemplo: 45 segundos para médio
        case .hard:
            return 2 // Exemplo: 30 segundos para difícil
        }
    }
    
    private func startTimer() {
        timer?.invalidate() // Cancela qualquer timer existente
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            if let self = self, self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self?.endGame()
            }
        }
    }
    
    private func endGame() {
        self.showEndGameDialog = true
        self.isGameWon = self.isGameFinished && self.timeRemaining > 0
        self.timer?.invalidate()
    }
    
    static func createMemoryGame(difficulty: Difficulty) -> MemoryGame<String> {
        let emojis = ["🧛🏻‍♂️","🕷️","🤡", "🎃", "👻", "🧟‍♂️"]
        let numberOfPairs = (difficulty == .easy) ? 3 : (difficulty == .medium) ? 4 : 6
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            return emojis[pairIndex % emojis.count]
        }
    }
    
    func restartGame() {
        model = EmojiMemoryGame.createMemoryGame(difficulty: difficulty)
        timeRemaining = getTimeLimit(for: difficulty)
        startTimer()
    }
    
    // Acesso ao modelo
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // Intenções
    func choose(card: MemoryGame<String>.Card) {
        if timeRemaining > 0 && !isGameFinished {
            objectWillChange.send()
            model.choose(card: card)
        }
        
        if isGameFinished {
            endGame()
        }
    }
}

enum Difficulty {
    case easy, medium, hard
}
