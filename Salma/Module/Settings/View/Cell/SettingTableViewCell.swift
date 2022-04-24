//
//  SettingTableViewCell.swift
//  Salma
//
//  Created by gratianus.brianto on 25/04/22.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    // MARK: - Identifier
    static let identifier = "SettingTableViewCell"
        static let reuseID = "SettingCell"
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Variable
    var title: String? {
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
// MARK: - Private Func
private extension SettingTableViewCell {
    private func setupCell(){
        if let title = self.title {
            textLabel?.text = title
        }
    }
}
