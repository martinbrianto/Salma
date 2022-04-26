//
//  ProductTableViewCell.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 25/04/22.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    // MARK: - Identifier
    static let identifier = "ProductTableViewCell"
        static let reuseID = "ProductCell"
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    // MARK: - Outlets
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    // MARK: - Variable
    var productData: Product? {
        didSet {
            setupCell()
        }
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

// MARK: - Private Function
private extension ProductTableViewCell {
    
    private func setupCell(){
        guard let productData = productData else { return }
        addShadow()
        productTitle.text = productData.title
        productPrice.text = productData.price.formattedToRp
        if productData.image != nil{
            productImage.image = productData.image
        }else{
            productImage.image = UIImage(named: "placeholder")
        }
        
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
