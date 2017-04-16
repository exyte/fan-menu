import Foundation
import Macaw

class CircleMenuView: MacawView {
    
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

    var centerButton: CircleMenuButton? {
        didSet {
            updateNode()
        }
    }
    
    var buttons: [CircleMenuButton] = [] {
        didSet {
            updateNode()
        }
    }
    
    var halfMode: Bool = false {
        didSet {
            updateNode()
        }
    }
    
    var onButtonPressed: ((_ button: CircleMenuButton) -> ())?
    
    
    func open() {
        if let menu = self.node as? CircleMenu {
            menu.open()
        }
    }
    
    func close() {
        if let menu = self.node as? CircleMenu {
            menu.close()
        }
    }

    func updateNode() {
        guard let centerButton = centerButton else {
            self.node = Group()
            return
        }
        
        let node = CircleMenu(centerButton: centerButton, menuView: self)
        node.place = Transform.move(
            dx: Double(self.frame.width) / 2,
            dy: Double(self.frame.height) / 2
        )
        self.node = node
    }
}

struct CircleMenuButton {
    let id: String
    let image: String
    let color: Color
}

class CircleMenu: Group {
    
    let menuView: CircleMenuView
    let centerButton: CircleMenuButton
    
    let buttonGroup: Group
    let buttonsGroup: Group
    let backgroundCircle: Node
    
    let menuCircle: Shape
    let menuIcon: Image?
    
    init(centerButton: CircleMenuButton, menuView: CircleMenuView) {
        self.menuView = menuView
        self.centerButton = centerButton
        
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
                    dy:  -Double(uiImage.size.height) / 2
                )
            )
            buttonGroup.contents.append(menuIcon!)
        } else {
            menuIcon = .none
        }
        
        buttonsGroup = menuView.buttons.map {
            CircleMenuButtonNode(
                button: $0,
                menuView: menuView
            )
        }.group()
        
        backgroundCircle = Shape(
            form: Circle(r: menuView.radius),
            fill: centerButton.color.with(a: 0.2)
        )
        
        super.init(contents: [backgroundCircle, buttonsGroup, buttonGroup])
        
        buttonGroup.onTouchPressed { _ in
            self.toggle()
        }
    }
    
    var animation: Animation?
    
    func close() {
        if let animationVal = self.animation {
            self.menuView.onButtonPressed?(centerButton)
            
            animationVal.reverse().play()
            self.animation = nil
            return
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
        
        // workaround
        let imageAnimation = self.buttonGroup.opacityVar.animation(
            to:  1.0,
            during: menuView.duration
        )
        
        self.menuView.onButtonPressed?(centerButton)
        self.animation = [backgroundAnimation, expandAnimation, imageAnimation].combine()
        self.animation?.play()
    }
    
    func toggle() {
        if isOpen() {
            close()
        } else {
            open()
        }
    }
    
    func isOpen() -> Bool {
        return self.animation != nil
    }
    
    func expandPlace(index: Int) -> Transform {
        let size = Double(buttonsGroup.contents.count)
        let alpha = 2 * M_PI / (menuView.halfMode ? (size - 1) * 2 : size) * Double(index) + M_PI
        return Transform.move(
            dx: cos(alpha) * menuView.distance,
            dy: sin(alpha) * menuView.distance
        )
    }
}

open class CircleMenuButtonNode: Group {

    init(button: CircleMenuButton, menuView: CircleMenuView) {
        let circle = Shape(
            form: Circle(r: menuView.radius),
            fill: button.color
        )

        var contents: [Node] = [circle]
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
            menuView.close()
        }
    }
}
