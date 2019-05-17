import UIKit
import CoreML
import Vision

struct ImagePredictionService {
  
  var predictionCompletionHandler: (String) -> ()?
  
  func predict(image: CGImage) {
    let model = try! VNCoreMLModel(for: Inceptionv3().model)
    let request = VNCoreMLRequest(model: model, completionHandler: results)
    let handler = VNSequenceRequestHandler()
    try! handler.perform([request], on: image)
  }
  
  private func results(request: VNRequest, error: Error?) {
    guard let results = request.results as? [VNClassificationObservation] else {
      reportFailedImageAnalysis()
      return
    }
    
    guard let highestConfidenceResult = results.first else {
      print("\n\n * Object could not be classified.")
      return
    }
    let identifier = highestConfidenceResult.identifier
    predictionCompletionHandler(identifier)
  }
  
  private func reportFailedImageAnalysis() {
    print("\n\n * Failed to process object analysis from input capture stream (likely video recording).")
  }
  
}
