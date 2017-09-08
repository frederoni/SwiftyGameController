import Foundation

extension CGSize {
    static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width*rhs, height: lhs.height*rhs)
    }
}

@IBDesignable
class JoystickView: UIView {
    
    let backgroundView = UIView()
    let dotView = UIView()
    let stickLayer = CAShapeLayer()
    let dotSize = CGSize(width: 30, height: 30)
    
    var backgroundSize: CGSize { return dotSize * 3 }
    
    var stickChangedHandler: StickChangedHandler?
    
    var joystickType: JoystickType = .leftThumbstick
    var invertedY = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        isUserInteractionEnabled = true
        
        backgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2995433539)
        backgroundView.layer.cornerRadius = backgroundSize.width/2
        
        stickLayer.lineWidth = 8
        stickLayer.strokeColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        stickLayer.lineCap = kCALineCapRound
        
        dotView.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        dotView.layer.cornerRadius = dotSize.width/2
        dotView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        dotView.layer.borderWidth = 2
        
        addSubview(backgroundView)
        backgroundView.layer.addSublayer(stickLayer)
        addSubview(dotView)
    }
    
    override var intrinsicContentSize: CGSize {
        return backgroundSize
    }
    
    func touchEvent(touches: Set<UITouch>) {
        for touch: AnyObject in touches {
            
            let location = touch.location(in: self)
            let radius = bounds.midX
            let baseCenter = CGPoint(x: radius, y: radius)
            
            if location.distance(between: baseCenter) < radius {
                dotView.center = location
                updateStickLayer(point: location)
                reportPosition()
            } else {
                let delta = CGVector(dx: location.x-radius, dy: location.y - radius)
                let angle = atan2(delta.dy, delta.dx)
                let xDistance: CGFloat = sin(angle - .pi / 2) * radius
                let yDistance: CGFloat = cos(angle - .pi / 2) * radius
                
                let point = CGPoint(x: baseCenter.x-xDistance, y: baseCenter.y+yDistance)
                dotView.center = point
                updateStickLayer(point: point)
                reportPosition()
            }
        }
    }
    
    func reportPosition() {
        let maxDelta = backgroundView.bounds.width / 2
        let dx: CGFloat = dotView.center.x - backgroundView.center.x
        var dy: CGFloat = dotView.center.y - backgroundView.center.y
        if invertedY {
            dy = dy * -1
        }
        let offset = CGVector(dx: dx.scaled(minimumIn: -maxDelta, maximumIn: maxDelta, minimumOut: -1, maximumOut: 1),
                              dy: dy.scaled(minimumIn: -maxDelta, maximumIn: maxDelta, minimumOut: -1, maximumOut: 1))
        stickChangedHandler?(joystickType, offset)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEvent(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEvent(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetStick()
    }
    
    func resetStick() {
        let view = dotView
        let bgView = backgroundView
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            view.center = CGPoint(x: bgView.bounds.midX, y: bgView.bounds.midY)
            self.updateStickLayer(point: bgView.center)
        }, completion: nil)
        
        stickChangedHandler?(joystickType, CGVector(dx: 0, dy: 0))
    }
    
    func updateStickLayer(point: CGPoint) {
        let stickPath = UIBezierPath()
        stickPath.move(to: backgroundView.center)
        stickPath.addLine(to: point)
        stickLayer.path = stickPath.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dotView.frame = CGRect(origin: CGPoint(x: bounds.midX-dotSize.width/2, y: bounds.midY-dotSize.height/2),
                                 size: dotSize)
        
        backgroundView.frame = CGRect(origin: CGPoint(x: bounds.midX-backgroundSize.width/2, y: bounds.midY-backgroundSize.height/2),
                                      size: backgroundSize)
        stickLayer.frame = backgroundView.bounds
    }
}

@IBDesignable
class SoftwareControllerView: UIView {
    let leftJoystick = JoystickView()
    let rightJoystick = JoystickView()
    
    var padding: CGFloat = 20
    var height: CGFloat = 130
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: height)
    }
    
    func commonInit() {
        backgroundColor = .clear
        isUserInteractionEnabled = true
        leftJoystick.translatesAutoresizingMaskIntoConstraints = false
        leftJoystick.invertedY = true
        rightJoystick.translatesAutoresizingMaskIntoConstraints = false
        rightJoystick.joystickType = .rightThumbstick
        addSubview(leftJoystick)
        addSubview(rightJoystick)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[left]-\(padding)-|", options: [], metrics: nil, views: ["left": leftJoystick]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(padding)-[left]", options: [], metrics: nil, views: ["left": leftJoystick]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[right]-\(padding)-|", options: [], metrics: nil, views: ["right": rightJoystick]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[right]-\(padding)-|", options: [], metrics: nil, views: ["right": rightJoystick]))
    }
}

class SoftwareController {
    let view = SoftwareControllerView()
    
}

extension CGFloat {
    func scaled(minimumIn: CGFloat, maximumIn: CGFloat, minimumOut: CGFloat, maximumOut: CGFloat) -> CGFloat {
        return (self - minimumIn) * (maximumOut - minimumOut) / (maximumIn - minimumIn) + minimumOut
    }
}
