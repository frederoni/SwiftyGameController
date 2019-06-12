import Foundation
import GameController

protocol HardwareControllerDelegate {
    func hardwareControllerDidConnect()
    func hardwareControllerDidDisconnect()
}

class HardwareController : NSObject {
    
    var delegate: HardwareControllerDelegate?
    
    var thumbstickChangedHandler: StickChangedHandler?
    var buttonChangedHandler: ButtonChangedHandler?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(connectController(notification:)), name: Notification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectController(notification:)), name: Notification.Name.GCControllerDidDisconnect, object: nil)
        
        if let controller = GCController.controllers().first {
            attachController(controller: controller)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.GCControllerDidDisconnect, object: nil)
    }
    
    @objc func connectController(notification: Notification) {
        if let controller = GCController.controllers().first {
            attachController(controller: controller)
        }
    }
    
    @objc func disconnectController(notification: Notification) {
        delegate?.hardwareControllerDidDisconnect()
    }
    
    func attachController(controller: GCController) {
        controller.handlerQueue = DispatchQueue(label: "com.frederoni.SwiftGameController")
        
        // A-B-X-Y buttons
        controller.extendedGamepad?.buttonA.valueChangedHandler = {[weak self] (input, value, pressed) in
            self?.buttonChangedHandler?(.A, value, pressed)
        }
        controller.extendedGamepad?.buttonB.valueChangedHandler = {[weak self] (input, value, pressed) in
            self?.buttonChangedHandler?(.B, value, pressed)
        }
        controller.extendedGamepad?.buttonX.valueChangedHandler = {[weak self] (input, value, pressed) in
            self?.buttonChangedHandler?(.X, value, pressed)
        }
        controller.extendedGamepad?.buttonY.valueChangedHandler = {[weak self] (input, value, pressed) in
            self?.buttonChangedHandler?(.Y, value, pressed)
        }
        
        // Trigger buttons
        controller.extendedGamepad?.leftTrigger.valueChangedHandler = {[weak self] (input, value, pressed) in
            self?.buttonChangedHandler?(.leftTrigger, value, pressed)
        }
        
        controller.extendedGamepad?.rightTrigger.valueChangedHandler = {[weak self] (input, value, pressed) in
            self?.buttonChangedHandler?(.rightTrigger, value, pressed)
        }
        
        // Shoulder buttons
        controller.extendedGamepad?.leftShoulder.valueChangedHandler = {[unowned self] (input, value, pressed) in
            self.buttonChangedHandler?(.leftShoulder, value, pressed)
        }
        
        controller.extendedGamepad?.rightShoulder.valueChangedHandler = {[unowned self] (input, value, pressed) in
            self.buttonChangedHandler?(.rightShoulder, value, pressed)
        }
        
        // Thumbsticks
        controller.extendedGamepad?.leftThumbstick.valueChangedHandler = {[weak self] (directionPad, x, y) in
            self?.thumbstickChangedHandler?(.leftThumbstick, CGVector(dx: Double(x), dy: Double(y)))
        }
        controller.extendedGamepad?.rightThumbstick.valueChangedHandler = {[weak self] (directionPad, x, y) in
            self?.thumbstickChangedHandler?(.rightThumbstick, CGVector(dx: Double(x), dy: Double(y)))
        }
        
        delegate?.hardwareControllerDidConnect()
    }
    
}

