//
//  DifficultySelectionView.swift
//  Memorize
//
//  Created by Luan Coêlho de Souza on 09/12/23.
//

import SwiftUI

struct DifficultySelectionView: View {
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var isGameViewPresented = false
    
    var body: some View {
        VStack {

            Text("Escolha a dificuldade")
                .font(.largeTitle)

            HStack {
                // Botão Fácil
                VStack {
                    Button("Fácil") {
                        selectedDifficulty = .easy
                        isGameViewPresented = true
                    }
                    .padding()
                    .foregroundColor(.white)                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding()

                // Botão Médio
                VStack {
                    Button("Médio") {
                        selectedDifficulty = .medium
                        isGameViewPresented = true
                    }
                    .padding()
                    .foregroundColor(.white)                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(10)
                .padding()

                // Botão Difícil
                VStack {
                    Button("Difícil") {
                        selectedDifficulty = .hard
                        isGameViewPresented = true
                    }
                    .padding()
                    .foregroundColor(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(10)
                .padding()
            }
        }
        .sheet(isPresented: $isGameViewPresented) {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame(difficulty: selectedDifficulty))
        }
    }
}

struct DifficultySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DifficultySelectionView()
    }
}
