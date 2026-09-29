//
//  Plant.swift
//  Plant_disease
//
//  Created by Sachin  on 09/07/26.
//


import Foundation

struct Plant: Identifiable, Hashable {
    let id: String          // e.g. "tomato"
    let displayName: String // e.g. "Tomato"
    let imageName: String   // asset name for thumbnail
    let modelFileName: String // matches your .mlmodel class name, e.g. "PlantDisease_tomato"
    let diseaseJSONName: String // e.g. "tomato_diseases"
}

struct DiseaseInfo: Codable {
    let displayName: String
    let cause: String
    let symptoms: String
    let treatment: [String]
    let prevention: String
}

