import UIKit
import Macaw

class CustomViewController: UIViewController {
    
    @IBOutlet weak var customView: CustomMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.updateNode()
    }
}

class CustomMenuView: MacawView {
    
    let radius = 30.0
    let distance = 95.0
    let duration = 0.35
    
    let buttons = [
        ("exchange","custom_twitter", 0x059FF5),
        ("visa", "custom_whatsup", 0x4ECD5E),
        ("wallet", "custom_telegram", 0x27A2E1),
        ("visa", "custom_copylink", 0x595A6C),
        ("money_box", "custom_facebook", 0x39579A)
    ]
    
    var onSharePressed: ((_ id: String) -> ())?
    
    func updateNode() {
        let node = CustomMenu(menuView: self)
        node.place = Transform.move(
            dx: Double(self.frame.width) / 2,
            dy: Double(self.frame.height) / 2
        )
        self.node = node
    }
}

class CustomMenu: Group {
    
    let menuView: CustomMenuView
    
    let menuButton: CustomMenuButton
    let buttonsGroup: CustomButtons
    
    init(menuView: CustomMenuView) {
        self.menuView = menuView
        
        menuButton = CustomMenuButton(radius: menuView.radius)
        buttonsGroup = CustomButtons(menuView: menuView)
        
        super.init(contents: [menuButton, buttonsGroup])
        
        menuButton.onTouchPressed { _ in
            self.toggle()
        }
    }
    
    var animation: Animation?
    
    func close() {
        if let animationVal = self.animation {
            animationVal.reverse().play()
            self.animation = nil
            return
        }
    }
    
    func open() {
        let scale = menuView.distance / menuView.radius
        self.animation = [
            buttonsGroup.show(duration: menuView.duration),
            menuButton.open(duration: menuView.duration, scale: scale)
            ].combine()
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
}

class CustomButtons: Group {
    
    let animationGroup: Group
    
    init(menuView: CustomMenuView) {
        animationGroup = Group()
        super.init(contents: [])
        
        self.contents = menuView.buttons.enumerated().map { (index, item) in
            return createCustomButton(menuView: menuView, data: item, index: index)
        }
        
        self.contents.append(animationGroup)
        self.place = Transform.identity.scale(sx: 0.4, sy: 0.4)
        self.opacity = 0.0
    }
    
    func createCustomButton(menuView: CustomMenuView, data: (String, String, Int), index: Int) -> Node {
        let node = CustomButton(
            radius: menuView.radius,
            color: Color(val: data.2),
            image: data.1
        )
        
        let size = Double(menuView.buttons.count)
        let step: Double = (2 * M_PI) / size
        
        let alpha = 3 * M_PI / 2 + step * Double(index)
        let place = Transform.move(
            dx: cos(alpha) * menuView.distance,
            dy: sin(alpha) * menuView.distance
        )
        node.place = place
        
        node.onTouchPressed { _ in
            self.select(node: node, alpha: alpha, color: data.2, menuView: menuView)
        }
        return node
    }
    
    func show(duration: Double) -> Animation {
        animationGroup.contents = []
        return [
            opacityVar.animation(to: 1.0, during: duration),
            placeVar.animation(to: place.scale(sx: 2.5, sy: 2.5), during: duration)
        ].combine().easing(Easing.easeOut)
    }
    
    func select(node: CustomButton, alpha: Double, color: Int, menuView: CustomMenuView) {
        let contentAnimation = animationGroup.contentsVar.animation({ t in
            let shape = Shape(
                form: Arc(
                    ellipse: Ellipse(rx: menuView.distance, ry: menuView.distance),
                    shift: alpha,
                    extent: 2 * M_PI * t
                ),
                stroke: Stroke(fill: Color(val: color), width: menuView.radius * 2 + 1)
            )
            return [shape]
        }, during: menuView.duration)
        let opacityAnimation = node.opacityVar.animation(
            to: 1.0,
            during: menuView.duration
        )
        
        let animation = [contentAnimation, opacityAnimation].combine()
        animation.play()
        
        contentAnimation.onComplete {
            let menu = menuView.node as? CustomMenu
            menu?.close()
        }
    }
}

class CustomButton: Group {
    
    init(radius: Double, color: Color, image: String) {
        
        let circle = Shape(
            form: Circle(r: radius),
            fill: color
        )
        let uiImage = UIImage(named: image)!
        let image = Image(
            src: image,
            place: Transform.move(
                dx: -Double(uiImage.size.width) / 2,
                dy: -Double(uiImage.size.height) / 2
            )
        )
        super.init(contents: [circle, image])
    }
}


class CustomMenuButton: Group {
    
    let backgroundCircle: Shape
    let openButtonsGroup: Group
    let closeButtonsGroup: Group
    
    init(radius: Double) {
        backgroundCircle = Shape(
            form: Circle(r: radius),
            fill: Color.white.with(a: 0.5)
        )
        
        openButtonsGroup = CustomMenuState(image: "custom_share", radius: radius)
        closeButtonsGroup = CustomMenuState(image: "custom_close", radius: radius, a: 0.7)
        closeButtonsGroup.opacity = 0.0
        
        super.init(contents: [backgroundCircle, openButtonsGroup, closeButtonsGroup])
    }
    
    func open(duration: Double, scale: Double) -> Animation {
        return [
            backgroundCircle.placeVar.animation(to: Transform.scale(sx: scale, sy: scale), during: duration),
            backgroundCircle.opacityVar.animation(to: 0.0, during: duration),
            openButtonsGroup.opacityVar.animation(to: 0.0, during: duration),
            closeButtonsGroup.opacityVar.animation(to: 1.0, during: duration)
        ].combine()
    }
}

class CustomMenuState: Group {
    init(image: String, radius: Double, a: Double = 1.0) {
        let circle = Shape(
            form: Circle(r: radius),
            fill: Color.white.with(a: a)
        )
        
        let uiImage = UIImage(named: image)!
        let menuIcon = Image(
            src: image,
            place: Transform.move(
                dx: -Double(uiImage.size.width) / 2,
                dy:  -Double(uiImage.size.height) / 2
            )
        )
        super.init(contents: [circle, menuIcon])
    }
}
