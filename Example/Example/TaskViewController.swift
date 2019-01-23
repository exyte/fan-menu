import Foundation
import UIKit
import Macaw
import FanMenu

class TaskViewController: UIViewController {
    @IBOutlet weak var fanMenu: FanMenu!
    @IBOutlet weak var colorLabel: UILabel!
    
    let colors = [0x231FE4, 0x00BFB6, 0xFFC43D, 0xFF5F3D, 0xF34766]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fanMenu.button = mainButton(colorHex: 0x7C93FE)
        fanMenu.items = colors.enumerated().map { arg -> FanMenuButton in

            let (index, item) = arg
            return FanMenuButton(
                id: String(index),
                image: .none,
                color: Color(val: item)
            )
        }
        
        fanMenu.menuRadius = 70.0
        fanMenu.duration = 0.2
        fanMenu.interval = (Double.pi, 2 * Double.pi)
        fanMenu.radius = 15.0
        
        fanMenu.onItemWillClick = { button in
            self.hideTitle()
            if button.id != "main" {
                let newColor = self.colors[Int(button.id)!]
                let fanGroup = self.fanMenu.node as? Group
                let circleGroup = fanGroup?.contents[2] as? Group
                let shape = circleGroup?.contents[0] as? Shape
                shape?.fill = Color(val: newColor)
            }
        }
        
        fanMenu.transform = CGAffineTransform(rotationAngle: CGFloat(3 * Double.pi/2.0))
        
        fanMenu.backgroundColor = .clear
    }
    
    func hideTitle() {
        let newValue = !self.colorLabel.isHidden
        UIView.transition(
            with: colorLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.colorLabel.isHidden = newValue
        }, completion: nil)
    }
    
    func mainButton(colorHex: Int) -> FanMenuButton {
        return FanMenuButton(
            id: "main",
            image: .none,
            color: Color(val: colorHex)
        )
    }
}
