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
            
            let difficultyColor: Color = {
                switch viewModel.difficulty {
                case .easy:
                    return Color.blue
                case .medium:
                    return Color.green
                case .hard:
                    return Color.red
                }
            }()
            
            Text("Tempo restante: \(viewModel.timeRemaining)")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .padding(.top, 20)
                .foregroundColor(viewModel.timeRemaining > (viewModel.getTimeLimit(for: viewModel.difficulty) / 4) ? .black : .red)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    viewModel.choose(card: card)
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(difficultyColor)
        }
        
        if viewModel.showEndGameDialog {
            VStack {
                Text(viewModel.isGameWon ? "Parabéns!" : "Que pena, mas o tempo acabou")
                    .font(.headline)
                    .foregroundColor(viewModel.isGameWon ? .green : .red)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Button("Jogar Novamente") {
                    viewModel.restartGame()
                    viewModel.showEndGameDialog = false
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .shadow(radius: 5)
            }
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
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

