import Foundation
import Macaw

public struct FanMenuButton {
    let id: String
    let image: String
    let color: Color
}

public class FanMenu: MacawView {
    
    public var duration = 0.20 {
        didSet {
            updateNode()
        }
    }
    
    public var delay = 0.05 {
        didSet {
            updateNode()
        }
    }
    
    public var menuRadius = 95.0 {
        didSet {
            updateNode()
        }
    }
    
    public var radius = 30.0 {
        didSet {
            updateNode()
        }
    }
    
    public var button: FanMenuButton? {
        didSet {
            updateNode()
        }
    }
    
    public var items: [FanMenuButton] = [] {
        didSet {
            updateNode()
        }
    }
    
    public var interval: (Double, Double) = (0, 2.0 * M_PI) {
        didSet {
            updateNode()
        }
    }
    
    public var menuBackground: Color? {
        didSet {
            updateNode()
        }
    }
    
    public var onButtonPressed: ((_ button: FanMenuButton) -> ())?
    
    var scene: FanMenuScene?
    
    var isOpen: Bool {
        get {
            if let sceneValue = scene {
                return sceneValue.isOpen
            }
            return false
        }
    }
    
    func open() {
        scene?.open()
    }
    
    func close() {
        scene?.close()
    }
    
    func updateNode() {
        guard let _ = button else {
            self.node = Group()
            self.scene = .none
            return
        }
        
        let scene = FanMenuScene(fanMenu: self)
        let node = scene.node
        node.place = Transform.move(
            dx: Double(self.frame.width) / 2,
            dy: Double(self.frame.height) / 2
        )
        self.node = node
        self.scene = scene
    }
}

class FanMenuScene {
    
    let fanMenu: FanMenu
    
    let buttonNode: Group
    let buttonsNode: Group
    let backgroundCircle: Shape
    
    let menuCircle: Shape
    let menuIcon: Image?
    
    let node: Group
    
    init(fanMenu: FanMenu) {
        self.fanMenu = fanMenu
        let button = fanMenu.button!
        
        menuCircle = Shape(
            form: Circle(r: fanMenu.radius),
            fill: button.color
        )
        
        buttonNode = [menuCircle].group()
        if let uiImage = UIImage(named: button.image) {
            menuIcon = Image(
                src: button.image,
                place: Transform.move(
                    dx: -Double(uiImage.size.width) / 2,
                    dy: -Double(uiImage.size.height) / 2
                )
            )
            buttonNode.contents.append(menuIcon!)
        } else {
            menuIcon = .none
        }
        
        buttonsNode = fanMenu.items.map {
            FanMenuScene.createFanButtonNode(button: $0, fanMenu: fanMenu)
        }.group()
        
        
        backgroundCircle = Shape(
            form: Circle(r: fanMenu.radius)
        )
        
        if let color = fanMenu.menuBackground {
            backgroundCircle.fill = color
        } else {
            backgroundCircle.fill = button.color.with(a: 0.2)
        }
        
        node = [backgroundCircle, buttonsNode, buttonNode].group()
        
        buttonNode.onTouchPressed { _ in
            if let animationValue = self.animation {
                if animationValue.state() != .paused {
                    return
                }
            }
            
            if self.isOpen {
                self.close()
            } else {
                self.open()
            }
            self.fanMenu.onButtonPressed?(button)
        }
    }
    
    var animation: Animation?
    var isOpen: Bool = false
    
    func open() {
        isOpen = true

        let scale = fanMenu.menuRadius / fanMenu.radius
        let backgroundAnimation = self.backgroundCircle.placeVar.animation(
            to: Transform.scale(sx: scale, sy: scale),
            during: fanMenu.duration
        )
        
        let expandAnimation = self.buttonsNode.contents.enumerated().map { (index, node) in
            return [
                node.opacityVar.animation(to: 1.0, during: fanMenu.duration),
                node.placeVar.animation(
                    to: self.expandPlace(index: index),
                    during: fanMenu.duration
                ).easing(Easing.easeOut)
            ].combine().delay(fanMenu.delay * Double(index))
        }.combine()
        
        // stub
        let buttonAnimation = self.buttonNode.opacityVar.animation(
            to: 1.0,
            during: fanMenu.duration
        )
        animation = [backgroundAnimation, expandAnimation, buttonAnimation].combine()
        animation?.play()
    }
    
    func close() {
        isOpen = false
        
        if let animationVal = self.animation {
            self.animation = animationVal.reverse()
            animation?.play()
        }
    }
    
    class func createFanButtonNode(button: FanMenuButton, fanMenu: FanMenu) -> Group {
        var contents: [Node] = [
            Shape(
                form: Circle(r: fanMenu.radius),
                fill: button.color
            )
        ]
        if let uiImage = UIImage(named: button.image) {
            let image = Image(
                src: button.image,
                place: Transform.move(
                    dx: -Double(uiImage.size.width) / 2,
                    dy: -Double(uiImage.size.height) / 2
                )
            )
            contents.append(image)
        }
        let node = Group(contents: contents)
        node.opacity = 0.0
        
        node.onTouchPressed { _ in
            fanMenu.onButtonPressed?(button)
            fanMenu.close()
        }
        
        return node
    }
    
    func expandPlace(index: Int) -> Transform {
        let size = Double(buttonsNode.contents.count)
        let endValue = fanMenu.interval.1
        let startValue = fanMenu.interval.0
        let interval = endValue - startValue
        
        var step: Double = 0.0
        if interval.truncatingRemainder(dividingBy: 2*M_PI) < 0.00001 {
            // full circle
            step = interval / size
        } else {
            step = interval / (size - 1)
        }
        
        let alpha = startValue + step * Double(index)
        return Transform.move(
            dx: cos(alpha) * fanMenu.menuRadius,
            dy: sin(alpha) * fanMenu.menuRadius
        )
    }
}
