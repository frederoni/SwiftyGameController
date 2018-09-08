import Foundation
import GameController

public enum ButtonType : UInt16 {
    case A
    case B
    case X
    case Y
    case leftShoulder
    case rightShoulder
    case leftTrigger
    case rightTrigger
}

public enum JoystickType : UInt16 {
    case leftThumbstick
    case rightThumbstick
}

public enum ControllerConnectionState : UInt16 {
    case software
    case hardware
}

protocol ControllerDelegate {
    func controllerConnectionStateChanged(state: ControllerConnectionState)
}

public typealias ButtonChangedHandler = (ButtonType, Float, Bool) -> ()
public typealias StickChangedHandler = (JoystickType, CGVector) -> ()
public typealias PadChangedHandler = (JoystickType, CGVector) -> ()

@objc(FREGameController)
public class GameController : NSObject {
    
    var buttonA: Bool = false
    var buttonB: Bool = false
    var buttonX: Bool = false
    var buttonY: Bool = false
    
    let softwareController = SoftwareController()
    let hardwareController = HardwareController()
    
    public var buttonChangedHandler: ButtonChangedHandler?
    public var stickChangedHandler: StickChangedHandler?
    public var padChangedHandler: StickChangedHandler?
    
    var delegate: ControllerDelegate?
    
    override public init() {
        super.init()
        setupHardwareController()
        setupSoftwareController()
    }
    
    public func dockSoftwareController(on view: UIView) {
        softwareController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(softwareController.view)
        
        let views = ["view": softwareController.view]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-0-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: views))
    }
    
    public func setStickChangedHandler(handler: @escaping StickChangedHandler) {
        stickChangedHandler = handler
    }
    
    public func setButtonChangedHandler(handler: @escaping ButtonChangedHandler) {
        buttonChangedHandler = handler
    }
    
    func setupHardwareController() {
        hardwareController.delegate = self
        
        hardwareController.thumbstickChangedHandler = {[unowned self] (type, offset) in
            DispatchQueue.main.async {
                self.stickChangedHandler?(type, offset)
            }
        }
        
        hardwareController.buttonChangedHandler = {[unowned self] (type, value, pressed) in
            DispatchQueue.main.async {
                self.buttonChangedHandler?(type, value, pressed)
            }
        }
    }
    
    func setupSoftwareController() {
        softwareController.view.leftJoystick.stickChangedHandler = {[weak self] joystickType, offset in
            self?.stickChangedHandler?(joystickType, offset)
        }
        softwareController.view.rightJoystick.stickChangedHandler = {[weak self] joystickType, offset in
            self?.stickChangedHandler?(joystickType, offset)
        }
    }
    
}

extension GameController: HardwareControllerDelegate {
    func hardwareControllerDidConnect() {
        softwareController.view.isHidden = true
        delegate?.controllerConnectionStateChanged(state: .hardware)
    }
    
    func hardwareControllerDidDisconnect() {
        softwareController.view.isHidden = false
        delegate?.controllerConnectionStateChanged(state: .software)
    }
}



