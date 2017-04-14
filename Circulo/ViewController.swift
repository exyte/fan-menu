import UIKit
import Macaw

class ViewController: UIViewController {

    @IBOutlet weak var circleMenuView: CircleMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circleMenuView.menuItem = CircleMenuItem(
            id: "main",
            image: "plus",
            color: Color(val: 0x7C93FE)
        )
        
        circleMenuView.items = [
            CircleMenuItem(
                id: "exchange",
                image: "exchange",
                color: Color(val: 0x9F85FF)
            ),
            CircleMenuItem(
                id: "wallet",
                image: "wallet",
                color: Color(val: 0x85B1FF)
            ),
            CircleMenuItem(
                id: "money_box",
                image: "money_box",
                color: Color(val: 0xFF703B)
            ),
            CircleMenuItem(
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

