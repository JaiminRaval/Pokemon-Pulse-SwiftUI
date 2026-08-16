//
//  PokemonDetailView.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 12/08/26.
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject private var viewModel = PokemonDetailViewModel()

    var body: some View {
        VStack(spacing: 16) {
            if let pokemon = viewModel.pokemon {
                PokemonArtworkView(urlString: pokemon.img)
                    .frame(width: 220, height: 220)

                Text(pokemon.name)
                    .font(.title.bold())

                Text(pokemon.type)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    row("ability", pokemon.ability)
                    row("nature", pokemon.nature)
                    row("level", "\(pokemon.level)")
                    row("gen", "\(pokemon.gen)")
                }
                .padding(.top, 8)
            } else {
                ProgressView()
            }
        }
        .padding()
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
    PokemonDetailView()
}
