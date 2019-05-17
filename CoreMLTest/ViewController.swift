import UIKit
import MobileCoreServices
import Vision
import CoreML
import AVKit

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
  
  @IBOutlet var topView: UIView!
  @IBOutlet var objectLabel: UILabel!
  @IBOutlet var scoreLabel: UILabel!
  
  var cameraLayer: CALayer!
  var gameTimer: Timer!
  var timeRemaining = 60
  var currentScore = 0
  var highScore = 0

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
  
}
