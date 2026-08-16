//
//  PokemonDetailViewModel.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 16/08/26.
//

import Foundation
import Combine

// one json object standing in for a single row from the seed data
private let samplePokemonJSON = """
{
  "id": "3A8F1E2D-9B4C-4A1F-8E2D-1C6B7A9F0E3D",
  "ability": "Static",
  "attackType": "Special",
  "color": "Yellow",
  "gen": 1,
  "img": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png",
  "level": 10,
  "name": "Pikachu",
  "nature": "Timid",
  "type": "Electric"
}
"""

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published private(set) var pokemon: Pokemon?

    init() {
        // tiny local decode, no need for async work here
        guard let data = samplePokemonJSON.data(using: .utf8) else { return }
        pokemon = try? JSONDecoder().decode(Pokemon.self, from: data)
    }
}
