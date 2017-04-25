import UIKit
import Macaw

class CustomViewController: UIViewController {
    
    @IBOutlet weak var customMenu: CustomMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customMenu.updateNode()
    }
}

class CustomMenu: MacawView {
    
    let radius = 30.0
    let menuRadius = 95.0
    let duration = 0.35
    
    let items = [
        ("exchange","custom_twitter", 0x059FF5),
        ("visa", "custom_whatsup", 0x4ECD5E),
        ("wallet", "custom_telegram", 0x27A2E1),
        ("visa", "custom_copylink", 0x595A6C),
        ("money_box", "custom_facebook", 0x39579A)
    ]
    
    var onSharePressed: ((_ id: String) -> ())?
    
    var scene: CustomMenuScene?
    
    func updateNode() {
        let menuScene = CustomMenuScene(customMenu: self)
        let node = menuScene.node
        node.place = Transform.move(
            dx: Double(self.frame.width) / 2,
            dy: Double(self.frame.height) / 2
        )
        self.scene = menuScene
        self.node = node
    }
    
    func close() {
        scene?.close()
    }
}

class CustomMenuScene {
    
    let customMenu: CustomMenu
    
    let menuButton: CustomMenuButtonScene
    let buttonsGroup: CustomButtonsScene
    
    let node: Group
    
    init(customMenu: CustomMenu) {
        self.customMenu = customMenu
        
        menuButton = CustomMenuButtonScene(radius: customMenu.radius)
        buttonsGroup = CustomButtonsScene(customMenu: customMenu)
        
        node = [menuButton.node, buttonsGroup.node].group()
        
        menuButton.node.onTouchPressed { _ in
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
        let scale = customMenu.menuRadius / customMenu.radius
        self.animation = [
            buttonsGroup.show(duration: customMenu.duration),
            menuButton.open(duration: customMenu.duration, scale: scale)
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

class CustomButtonsScene {
    
    var node: Group!
    let animationGroup: Group
    
    init(customMenu: CustomMenu) {
        animationGroup = Group()
        node = Group()
        
        node = Group(contents: customMenu.items.enumerated().map { (index, item) in
            return self.createCustomButton(customMenu: customMenu, data: item, index: index)
        })
        
        node.contents.append(animationGroup)
        node.place = Transform.identity.scale(sx: 0.4, sy: 0.4)
        node.opacity = 0.0
    }
    
    func createCustomButton(customMenu: CustomMenu, data: (String, String, Int), index: Int) -> Node {
        let node = createCustomButton(
            radius: customMenu.radius,
            color: Color(val: data.2),
            image: data.1
        )
        
        let size = Double(customMenu.items.count)
        let step: Double = (2 * M_PI) / size
        
        let alpha = 3 * M_PI / 2 + step * Double(index)
        let place = Transform.move(
            dx: cos(alpha) * customMenu.menuRadius,
            dy: sin(alpha) * customMenu.menuRadius
        )
        node.place = place
        
        node.onTouchPressed { _ in
            self.select(node: node, alpha: alpha, color: data.2, customMenu: customMenu)
        }
        return node
    }
    
    func createCustomButton(radius: Double, color: Color, image: String) -> Group {
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
        return [circle, image].group()
    }
    
    func show(duration: Double) -> Animation {
        animationGroup.contents = []
        return [
            node.opacityVar.animation(to: 1.0, during: duration),
            node.placeVar.animation(to: node.place.scale(sx: 2.5, sy: 2.5), during: duration)
        ].combine().easing(Easing.easeOut)
    }
    
    func select(node: Node, alpha: Double, color: Int, customMenu: CustomMenu) {
        let contentAnimation = animationGroup.contentsVar.animation({ t in
            let shape = Shape(
                form: Arc(
                    ellipse: Ellipse(rx: customMenu.menuRadius, ry: customMenu.menuRadius),
                    shift: alpha,
                    extent: 2 * M_PI * t
                ),
                stroke: Stroke(fill: Color(val: color), width: customMenu.radius * 2 + 1)
            )
            return [shape]
        }, during: customMenu.duration)
        let opacityAnimation = node.opacityVar.animation(
            to: 1.0,
            during: customMenu.duration
        )
        
        let animation = [contentAnimation, opacityAnimation].combine()
        animation.play()
        
        contentAnimation.onComplete {
            customMenu.close()
        }
    }
}

class CustomMenuButtonScene {
    
    var backgroundCircle: Shape!
    var openButtons: Group!
    var closeButtons: Group!
    var node: Group!
    
    init(radius: Double) {
        backgroundCircle = Shape(
            form: Circle(r: radius),
            fill: Color.white.with(a: 0.5)
        )
        
        openButtons = createMenuState(image: "custom_share", radius: radius)
        closeButtons = createMenuState(image: "custom_close", radius: radius, a: 0.7)
        closeButtons.opacity = 0.0
        
        node = [backgroundCircle, openButtons, closeButtons].group()
    }
    
    func open(duration: Double, scale: Double) -> Animation {
        return [
            backgroundCircle.placeVar.animation(to: Transform.scale(sx: scale, sy: scale), during: duration),
            backgroundCircle.opacityVar.animation(to: 0.0, during: duration),
            openButtons.opacityVar.animation(to: 0.0, during: duration),
            closeButtons.opacityVar.animation(to: 1.0, during: duration)
        ].combine()
    }
    
    func createMenuState(image: String, radius: Double, a: Double = 1.0) -> Group {
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
        return [circle, menuIcon].group()
    }
}
