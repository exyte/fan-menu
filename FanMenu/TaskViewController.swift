import Foundation
import UIKit
import Macaw

class TaskViewController: UIViewController {
    @IBOutlet weak var fanMenu: FanMenu!
    @IBOutlet weak var colorLabel: UILabel!
    
    let colors = [0x231FE4, 0x00BFB6, 0xFFC43D, 0xFF5F3D, 0xF34766]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fanMenu.button = mainButton(colorHex: 0x7C93FE)
        fanMenu.items = colors.enumerated().map { (index, item) in
            FanMenuButton(
                id: String(index),
                image: "",
                color: Color(val: item)
            )
        }
        
        fanMenu.menuRadius = 70.0
        fanMenu.duration = 0.35
        fanMenu.interval = (M_PI, 2 * M_PI)
        fanMenu.radius = 15.0
        
        fanMenu.onButtonPressed = { button in
            self.hideTitle()
            if button.id != "main" {
                let newColor = self.colors[Int(button.id)!]
                let fanGroup = self.fanMenu.node as? Group
                let circleGroup = fanGroup?.contents[2] as? Group
                let shape = circleGroup?.contents[0] as? Shape
                shape?.fill = Color(val: newColor)
            }
        }
        
        fanMenu.transform = CGAffineTransform(rotationAngle: CGFloat(3 * M_PI/2.0))
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
