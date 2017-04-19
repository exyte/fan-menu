import Foundation
import Macaw

class FanMenuView: MacawView {
    
    var duration = 0.20 {
        didSet {
            updateNode()
        }
    }
    
    var distance = 95.0 {
        didSet {
            updateNode()
        }
    }
    
    var radius = 30.0 {
        didSet {
            updateNode()
        }
    }
    
    var centerButton: FanMenuButton? {
        didSet {
            updateNode()
        }
    }
    
    var buttons: [FanMenuButton] = [] {
        didSet {
            updateNode()
        }
    }
    
    var interval: (Double, Double) = (0, 2.0 * M_PI) {
        didSet {
            updateNode()
        }
    }
    
    var menu: FanMenu? {
        get {
            return self.node as? FanMenu
        }
    }
    
    var onButtonPressed: ((_ button: FanMenuButton) -> ())?
    
    func updateNode() {
        guard let _ = centerButton else {
            self.node = Group()
            return
        }
        
        let node = FanMenu(menuView: self)
        node.place = Transform.move(
            dx: Double(self.frame.width) / 2,
            dy: Double(self.frame.height) / 2
        )
        self.node = node
    }
}

struct FanMenuButton {
    let id: String
    let image: String
    let color: Color
}

class FanMenu: Group {
    
    let menuView: FanMenuView
    
    let buttonGroup: Group
    let buttonsGroup: Group
    let backgroundCircle: Node
    
    let menuCircle: Shape
    let menuIcon: Image?
    
    init(menuView: FanMenuView) {
        self.menuView = menuView
        let centerButton = menuView.centerButton!
        
        menuCircle = Shape(
            form: Circle(r: menuView.radius),
            fill: centerButton.color
        )
        
        buttonGroup = [menuCircle].group()
        if let uiImage = UIImage(named: centerButton.image) {
            menuIcon = Image(
                src: centerButton.image,
                place: Transform.move(
                    dx: -Double(uiImage.size.width) / 2,
                    dy: -Double(uiImage.size.height) / 2
                )
            )
            buttonGroup.contents.append(menuIcon!)
        } else {
            menuIcon = .none
        }
        
        buttonsGroup = menuView.buttons.map {
            FanMenuButtonNode(button: $0, menuView: menuView)
        }.group()
        
        backgroundCircle = Shape(
            form: Circle(r: menuView.radius),
            fill: centerButton.color.with(a: 0.2)
        )
        
        super.init(contents: [backgroundCircle, buttonsGroup, buttonGroup])
        
        buttonGroup.onTouchPressed { _ in
            if self.isOpen {
                self.close()
            } else {
                self.open()
            }
            self.menuView.onButtonPressed?(centerButton)
        }
    }
    
    var animation: Animation?
    var isOpen: Bool {
        get {
            return self.animation != nil
        }
    }
    
    func open() {
        let scale = menuView.distance / menuView.radius
        let backgroundAnimation = self.backgroundCircle.placeVar.animation(
            to: Transform.scale(sx: scale, sy: scale),
            during: menuView.duration
        )
        
        let expandAnimation = self.buttonsGroup.contents.enumerated().map { (index, node) in
            return [
                node.opacityVar.animation(to: 1.0, during: menuView.duration),
                node.placeVar.animation(
                    to: self.expandPlace(index: index),
                    during: menuView.duration   
                ).easing(Easing.easeOut)
            ].combine().delay(menuView.duration / 7 * Double(index))
        }.combine()
        
        animation = [backgroundAnimation, expandAnimation].combine()
        animation?.play()
    }
    
    func close() {
        if let animationVal = self.animation {
            animationVal.reverse().play()
            self.animation = nil
            return
        }
    }
    
    func expandPlace(index: Int) -> Transform {
        let size = Double(buttonsGroup.contents.count)
        let endValue = self.menuView.interval.1
        let startValue = self.menuView.interval.0
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
            dx: cos(alpha) * menuView.distance,
            dy: sin(alpha) * menuView.distance
        )
    }
}

class FanMenuButtonNode: Group {
    init(button: FanMenuButton, menuView: FanMenuView) {
        var contents: [Node] = [
            Shape(
                form: Circle(r: menuView.radius),
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
        super.init(contents: contents, opacity: 0.0)
        
        self.onTouchPressed { _ in
            menuView.onButtonPressed?(button)
            menuView.menu?.close()
        }
    }
}
