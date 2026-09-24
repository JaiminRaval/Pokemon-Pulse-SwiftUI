//
//  PokemonAddView.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 25/08/26.
//

import SwiftUI

// MARK: - Add View
struct PokemonAddView: View {
    @Environment(\.dismiss) private var dismiss

    /// Called with the new Pokémon when the user taps "Add".
    var onSave: (Pokemon) -> Void = { _ in }

    // Form state
    @State private var name = ""
    @State private var type = "Normal"
    @State private var attackType = "Physical"
    @State private var ability = ""
    @State private var nature = "Hardy"
    @State private var color = "Red"
    @State private var img = ""
    @State private var gen: Int16 = 1
    @State private var level: Int16 = 5

    @FocusState private var focusedField: Field?
    private enum Field { case name, ability, img }

    // Picker options
    private let types = [
        "Normal", "Fire", "Water", "Grass", "Electric", "Ice", "Fighting",
        "Poison", "Ground", "Flying", "Psychic", "Bug", "Rock", "Ghost",
        "Dragon", "Dark", "Steel", "Fairy"
    ]
    private let attackTypes = ["Physical", "Special", "Status"]
    private let natures = [
        "Hardy", "Lonely", "Brave", "Adamant", "Naughty", "Bold", "Docile",
        "Relaxed", "Impish", "Lax", "Timid", "Hasty", "Serious", "Jolly",
        "Naive", "Modest", "Mild", "Quiet", "Bashful", "Rash", "Calm",
        "Gentle", "Sassy", "Careful", "Quirky"
    ]
    private let colors = [
        "Red", "Blue", "Yellow", "Green", "Black",
        "Brown", "Purple", "Gray", "White", "Pink"
    ]

    // Validation
    private var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var trimmedAbility: String { ability.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var imageURL: URL? {
        let trimmed = img.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed), url.scheme?.hasPrefix("http") == true else { return nil }
        return url
    }
    private var isValid: Bool {
        !trimmedName.isEmpty && !trimmedAbility.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                imagePreviewSection

                Section("Basics") {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .ability }

                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) { Text($0) }
                    }

                    Picker("Color", selection: $color) {
                        ForEach(colors, id: \.self) { colorName in
                            HStack {
                                Circle()
                                    .fill(swatch(for: colorName))
                                    .frame(width: 12, height: 12)
                                    .overlay(Circle().stroke(.secondary.opacity(0.4), lineWidth: 0.5))
                                Text(colorName)
                            }
                            .tag(colorName)
                        }
                    }
                }

                Section("Battle") {
                    TextField("Ability", text: $ability)
                        .textInputAutocapitalization(.words)
                        .focused($focusedField, equals: .ability)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .img }

                    Picker("Attack type", selection: $attackType) {
                        ForEach(attackTypes, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)

                    Picker("Nature", selection: $nature) {
                        ForEach(natures, id: \.self) { Text($0) }
                    }
                }

                Section("Stats") {
                    Stepper(value: $level, in: 1...100) {
                        LabeledContent("Level", value: "\(level)")
                    }
                    Stepper(value: $gen, in: 1...9) {
                        LabeledContent("Generation", value: "\(gen)")
                    }
                }

                Section {
                    TextField("https://example.com/sprite.png", text: $img)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .img)
                        .submitLabel(.done)
                } header: {
                    Text("Image URL")
                } footer: {
                    if !img.isEmpty && imageURL == nil {
                        Text("Enter a full link starting with http:// or https://")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add Pokémon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { save() }
                        .disabled(!isValid)
                }
            }
        }
    }

    // MARK: - Subviews

    private var imagePreviewSection: some View {
        Section {
            HStack {
                Spacer()
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(swatch(for: color).opacity(0.2))
                            .frame(width: 120, height: 120)

                        if let url = imageURL {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().scaledToFit()
                                case .failure:
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.title)
                                        .foregroundStyle(.secondary)
                                default:
                                    ProgressView()
                                }
                            }
                            .frame(width: 96, height: 96)
                        } else {
                            Image(systemName: "photo")
                                .font(.system(size: 36))
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text(trimmedName.isEmpty ? "New Pokémon" : trimmedName)
                        .font(.headline)
                    Text("\(type) · Lv. \(level)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.clear)
    }

    // MARK: - Helpers

    private func save() {
//        let pokemon = Pokemon(
//            id: UUID(),
//            ability: trimmedAbility,
//            attackType: attackType,
//            color: color,
//            img: img.trimmingCharacters(in: .whitespacesAndNewlines),
//            gen: gen,
//            level: level,
//            name: trimmedName,
//            nature: nature,
//            type: type
//        )
//        dismiss()
    }

//    private func swatch(for name: String) -> Color {
//        switch name {
//        case "Red": return .red
//        case "Blue": return .blue
//        case "Yellow": return .yellow
//        case "Green": return .green
//        case "Black": return .black
//        case "Brown": return .brown
//        case "Purple": return .purple
//        case "Gray": return .gray
//        case "White": return .white
//        case "Pink": return .pink
//        default: return .gray
//        }
//    }
}

// MARK: - Preview

#Preview {
    PokemonAddView { pokemon in
        print("Added:", pokemon)
    }
}
