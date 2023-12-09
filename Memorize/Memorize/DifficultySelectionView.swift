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
            Text("Escolha a Dificuldade")
                .font(.largeTitle)

            Button("Fácil") {
                selectedDifficulty = .easy
                isGameViewPresented = true
            }
            .padding()

            Button("Médio") {
                selectedDifficulty = .medium
                isGameViewPresented = true
            }
            .padding()

            Button("Difícil") {
                selectedDifficulty = .hard
                isGameViewPresented = true
            }
            .padding()
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
