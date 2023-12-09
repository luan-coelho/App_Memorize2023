//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Sósthenes Oliveira Lima on 02/09/23.
//


import Foundation

enum Difficulty {
    case easy, medium, hard
}
    //Aqui está a nossa ViewModel
class EmojiMemoryGame: ObservableObject {
    //Nossa ViewModel possui uma var que é o Model, ele pode conversar com o Model de uma véz
    @Published private var model: MemoryGame<String>

       init(difficulty: Difficulty) {
           self.model = EmojiMemoryGame.createMemoryGame(difficulty: difficulty)
       }

       static func createMemoryGame(difficulty: Difficulty) -> MemoryGame<String> {
           let emojis = ["🧛🏻‍♂️","🕷️","🤡", "🎃", "👻", "🧟‍♂️"]
           let numberOfPairs = (difficulty == .easy) ? 3 : (difficulty == .medium) ? 4 : 6
           return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
               return emojis[pairIndex % emojis.count]
           }
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
