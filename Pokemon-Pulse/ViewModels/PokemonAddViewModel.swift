//
//  PokemonAddViewModel.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 24/08/26.
//

import CoreData
import Combine

// plain form state shared by the add and update screens,
// keeps core data objects out of the text fields
struct PokemonDraft {
    var name = ""
    var type = ""
    var ability = ""
    var nature = ""
    var attackType = "Physical"
    var color = ""
    var img = ""
    var gen: Int16 = 1
    var level: Int16 = 1

    // name is the only required field
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init() {}

    // prefill from an existing pokemon when editing
    init(pokemon: PokemonModel) {
        name = pokemon.name ?? ""
        type = pokemon.type ?? ""
        ability = pokemon.ability ?? ""
        nature = pokemon.nature ?? ""
        attackType = pokemon.attackType ?? "Physical"
        color = pokemon.color ?? ""
        img = pokemon.img ?? ""
        gen = pokemon.gen
        level = pokemon.level
    }

    // copies the form values onto a core data object
    func apply(to pokemon: PokemonModel) {
        pokemon.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        pokemon.type = type
        pokemon.ability = ability
        pokemon.nature = nature
        pokemon.attackType = attackType
        pokemon.color = color
        pokemon.img = img.trimmingCharacters(in: .whitespacesAndNewlines)
        pokemon.gen = gen
        pokemon.level = level
    }
}

@MainActor
final class PokemonAddViewModel: ObservableObject {
    @Published var draft = PokemonDraft()

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    // returns true when saved, so the view knows it can close
    func save() -> Bool {
        guard draft.isValid else { return false }

        let pokemon = PokemonModel(context: context)
        pokemon.id = UUID()
        draft.apply(to: pokemon)

        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            print("Add failed: \(error)")
            return false
        }
    }
}
