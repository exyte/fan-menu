import Foundation
import UIKit
import FanMenu
import Macaw

class FinanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var fanMenu: FanMenu!
    @IBOutlet weak var tableView: UITableView!
    
    let data = [
        ("income", "Salary", "06-01", "+$1353.00", "transaction_salary"),
        ("outcome", "Coffee", "06-02", "-$3.50", "transaction_coffee"),
        ("income", "Part Time", "06-02", "+$100.00", "transaction_clock"),
        ("outcome", "Dinner", "06-04", "-$55.00", "transaction_dinner"),
        ("outcome", "Shopping", "06-04", "-$511.30", "transaction_shoping"),
        ("outcome", "Travel", "07-05", "-$2800.00", "transaction_travel")
    ]
    
    let items = [
        ("exchange", 0x9F85FF),
        ("wallet", 0x85B1FF),
        ("money_box", 0xFF703B),
        ("visa", 0xF55B58),
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
        
        fanMenu.button = FanMenuButton(
            id: "main",
            image: UIImage(named: "menu_plus"),
            color: Color(val: 0x7C93FE)
        )
        
        fanMenu.items = items.map { button in
            FanMenuButton(
                id: button.0,
                image: UIImage(named: "menu_\(button.0)"),
                color: Color(val: button.1)
            )
        }
        
        fanMenu.menuRadius = 90.0
        fanMenu.duration = 0.2
        fanMenu.delay = 0.05
        fanMenu.interval = (Double.pi, 2 * Double.pi)

        fanMenu.onItemDidClick = { button in
            print("ItemDidClick: \(button.id)")
        }

        fanMenu.onItemWillClick = { button in
            print("ItemWillClick: \(button.id)")
        }
        
        fanMenu.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        fanMenu.updateNode()
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
