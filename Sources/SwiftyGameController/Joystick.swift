import UIKit


typealias 🕹 = Joystick
@IBDesignable
class Joystick: UIView {
    
    let backgroundView = UIView()
    let stick = UIView()
    
    @IBInspectable
    var stickBackgroundColor: UIColor = UIColor.gray { didSet { updateProperties() }}
    @IBInspectable
    var stickColor: UIColor = UIColor.blue { didSet { updateProperties() }}
    @IBInspectable
    var stickSize: CGFloat = 25 { didSet { updateProperties() } }
    var radius: CGFloat { get { return bounds.size.width/2 } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
    }
    
    func touchEvent(touches: Set<UITouch>) {
        for touch: AnyObject in touches {
            
            let location = touch.location(in: self)
            let baseCenter = CGPoint(x: radius, y: radius)
            
            if location.distance(between: baseCenter) < radius {
                stick.center = location
            } else {
                let v = CGVector(dx: location.x-radius, dy: location.y - radius)
                let angle = atan2(v.dy, v.dx)
                let xDist: CGFloat = sin(angle - CGFloat.pi / 2) * radius
                let yDist: CGFloat = cos(angle - CGFloat.pi / 2) * radius
                stick.center = CGPoint(x: baseCenter.x-xDist, y: baseCenter.y+yDist)
            }
        }
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
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.stick.center = CGPoint(x: self.radius, y: self.radius)
        }, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ensureSuperviews()
        
        backgroundView.layer.cornerRadius = radius
        backgroundView.frame = bounds
        
        stick.frame = CGRect(origin: CGPoint(x: radius-stickSize/2, y: radius-stickSize/2), size: CGSize(width: stickSize, height: stickSize))
        stick.layer.cornerRadius = stickSize/2
    }
    
    func ensureSuperviews() {
        if backgroundView.superview == nil {
            addSubview(backgroundView)
        }
        if stick.superview == nil {
            addSubview(stick)
        }
    }
    
    func updateProperties() {
        backgroundView.backgroundColor = stickBackgroundColor
        stick.backgroundColor = stickColor
        stick.frame = CGRect(origin: center, size: CGSize(width: stickSize, height: stickSize))
        stick.layer.cornerRadius = stickSize/2
    }
}

extension CGPoint {
    func angle(between point: CGPoint) -> CGFloat {
        let originPoint = CGPoint(x: point.x-self.x, y: point.y-self.y)
        let bearingRadians = atan2f(Float(originPoint.y), Float(originPoint.y))
        var bearingDegrees = bearingRadians * Float((180 / Double.pi))
        bearingDegrees = bearingDegrees > 0 ? bearingDegrees : 360 + bearingDegrees
        return CGFloat(bearingDegrees)
    }
    
    func distance(between point: CGPoint) -> CGFloat {
        let xDistance = point.x - self.x
        let yDistance = point.y - self.y
        return sqrt((xDistance * xDistance) + (yDistance * yDistance))
    }
}

