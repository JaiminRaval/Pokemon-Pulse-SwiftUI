//
//  PokemonDetailView.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 12/08/26.
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject private var viewModel: PokemonDetailViewModel
    @State private var isEditing = false

    init(pokemon: PokemonModel) {
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemon: pokemon))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PokemonArtworkView(urlString: viewModel.imageURL)
                    .frame(width: 220, height: 220)

                Text(viewModel.name)
                    .font(.title.bold())

                Text(viewModel.type)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    row("ability", viewModel.ability)
                    row("nature", viewModel.nature)
                    row("attack", viewModel.attackType)
                    row("color", viewModel.color)
                    row("level", viewModel.level)
                    row("gen", viewModel.gen)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Edit") { isEditing = true }
        }
        // redraw with the saved values once the edit sheet closes
        .sheet(isPresented: $isEditing, onDismiss: { viewModel.refresh() }) {
            NavigationStack {
                PokemonUpdateView(pokemon: viewModel.pokemon)
            }
        }
    }

    // small helper, keeps body readable
    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
        }
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokemon: .preview)
    }
}
