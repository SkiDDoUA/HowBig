//
//  Predictor.swift
//  HowBig
//
//  Created by Anton on 07.07.2022.
//

import UIKit
import Vision

typealias Prediction = (String, Float)

class Predictor {
    private var completion: (([Prediction]?) -> Void)?

    lazy var model: VNCoreMLModel = {
        let config = MLModelConfiguration()
        let baseModel = try! dog_classifier(configuration: config)
        return try! VNCoreMLModel(for: baseModel.model)
    }()

    func predict(image: UIImage, completion: @escaping ([Prediction]?) -> Void) {
        self.completion = completion
        let request = classificationRequest()
        let handler = VNImageRequestHandler(
          cgImage: image.cgImage!,
          orientation: CGImagePropertyOrientation(image.imageOrientation)
        )

        do {
          try handler.perform([request])
        } catch {
          print(error)
        }
    }

    private func classificationRequest() -> VNImageBasedRequest {
        let request = VNCoreMLRequest(model: model, completionHandler: requestHandler)
        request.imageCropAndScaleOption = .centerCrop
        return request
    }

    private func requestHandler(_ request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNClassificationObservation]
        else { return }
        completion?(observations.map { ($0.identifier, $0.confidence) })
    }
}

extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
            case .up: self = .up
            case .down: self = .down
            case .left: self = .left
            case .right: self = .right
            case .upMirrored: self = .upMirrored
            case .downMirrored: self = .downMirrored
            case .leftMirrored: self = .leftMirrored
            case .rightMirrored: self = .rightMirrored
            @unknown default: self = .up
        }
    }
}
