//
//  PokemonModel.swift
//  Pokemon-Pulse
//
//  Created by Jaimin Raval on 16/08/26.
//

import Foundation

// this file is for future ref. when we fetch data from REST API.
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
