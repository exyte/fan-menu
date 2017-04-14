import UIKit
import Macaw

class ViewController: UIViewController {

    @IBOutlet weak var circleMenuView: CircleMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circleMenuView.centerButton = CircleMenuButton(
            id: "main",
            image: "plus",
            color: Color(val: 0x7C93FE)
        )
        
        circleMenuView.buttons = [
            CircleMenuButton(
                id: "exchange",
                image: "exchange",
                color: Color(val: 0x9F85FF)
            ),
            CircleMenuButton(
                id: "wallet",
                image: "wallet",
                color: Color(val: 0x85B1FF)
            ),
            CircleMenuButton(
                id: "money_box",
                image: "money_box",
                color: Color(val: 0xFF703B)
            ),
            CircleMenuButton(
                id: "visa",
                image: "visa",
                color: Color(val: 0xF55B58)
            )
        ]
        
        circleMenuView.distance = 90.0
        circleMenuView.duration = 0.35
        circleMenuView.halfMode = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

