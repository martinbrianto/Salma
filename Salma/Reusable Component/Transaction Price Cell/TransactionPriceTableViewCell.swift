//
//  TransactionPriceTableViewCell.swift
//  Salma
//
//  Created by gratianus.brianto on 08/06/22.
//

import UIKit

class TransactionPriceTableViewCell: UITableViewCell {
    
    // MARK: - Identifier
    static let identifier = "TransactionPriceTableViewCell"
        static let reuseID = "TransactionPrice"
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    @IBOutlet weak var subtotalPriceLabel: UILabel!
    @IBOutlet weak var shippingPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var transactionPriceData: TransactionModel? {
        didSet {
            configureCell()
        }
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

private extension TransactionPriceTableViewCell {
    private func configureCell() {
        guard let transactionPriceData = transactionPriceData else { return }
        subtotalPriceLabel.text = transactionPriceData.priceSubTotal.formattedToRp
        shippingPriceLabel.text = transactionPriceData.shippingPrice.formattedToRp
        totalPriceLabel.text = transactionPriceData.priceTotal.formattedToRp
    }
}
