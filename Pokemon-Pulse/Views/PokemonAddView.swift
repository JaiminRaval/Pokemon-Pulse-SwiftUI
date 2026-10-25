//
//  PokemonAddView.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 25/08/26.
//

import SwiftUI

struct PokemonAddView: View {
    @StateObject private var viewModel = PokemonAddViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            PokemonFormFields(draft: $viewModel.draft)
        }
        .navigationTitle("New Pokemon")
        .toolbar {
            Button("Save") {
                // go back home only if the save worked
                if viewModel.save() { dismiss() }
            }
            .disabled(!viewModel.draft.isValid)
        }
    }
}

// form sections shared by the add and update screens
struct PokemonFormFields: View {
    @Binding var draft: PokemonDraft

    private let attackTypes = ["Physical", "Special", "Status"]

    var body: some View {
        Section("Basics") {
            TextField("Name", text: $draft.name)
            TextField("Type, e.g. Fire/Flying", text: $draft.type)
            TextField("Color", text: $draft.color)
        }

        Section("Battle") {
            TextField("Ability", text: $draft.ability)
            TextField("Nature", text: $draft.nature)

            Picker("Attack type", selection: $draft.attackType) {
                ForEach(attackTypes, id: \.self) { Text($0) }
            }

            Stepper("Level: \(draft.level)", value: $draft.level, in: 1...100)
            Stepper("Generation: \(draft.gen)", value: $draft.gen, in: 1...9)
        }

        Section("Artwork") {
            TextField("Image URL", text: $draft.img)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            // live preview so you can check the link before saving
            if !draft.img.isEmpty {
                PokemonArtworkView(urlString: draft.img)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PokemonAddView()
    }
}
