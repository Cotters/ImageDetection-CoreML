import UIKit
import MobileCoreServices
import Vision
import CoreML
import AVKit

class ViewController: UIViewController {
  
  @IBOutlet var topView: UIView!
  @IBOutlet var objectLabel: UILabel!
  @IBOutlet var confidenceLabel: UILabel!
  
  var cameraLayer: CALayer!
  var gameTimer: Timer!
  var timeRemaining = 60
  var currentScore = 0
  var highScore = 0
  
  lazy var predictor = ImagePredictionService(predictionCompletionHandler: handleObjectIdentification)

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCamera()
  }
  
  func setupCamera() {
    let captureSession = AVCaptureSession()
    captureSession.sessionPreset = AVCaptureSession.Preset.photo
    guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
      let input = try? AVCaptureDeviceInput(device: backCamera)
      else { handleCameraSetupFailure(); return }
    captureSession.addInput(input)
    
    cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    view.layer.addSublayer(cameraLayer)
    cameraLayer.frame = view.bounds
    
    view.bringSubviewToFront(topView)
    
    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "buffer delegate"))
    videoOutput.recommendedVideoSettings(forVideoCodecType: .jpeg, assetWriterOutputFileType: .mp4)
    
    captureSession.addOutput(videoOutput)
    captureSession.sessionPreset = .high
    captureSession.startRunning()
  }
  
  func handleCameraSetupFailure() {
    print("\n\n * Error setting up camera capture session")
  }
  
  func handleObjectIdentification(objectName: String, confidence: VNConfidence) {
    self.objectLabel.text = objectName
    self.confidenceLabel.text = "Confidence: \(confidence)"
  }
  
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { fatalError("Pixel buffer is nil") }
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    let context = CIContext(options: nil)
    
    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { fatalError("Failed to make CGImage") }
    guard let videoFrame = UIImage(cgImage: cgImage, scale: 1.0, orientation: .leftMirrored).cgImage else { return }
    DispatchQueue.main.sync {
      predictor.predict(image: videoFrame)
    }
  }
  
}
