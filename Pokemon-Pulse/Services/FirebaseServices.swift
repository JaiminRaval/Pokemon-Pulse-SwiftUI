//
//  FirebaseServices.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 25/08/26.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

final class FirebaseServices {

    let db = Firestore.firestore()
    let collectionRef: CollectionReference
    
    static let shared = FirebaseServices()
    //  Firestore doesn't require an explicit "create collection" step.
    //  a collection appears automatically the first time you write a document into it.
    //  So the code below just handles adding your Pokemon data using your existing Codable struct, with a single-add function.
    init(collectionName: String = "Pokemon-Pulse-Data") {
        self.collectionRef = db.collection(collectionName)
    }
    //  Adds a single Pokemon document, using the Pokemon's UUID as the document ID.
    // MARK: - Create (One Pokemon at a time)
    func addPokemon(_ newPokemon: Pokemon) async throws {
        try collectionRef
            .document(newPokemon.id.uuidString)
            .setData(from: newPokemon)
    }

    // MARK: - Read (one-shot fetch)
    func fetchAll() async throws -> [Pokemon] {
        let snapshot = try await collectionRef.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Pokemon.self) }
    }

    // MARK: - Read (live updates)
    /// Keeps the UI in sync automatically after any create/update/delete,
    /// so the view layer never has to manually refetch or splice arrays.
    func listen(onChange: @escaping ([Pokemon]) -> Void) -> ListenerRegistration {
        collectionRef.addSnapshotListener { snapshot, error in
            guard let snapshot else {
                if let error { print("Pokemon listener error: \(error)") }
                return
            }
            onChange(snapshot.documents.compactMap { try? $0.data(as: Pokemon.self) })
        }
    }

    // MARK: - Update
    func update(_ pokemon: Pokemon) async throws {
        try collectionRef.document(pokemon.id.uuidString).setData(from: pokemon)
    }

    // MARK: - Delete
    func delete(_ pokemon: Pokemon) async throws {
        try await collectionRef.document(pokemon.id.uuidString).delete()
    }
    
}

/*
 
 i need to do CRUD for this pokemon data on firebase database.
 create both UI and View models for all 4 CRUD operations in SwiftUI, keep UI minimal.

 struct Pokemon: Codable {
     let id: UUID
     let ability: String
     let attackType: String
     let color: String
     let img: String
     let gen: Int16
     let level: Int16
     let name: String
     let nature: String
     let type: String
 }

 I already have this view for fetching images which you can use
 import SwiftUI
 // native AsyncImage, no third party lib needed
 // phase gives clean states without extra @State vars
 struct PokemonArtworkView: View {
     let urlString: String
     var body: some View {
         AsyncImage(url: URL(string: urlString)) { phase in
             switch phase {
             case .empty:
                 ProgressView()
             case .success(let image):
                 image
                     .resizable()
                     .scaledToFit()
             case .failure:
                 Image(systemName: "photo")
                     .foregroundStyle(.secondary)
             @unknown default:
                 EmptyView()
             }
         }
     }
 }

 you can do it and do it gracefully
 
 I went with Firestore (document-per-Pokemon, keyed by `id.uuidString`), since it maps cleanly onto Codable structs. Quick tour of the six files:

 - **PokemonRepository** — the only place touching Firestore. `create`, `fetchAll`, `listen` (realtime), `update`, `delete`.
 - **PokemonListViewModel** — Read + Delete. Uses a snapshot listener, so the list updates itself after any write anywhere in the app — no manual refetching.
 - **PokemonFormViewModel** — Create + Update, one shared implementation. If it's handed a `Pokemon`, it's editing; otherwise it's creating.
 - **PokemonListView** — plain `List` with your `PokemonArtworkView` as the thumbnail, swipe-to-delete, `+` to add.
 - **PokemonFormView** — one `Form` reused for both add and edit.

 Setup (two steps, not in the files since they're app-wide):
 1. Add the Firebase SDK via SPM (`https://github.com/firebase/firebase-ios-sdk`), pick the **FirebaseFirestore** and **FirebaseCore** products. You don't need `FirebaseFirestoreSwift` — its Codable support (`setData(from:)`, `data(as:)`) has lived inside `FirebaseFirestore` since SDK 10.17.
 2. Call `FirebaseApp.configure()` once, in your `App`'s `init()`.

 Then `PokemonListView()` is your entry point. One thing worth flagging: there are no Firestore security rules here — as written, anyone can read/write the `pokemons` collection, which is fine for prototyping but you'll want rules before shipping.
 */
