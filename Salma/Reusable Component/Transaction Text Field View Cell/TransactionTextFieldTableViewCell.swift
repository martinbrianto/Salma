//
//  TransactionTextFieldTableViewCell.swift
//  Salma
//
//  Created by gratianus.brianto on 04/06/22.
//

import UIKit

class TransactionTextFieldTableViewCell: UITableViewCell {
    
    // MARK: - Identifier
    static let identifier = "TransactionTextFieldTableViewCell"
        static let reuseID = "TransactionTextField"
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var chevronImg: UIImageView!
    

    var textFieldInput: String?
    var pageState: TransactionPageState?
    var textfieldType: TransactionTextfieldType? {
        didSet {
            if textfieldType != nil {
                setupTextfield()
            } else {
                return
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension TransactionTextFieldTableViewCell {
    private func setupTextfield() {
        titleLabel.text = textfieldType?.tfTitle
        textfield.placeholder = textfieldType?.tfPlaceholder
        selectionStyle = .none
        textfield.text = textFieldInput
        switch textfieldType {
        case .shippingPrice, .addressPostalCode, .customerPhoneNumber:
            if pageState == .detail {
                textfield.isEnabled = false
                textfield.textColor = UIColor(named: "textFieldDisabled")
            } else {
                textfield.isEnabled = true
                textfield.textColor = UIColor.darkText
            }
            textfield.keyboardType = .numberPad
        case .addProduct:
            chevronImg.isHidden = false
            textfield.isEnabled = false
            if pageState == .detail {
                textfield.textColor = UIColor(named: "textFieldDisabled")
            } else {
                textfield.textColor = UIColor.darkText
            }
        default:
            if pageState == .detail {
                textfield.isEnabled = false
                textfield.textColor = UIColor(named: "textFieldDisabled")
            } else {
                textfield.isEnabled = true
                textfield.textColor = UIColor.darkText
            }
            chevronImg.isHidden = true
        }
    }
}
