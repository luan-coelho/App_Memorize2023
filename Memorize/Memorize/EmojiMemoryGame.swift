//
//  EmojiMemoryGame.swift
//  Memorize
//
//


import Foundation

enum Difficulty {
    case easy, medium, hard
}

//Aqui está a nossa ViewModel
class EmojiMemoryGame: ObservableObject {
    //Nossa ViewModel possui uma var que é o Model, ele pode conversar com o Model de uma véz
    @Published private var model: MemoryGame<String>
    
    private var difficulty: Difficulty
    
    var isGameFinished: Bool {
           model.isGameFinished
       }
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        self.model = EmojiMemoryGame.createMemoryGame(difficulty: difficulty)
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
    }
    
    
    // Mark: Access to the model
    // como pegar os cartões e também deixar
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    // acesso ao público ao modelo, que de outra forma seria privado!
    
    // Mark: Intent(s)
    // A visualização expressar sua Intenção, nesse caso, escolher um cartão
    
    func choose (card: MemoryGame<String>.Card) {
        objectWillChange.send()
        model.choose(card: card)
    }
}
