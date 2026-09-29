import Foundation

//
//  ScanRecord.swift
//  Plant_disease
//
//  Created by Sachin  on 10/07/26.
//

struct ScanRecord: Identifiable, Codable {
    var id = UUID() // Standard way to handle Identifiable lists in SwiftUI
    let plantName: String
    let diseaseLabel: String
    let confidence: Double
    let date: Date
    let imageData: Data
}

