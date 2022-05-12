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
    var title: String? {
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
//        guard let autotextData = autotextData else { return }
//        titleLabel.text = autotextData.title
        if let title = self.title {
            textLabel?.text = title
        }
    }
}
