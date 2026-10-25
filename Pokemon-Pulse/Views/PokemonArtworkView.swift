//
//  PokemonArtworkView.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 16/08/26.
//

import SwiftUI

// native AsyncImage, no third party lib needed
// phase gives clean states without extra @State vars
struct PokemonArtworkView: View {
    let urlString: String

    var body: some View {
        if let url = URL(string: urlString), !urlString.isEmpty {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    placeholder
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            // no link entered, skip the network call
            placeholder
        }
    }

    private var placeholder: some View {
        Image(systemName: "photo")
            .foregroundStyle(.secondary)
    }
}

#Preview {
    PokemonArtworkView(urlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png")
}
