//
//  ContentView.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 12/08/26.
//

import SwiftUI

struct PokemonHomeView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    PokemonAddView()
                } label: {
                    Label("Add new Pokemon", systemImage: "plus.circle")
                }

                NavigationLink {
                    PokemonListView()
                } label: {
                    Label("View all Pokemon", systemImage: "list.bullet")
                }
            }
            .navigationTitle("Pokemon Pulse")
        }
    }
}

#Preview {
    PokemonHomeView()
}

