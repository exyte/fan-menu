import UIKit
import Macaw

class CustomViewController: UIViewController {
    
    @IBOutlet weak var customMenu: CustomMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customMenu.updateNode()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
    
    var animation: Animation?
    var isOpen = false
    
    init(customMenu: CustomMenu) {
        self.customMenu = customMenu
        
        menuButton = CustomMenuButtonScene(radius: customMenu.radius)
        buttonsGroup = CustomButtonsScene(customMenu: customMenu)
        
        node = [buttonsGroup.node, menuButton.node].group()
        
        menuButton.node.onTouchPressed { _ in
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
        }
    }
    
    func close() {
        if let animationVal = self.animation {
            self.animation = animationVal.reverse()
            self.animation?.play()
        }
        isOpen = false
    }
    
    func open() {
        let scale = customMenu.menuRadius / customMenu.radius
        self.animation = [
            buttonsGroup.show(duration: customMenu.duration, scale: scale),
            menuButton.open(duration: customMenu.duration)
        ].combine()
        self.animation?.play()
        isOpen = true
    }
}

class CustomButtonsScene {
    
    let node: Group
    let backgroundCircle: Shape
    var animationGroup: Group!
    var buttonsNode: Group!

    let customMenu: CustomMenu
    
    init(customMenu: CustomMenu) {
        self.customMenu = customMenu
        
        node = Group()
        backgroundCircle = Shape(
            form: Circle(r: customMenu.radius),
            fill: Color.white.with(a: 0.5)
        )
        node.contents.append(backgroundCircle)
        
        buttonsNode = Group(contents: customMenu.items.enumerated().map { (index, item) in
            return self.createCustomButton(customMenu: customMenu, data: item, index: index)
        })
        buttonsNode.opacity = 0.0
        buttonsNode.place = Transform.identity.scale(sx: 0.4, sy: 0.4)
        node.contents.append(buttonsNode)
        
        animationGroup = Group()
        buttonsNode.contents.append(animationGroup)
    }
    
    func createCustomButton(customMenu: CustomMenu, data: (String, String, Int), index: Int) -> Node {
        let node = createCustomButton(
            radius: customMenu.radius,
            color: Color(val: data.2),
            image: data.1
        )
        
        let size = Double(customMenu.items.count)
        let step: Double = (2 * Double.pi) / size
        
        let alpha = 3 * Double.pi / 2 + step * Double(index)
        let place = Transform.move(
            dx: cos(alpha) * customMenu.menuRadius,
            dy: sin(alpha) * customMenu.menuRadius
        )
        node.place = place
        
        node.onTouchPressed { _ in
            if self.customMenu.scene!.isOpen {
                self.select(node: node, alpha: alpha, color: data.2, customMenu: customMenu)
            }
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
    
    func show(duration: Double, scale: Double) -> Animation {
        animationGroup.contents = []
        return [
            backgroundCircle.placeVar.animation(to: Transform.scale(sx: scale, sy: scale), during: duration),
            backgroundCircle.opacityVar.animation(to: 0.0, during: duration),
            buttonsNode.opacityVar.animation(to: 1.0, during: duration),
            buttonsNode.placeVar.animation(to: buttonsNode.place.scale(sx: 2.5, sy: 2.5), during: duration)
        ].combine().easing(Easing.easeOut)
    }
    
    func select(node: Node, alpha: Double, color: Int, customMenu: CustomMenu) {
        let index = self.buttonsNode.contents.firstIndex(of: node)
        self.buttonsNode.contents.remove(at: index!)
        self.buttonsNode.contents.append(node)
        
        let contentAnimation = animationGroup.contentsVar.animation({ t in
            let shape = Shape(
                form: Arc(
                    ellipse: Ellipse(rx: customMenu.menuRadius, ry: customMenu.menuRadius),
                    shift: alpha,
                    extent: 2 * Double.pi * t
                ),
                stroke: Stroke(fill: Color(val: color), width: customMenu.radius * 2)
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
            let closeAnimation = [
                self.node.placeVar.animation(
                    to: GeomUtils.centerScale(node: self.node, sx: 1.5, sy: 1.5),
                    during: customMenu.duration
                ),
                self.node.opacityVar.animation(to: 0.0, during: customMenu.duration),
                customMenu.scene!.menuButton.updateState(isOpen: false, duration: customMenu.duration)
            ].combine()

            closeAnimation.onComplete {
                self.customMenu.updateNode()
            }
            closeAnimation.play()
            
        }
    }
}

class CustomMenuButtonScene {

    var openButtons: Group!
    var closeButtons: Group!
    var node: Group!
    
    init(radius: Double) {
        openButtons = createMenuState(image: "custom_share", radius: radius)
        closeButtons = createMenuState(image: "custom_close", radius: radius, a: 0.7)
        closeButtons.opacity = 0.0
        
        node = [openButtons, closeButtons].group()
    }
    
    func open(duration: Double) -> Animation {
        return updateState(isOpen: true, duration: duration)
    }

    func updateState(isOpen: Bool, duration: Double) -> Animation {
        return [
            openButtons.opacityVar.animation(to: isOpen ? 0.0 : 1.0, during: duration),
            closeButtons.opacityVar.animation(to: isOpen ? 1.0 : 0.0, during: duration)
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
