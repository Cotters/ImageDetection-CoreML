import UIKit
import CoreML
import Vision

struct ImagePredictionService {
  
  var predictionCompletionHandler: (String, VNConfidence) -> ()?
  
  func predict(image: CGImage) {
    let model = try! VNCoreMLModel(for: Inceptionv3().model)
    let request = VNCoreMLRequest(model: model, completionHandler: results)
    request.imageCropAndScaleOption = .centerCrop
    let handler = VNSequenceRequestHandler()
    try! handler.perform([request], on: image)
  }
  
  private func results(request: VNRequest, error: Error?) {
    guard let results = request.results as? [VNClassificationObservation] else {
      print("\n\n * Failed to process object analysis from recording.")
      return
    }
    ()
    guard let highestConfidenceResult = results.first else {
      print("\n\n * Object could not be classified.")
      return
    }
    
    let identifier = highestConfidenceResult.identifier
    let confidence = highestConfidenceResult.confidence
    predictionCompletionHandler(identifier, confidence)
  }
  
}
