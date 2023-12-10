import SwiftUI
import Combine

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    
    @Published var showEndGameDialog = false
    @Published var isGameWon = false
    @Published var timeRemaining: Int = 0
    
    private var timer: Timer?
    public var difficulty: Difficulty
    
    var isGameFinished: Bool {
        model.isGameFinished
    }
    
    private var displayTime: Int {
            switch difficulty {
            case .easy:
                return 1
            case .medium:
                return 1
            case .hard:
                return 1
            }
        }
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        self.model = EmojiMemoryGame.createMemoryGame(difficulty: difficulty)
        self.timeRemaining = self.getTimeLimit(for: difficulty)
        self.startTimer()
        startGame()
    }
    
    public func getTimeLimit(for difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy:
            return 30
        case .medium:
            return 15
        case .hard:
            return 15
        }
    }
    
    func startGame() {
           // Vire todas as cartas para cima
           for index in model.cards.indices {
               model.cards[index].isFaceUp = true
           }

           // Depois do tempo especificado, vire todas as cartas para baixo
           DispatchQueue.main.asyncAfter(deadline: .now() + Double(displayTime)) {
               for index in self.model.cards.indices {
                   self.model.cards[index].isFaceUp = false
               }
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
        let emojis = ["🇧🇷","🇨🇦","🇦🇷", "🇰🇾", "🇨🇱", "🇺🇸"]
        let numberOfPairs = (difficulty == .easy) ? 3 : (difficulty == .medium) ? 4 : 6
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            return emojis[pairIndex % emojis.count]
        }
    }
    
    func restartGame() {
        model = EmojiMemoryGame.createMemoryGame(difficulty: difficulty)
        timeRemaining = getTimeLimit(for: difficulty)
        startTimer()
        startGame()
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
