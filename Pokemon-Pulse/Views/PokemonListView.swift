//
//  PokemonListView.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 12/08/26.
//

import SwiftUI
import CoreData

struct PokemonListView: View {
    @StateObject private var fetchViewModel = PokemonFetchViewModel()
    @StateObject private var deleteViewModel = PokemonDeleteViewModel()

    var body: some View {
        List {
            ForEach(fetchViewModel.pokemons, id: \.objectID) { pokemon in
                NavigationLink {
                    PokemonDetailView(pokemon: pokemon)
                } label: {
                    HStack(spacing: 12) {
                        PokemonArtworkView(urlString: pokemon.img ?? "")
                            .frame(width: 44, height: 44)

                        VStack(alignment: .leading) {
                            Text(pokemon.name ?? "Unknown")
                                .font(.headline)
                            Text(pokemon.type ?? "")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text("Lv \(pokemon.level)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("All Pokemon")
        .toolbar { EditButton() }
        .overlay {
            if fetchViewModel.pokemons.isEmpty {
                ContentUnavailableView {
                    Label("No Pokemon yet", systemImage: "tray")
                } description: {
                    Text("Add one from the home screen, or load the sample data.")
                } actions: {
                    Button("Load sample data") {
                        fetchViewModel.loadSampleData()
                    }
                }
            }
        }
        // refetch every time the screen shows, so adds and edits appear
        .onAppear {
            fetchViewModel.fetchAll()
        }
    }

    // swipe to delete, then reload the list
    private func delete(at offsets: IndexSet) {
        let selected = offsets.map { fetchViewModel.pokemons[$0] }
        deleteViewModel.delete(selected)
        fetchViewModel.fetchAll()
    }
}

#Preview {
    NavigationStack {
        PokemonListView()
    }
}
