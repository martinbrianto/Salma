//
//  AddCustomProductTableViewCell.swift
//  Salma
//
//  Created by gratianus.brianto on 10/06/22.
//

import UIKit

class AddCustomProductTableViewCell: UITableViewCell {

    // MARK: - Identifier
    static let identifier = "AddCustomProductTableViewCell"
        static let reuseID = "AddCustomProduct"
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    // MARK: Outlets
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

private extension AddCustomProductTableViewCell {
    private func addShadow(){
        cellBackgroundView.layer.masksToBounds = false
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellBackgroundView.layer.shadowRadius = 1
        cellBackgroundView.layer.shadowOpacity = 0.25
        cellBackgroundView.layer.shouldRasterize = true
        cellBackgroundView.layer.rasterizationScale = UIScreen.main.scale
    }
}
