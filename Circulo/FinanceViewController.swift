import Foundation
import UIKit
import Macaw

class FinanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var circleMenuView: CircleMenuView!
    @IBOutlet weak var gradienView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let data = [
        ("income", "Salary", "06-01", "+$1353.00", "transaction_salary"),
        ("outcome", "Coffee", "06-02", "-$3.50", "transaction_coffee"),
        ("income", "Part Time", "06-02", "+$100.00", "transaction_clock"),
        ("outcome", "Dinner", "06-04", "-$55.00", "transaction_dinner"),
        ("outcome", "Shopping", "06-04", "-$511.30", "transaction_shoping"),
        ("outcome", "Travel", "07-05", "-$2800.00", "transaction_travel")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor(
            red: CGFloat(211.0) / 255.0,
            green: CGFloat(223.0) / 255.0,
            blue: CGFloat(242.0) / 255.0,
            alpha: 1.0
        )
        
        let gradient = CAGradientLayer()
        gradient.frame = self.gradienView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        gradienView.layer.mask = gradient
        
        circleMenuView.centerButton = CircleMenuButton(
            id: "main",
            image: "menu_plus",
            color: Color(val: 0x7C93FE)
        )

        circleMenuView.buttons = [
            CircleMenuButton(
                id: "exchange",
                image: "menu_exchange",
                color: Color(val: 0x9F85FF)
            ),
            CircleMenuButton(
                id: "wallet",
                image: "menu_wallet",
                color: Color(val: 0x85B1FF)
            ),
            CircleMenuButton(
                id: "money_box",
                image: "menu_money_box",
                color: Color(val: 0xFF703B)
            ),
            CircleMenuButton(
                id: "visa",
                image: "menu_visa",
                color: Color(val: 0xF55B58)
            )
        ]

        circleMenuView.distance = 90.0
        circleMenuView.duration = 0.35
        circleMenuView.halfMode = true

        circleMenuView.onButtonPressed = { button in
            switch button.id {
            case "exchange":
                print("open exchange screen")
            case "visa":
                print("open cards screen")
            default:
                print("other")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.data[indexPath.row]
        let cellClass = data.0 == "income" ? "IncomeCell" : "OutcomeCell"
        let transactionCell = self.tableView.dequeueReusableCell(withIdentifier: cellClass) as! TransactionCell
        transactionCell.titleLabel.text = data.1
        transactionCell.dateLabel.text = data.2
        transactionCell.amountLabel.text = data.3
        transactionCell.transactionImage.image = UIImage(named: data.4)!
        return transactionCell
}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}

class TransactionCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var transactionImage: UIImageView!
}
