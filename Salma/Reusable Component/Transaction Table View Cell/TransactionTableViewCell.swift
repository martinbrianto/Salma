//
//  TransactionTableViewCell.swift
//  Salma
//
//  Created by gratianus.brianto on 20/04/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    // MARK: - Identifier
    static let identifier = "TransactionTableViewCell"
        static let reuseID = "TransactionCell"
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    // MARK: - Outlets
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var transactionName: UILabel!
    @IBOutlet weak var transactionPrice: UILabel!
    @IBOutlet weak var transactionStatusBackground: UIView!
    @IBOutlet weak var transactionStatusLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    
    // MARK: - Variable
    var transactionData: TransactionModel? {
        didSet {
            setupCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
// MARK: - Private Function
private extension TransactionTableViewCell {
    
    private func setupCell(){
        guard let transactionData = transactionData else { return }
        addShadow()
        transactionPrice.text = transactionData.priceTotal.formattedToRp
        transactionName.text = transactionData.customerName
        transactionStatusLabel.text = transactionData.status.rawValue
        transactionDateLabel.text = transactionData.dateCreated?.getFormattedDate(format: "dd MMM YYYY")
        switch transactionData.status {
        case .notPaid:
            transactionStatusLabel.textColor = UIColor(named: "Red")
            transactionStatusBackground.backgroundColor = UIColor(named: "Error50")
        case .inProgress:
            transactionStatusLabel.textColor = UIColor(named: "Yellow")
            transactionStatusBackground.backgroundColor = UIColor(named: "Warning50")
        case .completed:
            transactionStatusLabel.textColor = UIColor(named: "Success700")
            transactionStatusBackground.backgroundColor = UIColor(named: "Success50")
        }
    }
    
    private func addShadow(){
        cellBackgroundView.layer.masksToBounds = false
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellBackgroundView.layer.shadowRadius = 1
        cellBackgroundView.layer.shadowOpacity = 0.25
        cellBackgroundView.layer.shouldRasterize = true
        cellBackgroundView.layer.rasterizationScale = UIScreen.main.scale
    }
}
