//
//  TransactionProductTableViewCell.swift
//  Salma
//
//  Created by gratianus.brianto on 08/06/22.
//

import UIKit

class TransactionProductTableViewCell: UITableViewCell {
    
    // MARK: - Identifier
    static let identifier = "TransactionProductTableViewCell"
        static let reuseID = "TransactionProduct"
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    // MARK: - IBOutlet
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Variables
    var productModel: ProductModel? {
        didSet {
            guard productModel != nil else {
                return
            }
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension TransactionProductTableViewCell {
    private func configureCell() {
        qtyLabel.text = "\(productModel?.quantity ?? 0)x"
        nameLabel.text = "\(productModel?.name ?? "")"
        priceLabel.text = "\(productModel?.price.formattedToRp ?? "")"
    }
}
