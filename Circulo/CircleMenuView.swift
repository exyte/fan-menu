import Foundation
import Macaw

class CircleMenuView: MacawView {
    
    var duration = 0.35 {
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

    var menuItem: CircleMenuItem? {
        didSet {
            updateNode()
        }
    }
    
    var items: [CircleMenuItem] = [] {
        didSet {
            updateNode()
        }
    }
    
    var halfMode: Bool = false {
        didSet {
            updateNode()
        }
    }
    
    func updateNode() {
        let viewSize = Size(
            w: Double(UIScreen.main.bounds.width),
            h: Double(UIScreen.main.bounds.height)
        )
        
        guard let menuItem = menuItem else {
            self.node = Group()
            return
        }
        
        let node = CircleMenu(menuItem: menuItem, menuView: self)
        node.place = Transform.move(dx: viewSize.w / 2, dy: viewSize.h/2)
        self.node = node
    }
}

struct CircleMenuItem {
    let id: String
    let image: String
    let color: Color
}

class CircleMenu: Group {
    
    let menuView: CircleMenuView
    
    let buttonGroup: Group
    let itemsGroup: Group
    let menuIcon: Image
    let backgroundCircle: Node
    
    init(menuItem: CircleMenuItem, menuView: CircleMenuView) {
        self.menuView = menuView
        
        let mainCircle = Shape(
            form: Circle(r: menuView.radius),
            fill: menuItem.color
        )
        
        let uiImage = UIImage(named: menuItem.image)!
        menuIcon = Image(
            src: menuItem.image,
            place: Transform.move(
                dx: -Double(uiImage.size.width) / 2,
                dy:  -Double(uiImage.size.height) / 2
            )
        )
        
        buttonGroup = [mainCircle, menuIcon].group()
        itemsGroup = menuView.items.map { CircleMenuItemNode(item: $0, menuView: menuView) }.group()
        
        backgroundCircle = Shape(
            form: Circle(r: menuView.radius),
            fill: menuItem.color.with(a: 0.2)
        )
        
        super.init(contents: [backgroundCircle, itemsGroup, buttonGroup])
        
        buttonGroup.onTouchPressed { _ in
            self.toggle()
        }
    }
    
    var animation: Animation?
    
    func toggle() {
        if let animationVal = self.animation {
            animationVal.reverse().play()
            self.animation = nil
            return
        }
        
        let scale = menuView.distance / menuView.radius
        let backgroundAnimation = self.backgroundCircle.placeVar.animation(
            to: Transform.scale(sx: scale, sy: scale),
            during: menuView.duration
        )
        
        let expandAnimation = self.itemsGroup.contents.enumerated().map { (index, node) in
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
        
        self.animation = [backgroundAnimation, expandAnimation, imageAnimation].combine()
        self.animation?.play()
    }
    
    func expandPlace(index: Int) -> Transform {
        let size = Double(itemsGroup.contents.count)
        let alpha = 2 * M_PI / (menuView.halfMode ? (size - 1) * 2 : size) * Double(index) + M_PI
        return Transform.move(
            dx: cos(alpha) * menuView.distance,
            dy: sin(alpha) * menuView.distance
        )
    }
}

class CircleMenuItemNode: Group {

    init(item: CircleMenuItem, menuView: CircleMenuView) {
        let circle = Shape(
            form: Circle(r: menuView.radius),
            fill: item.color
        )

        let uiImage = UIImage(named: item.image)!
        let image = Image(
            src: item.image,
            place: Transform.move(
                dx: -Double(uiImage.size.width) / 2,
                dy:  -Double(uiImage.size.height) / 2
            )
        )
        super.init(contents: [circle, image], opacity: 0.0)
        
        self.onTouchPressed { _ in
            // fire event
        }

    }
}
