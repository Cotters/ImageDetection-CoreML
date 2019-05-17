import UIKit
import MobileCoreServices
import Vision
import CoreML
import AVKit

class ViewController: UIViewController {
  
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
    
  }
}
