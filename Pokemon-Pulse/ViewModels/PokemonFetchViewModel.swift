//
//  PokemonFetchViewModel.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 24/08/26.
//

import CoreData
import Combine

@MainActor
final class PokemonFetchViewModel: ObservableObject {
    @Published private(set) var pokemons: [PokemonModel] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    // reads every saved pokemon, sorted by generation then name
    func fetchAll() {
        let request: NSFetchRequest<PokemonModel> = PokemonModel.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \PokemonModel.gen, ascending: true),
            NSSortDescriptor(keyPath: \PokemonModel.name, ascending: true)
        ]

        do {
            pokemons = try context.fetch(request)
        } catch {
            print("Fetch failed: \(error)")
            pokemons = []
        }
    }

    // fills the store from PokemonData.json, handy for testing
    func loadSampleData() {
        guard let url = Bundle.main.url(forResource: "PokemonData", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let items = try? JSONDecoder().decode([Pokemon].self, from: data) else {
            print("Could not read PokemonData.json from the app bundle")
            return
        }

        for item in items {
            let pokemon = PokemonModel(context: context)
            pokemon.id = item.id
            pokemon.name = item.name
            pokemon.type = item.type
            pokemon.ability = item.ability
            pokemon.nature = item.nature
            pokemon.attackType = item.attackType
            pokemon.color = item.color
            pokemon.img = item.img
            pokemon.gen = item.gen
            pokemon.level = item.level
        }

        do {
            try context.save()
            fetchAll()
        } catch {
            context.rollback()
            print("Sample import failed: \(error)")
        }
    }
}
