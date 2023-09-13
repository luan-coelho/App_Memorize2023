//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Sósthenes Oliveira Lima on 02/09/23.
//


import Foundation

    //Aqui está a nossa ViewModel
class EmojiMemoryGame: ObservableObject {
    //Nossa ViewModel possui uma var que é o Model, ele pode conversar com o Model de uma véz
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["🧛🏻‍♂️","🕷️","🤡"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
           return emojis[pairIndex]
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
