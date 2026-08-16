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
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    PokemonArtworkView(urlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png")
}
