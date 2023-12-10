//
//  EmojiMemomyGameView.swift
//  Memorize
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
                CardView(card: card, difficultyColor: difficultyColor)
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.75)) {
                            viewModel.choose(card: card)
                        }
                    }
                    .padding(5)
            }
            .padding()
            .foregroundColor(difficultyColor)
        }
        .blur(radius: viewModel.showEndGameDialog ? 10 : 0)
        
        if viewModel.showEndGameDialog {
            EndGameDialog(isGameWon: viewModel.isGameWon, action: {
                withAnimation {
                    viewModel.restartGame()
                    viewModel.showEndGameDialog = false
                }
            })
            .transition(.scale)
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var difficultyColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                    Text(card.content)
                } else {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: 10.0).fill(difficultyColor)
                    }
                }
            }
            .font(Font.system(size: min(geometry.size.width, geometry.size.height) * 0.75))
            .shadow(radius: 5)
        }
    }
}

struct EndGameDialog: View {
    var isGameWon: Bool
    var action: () -> Void
    
    var body: some View {
        VStack {
            Text(isGameWon ? "Parabéns, você combinou todas as cartas dentro do tempo!" : "Que pena, mas o tempo acabou")
                .font(.headline)
                .foregroundColor(isGameWon ? .green : .red)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Button("Jogar Novamente", action: action)
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
        .padding(10)
    }
}


