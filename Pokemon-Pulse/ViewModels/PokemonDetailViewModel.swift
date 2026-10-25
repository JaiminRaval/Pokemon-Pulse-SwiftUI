//
//  PokemonDetailViewModel.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 16/08/26.
//

import CoreData
import Combine

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    let pokemon: PokemonModel

    init(pokemon: PokemonModel) {
        self.pokemon = pokemon
    }

    // display ready values, so the view never deals with optionals
    var name: String { pokemon.name ?? "Unknown" }
    var type: String { text(pokemon.type) }
    var ability: String { text(pokemon.ability) }
    var nature: String { text(pokemon.nature) }
    var attackType: String { text(pokemon.attackType) }
    var color: String { text(pokemon.color) }
    var level: String { "\(pokemon.level)" }
    var gen: String { "\(pokemon.gen)" }
    var imageURL: String { pokemon.img ?? "" }

    // call after an edit so the view redraws with the new values
    func refresh() {
        objectWillChange.send()
    }

    private func text(_ value: String?) -> String {
        guard let value, !value.isEmpty else { return "-" }
        return value
    }
}

#if DEBUG
extension PokemonModel {
    // unsaved sample object, only used by SwiftUI previews
    static var preview: PokemonModel {
        let pokemon = PokemonModel(context: PersistenceController.shared.container.viewContext)
        pokemon.id = UUID()
        pokemon.name = "Pikachu"
        pokemon.type = "Electric"
        pokemon.ability = "Static"
        pokemon.nature = "Timid"
        pokemon.attackType = "Special"
        pokemon.color = "Yellow"
        pokemon.img = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png"
        pokemon.gen = 1
        pokemon.level = 10
        return pokemon
    }
}
#endif
//import Foundation
//import Combine
//
//// one json object standing in for a single row from the seed data
//private let samplePokemonJSON = """
//{
//  "id": "3A8F1E2D-9B4C-4A1F-8E2D-1C6B7A9F0E3D",
//  "ability": "Static",
//  "attackType": "Special",
//  "color": "Yellow",
//  "gen": 1,
//  "img": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png",
//  "level": 10,
//  "name": "Pikachu",
//  "nature": "Timid",
//  "type": "Electric"
//}
//"""
//
//@MainActor
//final class PokemonDetailViewModel: ObservableObject {
//    @Published private(set) var pokemon: Pokemon?
//
//    init() {
//        // tiny local decode, no need for async work here
//        guard let data = samplePokemonJSON.data(using: .utf8) else { return }
//        pokemon = try? JSONDecoder().decode(Pokemon.self, from: data)
//    }
//}
