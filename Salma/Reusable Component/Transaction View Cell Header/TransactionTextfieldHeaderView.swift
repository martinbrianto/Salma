//
//  TransactionTextfieldHeaderView.swift
//  Salma
//
//  Created by gratianus.brianto on 04/06/22.
//

import UIKit

class TransactionTextfieldHeaderView: UITableViewHeaderFooterView {

    static let identifier = "TransactionViewCellHeaderView"
        static let reuseID = "TransactionTextfieldHeaderView"
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    // MARK: - Outlet
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String? {
        didSet {
            setupHeader()
        }
    }
    
    var headerType: TransactionHeaderType? {
        didSet {
                setupHeader()
        }
    }
    
    var buttonAction: (()->())?
    
    static let height: CGFloat = 28
}

extension TransactionTextfieldHeaderView {
    private func setupHeader(){
        if let headerType = self.headerType {
            headerButton.isHidden = true
            switch headerType {
            case .customerData:
                titleLabel.text = headerType.rawValue
            case .address:
                titleLabel.text = headerType.rawValue
            case .productDetails:
                titleLabel.text = headerType.rawValue
            case .shippingDetails:
                headerButton.isHidden = false
                titleLabel.text = headerType.rawValue
            case .totalPrice:
                titleLabel.text = headerType.rawValue
            }
        }
    }
}
