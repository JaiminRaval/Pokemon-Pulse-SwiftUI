//
//  PokemonDeleteViewModel.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 24/08/26.
//

import CoreData
import Combine

@MainActor
final class PokemonDeleteViewModel: ObservableObject {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func delete(_ pokemons: [PokemonModel]) {
        for pokemon in pokemons {
            context.delete(pokemon)
        }

        do {
            try context.save()
        } catch {
            context.rollback()
            print("Delete failed: \(error)")
        }
    }
}
