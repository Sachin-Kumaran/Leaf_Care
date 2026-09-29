//
//  DiseaseDatabase.swift
//  Plant_disease
//
//  Created by Sachin  on 09/07/26.
//


import Foundation

class DiseaseDatabase {
    static func load(for plant: Plant) -> [String: DiseaseInfo] {
        guard let url = Bundle.main.url(forResource: plant.diseaseJSONName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([String: DiseaseInfo].self, from: data) else {
            return [:]
        }
        return decoded
    }
}