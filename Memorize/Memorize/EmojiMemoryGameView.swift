//
//  EmojiMemomyGameView.swift
//  Memorize
//
//  Created by Sósthenes Oliveira Lima on 20/08/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
   @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        
        VStack {
            Text("Tempo Restante: \(viewModel.timeRemaining)")
                .padding(.top, 20)
            
            Grid(viewModel.cards) { card in
                CardView (card: card).onTapGesture {
                    viewModel.choose(card: card)
                }
                .padding(5)
            }
            
            .padding()
            .foregroundColor(Color.orange)
        }
        
        if viewModel.showEndGameDialog {
                   VStack {
                       Text(viewModel.isGameWon ? "Parabéns!" : "Que pena, mas o tempo acabou")
                           .foregroundColor(viewModel.isGameWon ? .green : .red)
                           .fontWeight(.bold)
                       Button("Jogar Novamente") {
                           viewModel.restartGame()
                           viewModel.showEndGameDialog = false
                       }
                       .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                       .background(Color.blue)
                       .foregroundColor(Color.white)
                       .cornerRadius(10)
                       .padding(.bottom, 20)
                   }
                   .frame(maxWidth: .infinity, minHeight: 100)
                   .background(Color.white)
                   .cornerRadius(20).shadow(radius: 10)
               }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View{
        GeometryReader { geometry in
            self.body(for: geometry.size)
          }
        }
        
        func body(for size: CGSize) -> some View {
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: corneRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: corneRadius).stroke(lineWidth: edgeLineWidth)
                    Text(card.content)
                } else {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: corneRadius).fill()
                    }
                }
            }
             .font(Font.system(size: fontSize(for: size)))
         }
            
    
    // Mark: - Drawing Constants
    
    let corneRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

