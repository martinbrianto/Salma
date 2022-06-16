//
//  TransactionButtonTableViewCell.swift
//  Salma
//
//  Created by gratianus.brianto on 06/06/22.
//

import UIKit

class TransactionButtonTableViewCell: UITableViewCell {
    
    var state: TransactionButton? {
        didSet {
            buttonSetup()
        }
    }
    
    @IBOutlet weak var button: UIButton!
    static let identifier = "TransactionButtonTableViewCell"
        static let reuseID = "cellButton"
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

private extension TransactionButtonTableViewCell{
    private func buttonSetup() {
        guard let state = state else { return }
        switch state.pageState {
        case .add:
            break
        case .edit:
            button.backgroundColor = .clear
            button.setTitle("Delete Product", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.setTitleColor(UIColor.red, for: .normal)
        case .detail:
            switch state.transactionStatus {
            case .notPaid:
                button.backgroundColor = UIColor(named: "Main")
                button.setTitle("Paid", for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
                button.setTitleColor(UIColor.white, for: .normal)
            case .inProgress:
                button.backgroundColor = UIColor(named: "Green")
                button.setTitle("Complete", for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
                button.setTitleColor(UIColor.white, for: .normal)
            case .completed:
                button.isHidden = true
            }
        }
    }
}
