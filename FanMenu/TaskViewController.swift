import Foundation
import UIKit
import Macaw

class TaskViewController: UIViewController {
    @IBOutlet weak var fanMenuView: FanMenuView!
    @IBOutlet weak var colorLabel: UILabel!
    
    let colors = [0x231FE4, 0x00BFB6, 0xFFC43D, 0xFF5F3D, 0xF34766]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fanMenuView.centerButton = mainButton(colorHex: 0x7C93FE)
        fanMenuView.buttons = colors.enumerated().map { (index, item) in
            FanMenuButton(
                id: String(index),
                image: "",
                color: Color(val: item)
            )
        }
        
        fanMenuView.distance = 70.0
        fanMenuView.duration = 0.35
        fanMenuView.interval = (M_PI, 2 * M_PI)
        fanMenuView.radius = 15.0
        
        fanMenuView.onButtonPressed = { button in
            self.hideTitle()
            if button.id != "main" {
                let newColor = self.colors[Int(button.id)!]
                let circleMenu = self.fanMenuView.node as? FanMenu
                circleMenu?.menuCircle.fill = Color(val: newColor)
            }
        }
        
        fanMenuView.transform = CGAffineTransform(rotationAngle: CGFloat(3 * M_PI/2.0))
    }
    
    func hideTitle() {
        let newValue = !self.colorLabel.isHidden
        UIView.transition(
            with: colorLabel, duration: 0.5, options: .transitionCrossDissolve, animations: { _ in
                self.colorLabel.isHidden = newValue
        }, completion: nil)
    }
    
    func mainButton(colorHex: Int) -> FanMenuButton {
        return FanMenuButton(
            id: "main",
            image: "",
            color: Color(val: colorHex)
        )
    }
}
