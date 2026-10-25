//
//  PokemonUpdateViewModel.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 12/08/26.
//

import CoreData
import Combine

@MainActor
final class PokemonUpdateViewModel: ObservableObject {
    @Published var draft: PokemonDraft

    private let pokemon: PokemonModel
    private let context: NSManagedObjectContext

    init(pokemon: PokemonModel) {
        self.pokemon = pokemon
        self.context = pokemon.managedObjectContext ?? PersistenceController.shared.container.viewContext
        self.draft = PokemonDraft(pokemon: pokemon)
    }

    // writes the edited values back, returns true on success
    func save() -> Bool {
        guard draft.isValid else { return false }

        draft.apply(to: pokemon)

        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            print("Update failed: \(error)")
            return false
        }
    }
}
