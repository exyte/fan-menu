import Foundation
import UIKit
import Macaw

class ShopViewController: UIViewController {
    
    @IBOutlet weak var circleMenuView: CircleMenuView!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circleMenuView.centerButton = CircleMenuButton(
            id: "main",
            image: "menu_plus",
            color: Color(val: 0xADADAD)
        )
        
        circleMenuView.buttons = [
            CircleMenuButton(
                id: "photo",
                image: "shop_photo",
                color: Color(val: 0xCECBCB)
            ),
            CircleMenuButton(
                id: "gallery",
                image: "shop_gallery",
                color: Color(val: 0xCECBCB)
            ),
        ]
        
        circleMenuView.distance = 100.0
        circleMenuView.duration = 0.35
        circleMenuView.interval = (M_PI + M_PI/4, M_PI + 3 * M_PI/4)
        circleMenuView.radius = 25.0
        
        circleMenuView.onButtonPressed = { button in
            self.showView()
        }
    }
    
    func showView() {
        let newValue: CGFloat = self.topView.alpha == 0.0 ? 1.0 : 0.0
        UIView.animate(withDuration: 0.35, animations: {
            self.topView.alpha = newValue
        })
    }
}
