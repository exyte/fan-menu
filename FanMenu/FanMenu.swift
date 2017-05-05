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
    
    public var interval: (Double, Double) = (0, 2.0 * Double.pi) {
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
            print($0.id)
            return FanMenuScene.createFanButtonNode(button: $0, fanMenu: fanMenu)
        }.group()
        
        
        backgroundCircle = Shape(
            form: Circle(r: fanMenu.radius - 1)
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
        updateState(open: true)
    }
    
    func close() {
        updateState(open: false)
    }
    
    func updateState(open: Bool) {
        isOpen = open
        
        let scale = isOpen ? fanMenu.menuRadius / fanMenu.radius : fanMenu.radius / fanMenu.menuRadius
        let backgroundAnimation = self.backgroundCircle.placeVar.animation(
            to: Transform.scale(sx: scale, sy: scale),
            during: fanMenu.duration
        )
        
        let nodes = isOpen ? self.buttonsNode.contents.enumerated() : self.buttonsNode.contents.reversed().enumerated()
        let expandAnimation = nodes.map { (index, node) in
            let transform = isOpen ? self.expandPlace(index: index) : Transform.identity
            let mainAnimation =  [
                node.opacityVar.animation(to: isOpen ? 1.0 : 0.0, during: fanMenu.duration),
                node.placeVar.animation(
                    to: transform,
                    during: fanMenu.duration
                ).easing(Easing.easeOut)
            ].combine()
            
            if index == 0 {
                return mainAnimation
            }
            
            let filterOpacity = isOpen ? 0.0 : 1.0
            let fillerAnimation = node.opacityVar.animation(from: filterOpacity, to: filterOpacity, during: fanMenu.delay * Double(index))
            return [fillerAnimation, mainAnimation].sequence()
        }.combine()
        
        // stub
        let buttonAnimation = self.buttonNode.opacityVar.animation(
            to: 1.0,
            during: fanMenu.duration + fanMenu.delay * Double(buttonsNode.contents.count - 1)
        )
        
        animation = [backgroundAnimation, expandAnimation, buttonAnimation].combine()
        animation?.play()
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
        if interval.truncatingRemainder(dividingBy: 2 * Double.pi) < 0.00001 {
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
