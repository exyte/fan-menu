import Foundation
import UIKit
import Macaw

class TaskViewController: UIViewController {
    @IBOutlet weak var circleMenuView: CircleMenuView!
    @IBOutlet weak var colorLabel: UILabel!
    
    let colors = [0x231FE4, 0x00BFB6, 0xFFC43D, 0xFF5F3D, 0xF34766]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        circleMenuView.centerButton = mainButton(colorHex: 0x7C93FE)
        circleMenuView.buttons = colors.enumerated().map { (index, item) in
            CircleMenuButton(
                id: String(index),
                image: "",
                color: Color(val: item)
            )
        }
        
        circleMenuView.distance = 70.0
        circleMenuView.duration = 0.35
        circleMenuView.interval = (M_PI, 2 * M_PI)
        circleMenuView.radius = 15.0
        
        circleMenuView.onButtonPressed = { button in
            self.hideTitle()
            if button.id != "main" {
                let newColor = self.colors[Int(button.id)!]
                let circleMenu = self.circleMenuView.node as? CircleMenu
                circleMenu?.menuCircle.fill = Color(val: newColor)
            }
        }
        
        circleMenuView.transform = CGAffineTransform(rotationAngle: CGFloat(3 * M_PI/2.0))
    }
    
    func hideTitle() {
        let newValue = !self.colorLabel.isHidden
        UIView.transition(
            with: colorLabel, duration: 0.5, options: .transitionCrossDissolve, animations: { _ in
                self.colorLabel.isHidden = newValue
        }, completion: nil)
    }
    
    func mainButton(colorHex: Int) -> CircleMenuButton {
        return CircleMenuButton(
            id: "main",
            image: "",
            color: Color(val: colorHex)
        )
    }
}
