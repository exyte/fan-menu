import Foundation
import UIKit
import Macaw

class ShopViewController: UIViewController {
    
    @IBOutlet weak var fanMenuView: FanMenuView!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fanMenuView.centerButton = FanMenuButton(
            id: "main",
            image: "menu_plus",
            color: Color(val: 0xADADAD)
        )
        
        fanMenuView.buttons = [
            FanMenuButton(
                id: "photo",
                image: "shop_photo",
                color: Color(val: 0xCECBCB)
            ),
            FanMenuButton(
                id: "gallery",
                image: "shop_gallery",
                color: Color(val: 0xCECBCB)
            ),
        ]
        
        fanMenuView.distance = 100.0
        fanMenuView.duration = 0.35
        fanMenuView.interval = (M_PI + M_PI/4, M_PI + 3 * M_PI/4)
        fanMenuView.radius = 25.0
        
        fanMenuView.onButtonPressed = { button in
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
