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
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func headerButtonAction(_ sender: Any) {
        print("shit")
    }
    
    var title: String? {
        didSet {
            setupHeader()
        }
    }
    static let height: CGFloat = 28
}

extension TransactionTextfieldHeaderView {
    private func setupHeader(){
        titleLabel.text = title
    }
}
