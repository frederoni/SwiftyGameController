import UIKit
import SwiftyGameController

class ViewController: UIViewController {
    
    var controller: GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = GameController()
        
        controller.setStickChangedHandler { (joystickType, offset) in
            
        }
        
        controller.setButtonChangedHandler { (buttonType, value, pressed) in
            
        }
    }
}



