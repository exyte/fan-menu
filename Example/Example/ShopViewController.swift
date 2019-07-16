import Foundation
import UIKit
import FanMenu
import Macaw

class ShopViewController: UIViewController {
    
    @IBOutlet weak var fanMenu: FanMenu!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fanMenu.button = FanMenuButton(
            id: "main",
            image: UIImage(named: "menu_plus"),
            color: Color(val: 0xADADAD)
        )
        
        fanMenu.items = [
            FanMenuButton(
                id: "photo",
                image: UIImage(named: "shop_photo"),
                color: Color(val: 0xCECBCB)
            ),
            FanMenuButton(
                id: "gallery",
                image: UIImage(named: "shop_gallery"),
                color: Color(val: 0xCECBCB)
            ),
        ]
        
        fanMenu.menuRadius = 100.0
        fanMenu.duration = 0.2
        fanMenu.interval = (Double.pi + Double.pi/4, Double.pi + 3 * Double.pi/4)
        fanMenu.radius = 25.0
        fanMenu.delay = 0.0
        
        fanMenu.onItemWillClick = { button in
            self.showView()
        }
        
        fanMenu.backgroundColor = .clear
    }
    
    func showView() {
        let newValue: CGFloat = self.topView.alpha == 0.0 ? 1.0 : 0.0
        UIView.animate(withDuration: 0.35, animations: {
            self.topView.alpha = newValue
        })
    }
}
