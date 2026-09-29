//
//  PlantModelRegistry.swift
//  Plant_disease
//
//  Created by Sachin  on 09/07/26.
//


import Foundation

struct PlantModelRegistry {
    static let all: [Plant] = [
        Plant(id: "apple", displayName: "Apple", imageName: "apple_thumb",
              modelFileName: "Apple_ML", diseaseJSONName: "Apple_diseases"),
        Plant(id: "cherry", displayName: "Cherry", imageName: "cherry_thumb",
              modelFileName: "Cherry_ML", diseaseJSONName: "Cherry_diseases"),
        Plant(id: "corn", displayName: "Corn", imageName: "corn_thumb",
              modelFileName: "Corn_ML", diseaseJSONName: "Corn_diseases"),
        Plant(id: "grape", displayName: "Grape", imageName: "grape_thumb",
              modelFileName: "Grape_ML", diseaseJSONName: "Grape_diseases"),
        Plant(id: "potato", displayName: "Potato", imageName: "potato_thumb",
              modelFileName: "Potato_ML", diseaseJSONName: "Potato_diseases"),
        Plant(id: "tomato", displayName: "Tomato", imageName: "tomato_thumb",
              modelFileName: "Tomato_ML", diseaseJSONName: "Tomato_diseases")
    ]
}
