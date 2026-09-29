//
//  DiseaseClassifier 2.swift
//  Plant_disease
//
//  Created by Sachin  on 09/07/26.
//


import Vision
import CoreML
import UIKit
import ImageIO

class DiseaseClassifier {
    private static var modelCache = [String: VNCoreMLModel]()
    private static let cacheLock = NSLock()

    static func loadModel(for plant: Plant) -> VNCoreMLModel? {
        cacheLock.lock()
        defer { cacheLock.unlock() }

        if let cached = modelCache[plant.id] {
            return cached
        }

        do {
            let loadedModel: VNCoreMLModel?
            switch plant.id {
            case "apple":
                let model = try Apple_ML(configuration: MLModelConfiguration())
                loadedModel = try VNCoreMLModel(for: model.model)
            case "cherry":
                let model = try Cherry_ML(configuration: MLModelConfiguration())
                loadedModel = try VNCoreMLModel(for: model.model)
            case "corn":
                let model = try Corn_ML(configuration: MLModelConfiguration())
                loadedModel = try VNCoreMLModel(for: model.model)
            case "grape":
                let model = try Grape_ML(configuration: MLModelConfiguration())
                loadedModel = try VNCoreMLModel(for: model.model)
            case "tomato":
                let model = try Tomato_ML(configuration: MLModelConfiguration())
                loadedModel = try VNCoreMLModel(for: model.model)
            case "potato":
                let model = try Potato_ML(configuration: MLModelConfiguration())
                loadedModel = try VNCoreMLModel(for: model.model)
            default:
                loadedModel = nil
            }

            if let loadedModel = loadedModel {
                modelCache[plant.id] = loadedModel
            }
            return loadedModel
        } catch {
            print("Model load error: \(error)")
            return nil
        }
    }

    static func classify(image: UIImage, plant: Plant, completion: @escaping (String, Double) -> Void) {
        let dispatchCompletion: (String, Double) -> Void = { label, conf in
            DispatchQueue.main.async {
                completion(label, conf)
            }
        }

        guard let model = loadModel(for: plant) else {
            dispatchCompletion("Error: model unavailable for \(plant.displayName)", 0)
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                dispatchCompletion("Error: \(error.localizedDescription)", 0)
                return
            }
            guard let results = request.results as? [VNClassificationObservation],
                  let top = results.first else {
                dispatchCompletion("Unknown", 0)
                return
            }
            dispatchCompletion(top.identifier, Double(top.confidence))
        }
        request.imageCropAndScaleOption = .centerCrop

        let orientation = cgOrientation(from: image.imageOrientation)

        let handler: VNImageRequestHandler
        if let cgImage = image.cgImage {
            handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])
        } else if let ciImage = CIImage(image: image) {
            handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation, options: [:])
        } else {
            dispatchCompletion("Error: could not read image", 0)
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                dispatchCompletion("Error: \(error.localizedDescription)", 0)
            }
        }
    }

    private static func cgOrientation(from uiOrientation: UIImage.Orientation) -> CGImagePropertyOrientation {
        switch uiOrientation {
        case .up: return .up
        case .upMirrored: return .upMirrored
        case .down: return .down
        case .downMirrored: return .downMirrored
        case .left: return .left
        case .leftMirrored: return .leftMirrored
        case .right: return .right
        case .rightMirrored: return .rightMirrored
        @unknown default: return .up
        }
    }
}
