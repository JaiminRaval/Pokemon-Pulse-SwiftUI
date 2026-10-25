//
//  PokemonUpdateView.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 12/08/26.
//

import SwiftUI

struct PokemonUpdateView: View {
    @StateObject private var viewModel: PokemonUpdateViewModel
    @Environment(\.dismiss) private var dismiss

    init(pokemon: PokemonModel) {
        _viewModel = StateObject(wrappedValue: PokemonUpdateViewModel(pokemon: pokemon))
    }

    var body: some View {
        Form {
            PokemonFormFields(draft: $viewModel.draft)
        }
        .navigationTitle("Edit Pokemon")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if viewModel.save() { dismiss() }
                }
                .disabled(!viewModel.draft.isValid)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PokemonUpdateView(pokemon: .preview)
    }
}
