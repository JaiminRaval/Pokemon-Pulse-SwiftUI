//
//  Pokemon_PulseApp.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 12/08/26.
//

import SwiftUI
import CoreData

@main
struct Pokemon_PulseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PokemonHomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
