//
//  TransactionButtonTableViewCell.swift
//  Salma
//
//  Created by gratianus.brianto on 06/06/22.
//

import UIKit

class TransactionButtonTableViewCell: UITableViewCell {
    
    static let identifier = "TransactionButtonTableViewCell"
        static let reuseID = "cellButton"
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
