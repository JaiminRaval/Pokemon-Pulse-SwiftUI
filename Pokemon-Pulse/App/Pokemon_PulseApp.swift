//
//  Pokemon_PulseApp.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 12/08/26.
//

import SwiftUI
import CoreData
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Pokemon_PulseApp: App {
    let persistenceController = PersistenceController.shared
    //
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            PokemonHomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
