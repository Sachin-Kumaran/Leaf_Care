//
//  ScanHistoryStore.swift
//  Plant_disease
//
//  Created by Sachin  on 09/07/26.
//

import Foundation
import UIKit
import Combine

class ScanHistoryStore: ObservableObject {
    static let shared = ScanHistoryStore()
    
    @Published var records: [ScanRecord] = [] {
        didSet {
            saveToDisk()
        }
    }
    
    // File URL where history will be safely saved
    private let saveURL: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directory = paths.first ?? FileManager.default.temporaryDirectory
        return directory.appendingPathComponent("scan_history.json")
    }()
    
    private init() {
        loadFromDisk()
    }
    
    func save(plant: String, label: String, confidence: Double, image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.6) else { return }
        let record = ScanRecord(plantName: plant, diseaseLabel: label, confidence: confidence, date: Date(), imageData: data)
        
        // Inserting at 0 keeps the newest scans at the top of the history list
        records.insert(record, at: 0)
    }
    
    // MARK: - Persistence Logic
    
    private func saveToDisk() {
        let snapshot = records
        let url = saveURL
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(snapshot)
                try data.write(to: url, options: [.atomic, .completeFileProtection])
            } catch {
                print("Failed to save scan history to disk: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadFromDisk() {
        do {
            let data = try Data(contentsOf: saveURL)
            let decodedRecords = try JSONDecoder().decode([ScanRecord].self, from: data)
            self.records = decodedRecords
        } catch {
            // This is expected on the first launch when no file exists yet
            print("No previous scan history found, starting fresh.")
            self.records = []
        }
    }
}
