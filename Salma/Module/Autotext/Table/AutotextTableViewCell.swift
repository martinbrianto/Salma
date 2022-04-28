//
//  AutotextTableViewCell.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 26/04/22.
//

import UIKit

class AutotextTableViewCell: UITableViewCell {

    // MARK: - Identifier
    static let identifier = "AutotextTableViewCell"
        static let reuseID = "AutotextCell"
        static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    // MARK: - Variable
    var autotextData: Autotext? {
        didSet {
            setupCell()
        }
    }
    
    // MARK: - VC Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Private Function
private extension AutotextTableViewCell {
    
    private func setupCell(){
        guard let autotextData = autotextData else { return }
        addShadow()
        titleLabel.text = autotextData.title
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
