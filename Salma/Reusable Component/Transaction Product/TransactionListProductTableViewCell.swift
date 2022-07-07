//
//  TransactionListProductTableViewCell.swift
//  Salma
//
//  Created by gratianus.brianto on 08/06/22.
//

import UIKit
import DSFStepperView
import Combine

protocol TransactionListProductTableViewCellDelegate {
    func updateQuantity(index: Int, quantity: Int32)
}

class TransactionListProductTableViewCell: UITableViewCell {

    // MARK: - Identifier
    static let identifier = "TransactionListProductTableViewCell"
        static let reuseID = "TransactionListProduct"
        static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    // MARK: Outlets
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var stepperView: DSFStepperView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBAction func addButtonAction(_ sender: Any) {
        self.addButton.isHidden = true
        self.stepperView.isHidden = false
        self.stepperView.numberValue = 1
    }
    
    // MARK: Var
    var cellData: ProductModel? {
        didSet {
            configureCell()
            if cellData?.quantity != 0 {
                self.addButton.isHidden = true
                self.stepperView.isHidden = false
            }
        }
    }
    var index: Int?
    var cancellable: AnyCancellable?
    var delegate: TransactionListProductTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        configureCell()
        selectionStyle = .none
        self.cancellable = self.stepperView.publishedValue.sink(receiveValue: { currentValue in
            if let c = currentValue {
                if c == 0 {
                    self.stepperView.isHidden = true
                    self.addButton.isHidden = false
                }
                self.delegate?.updateQuantity(index: self.index ?? 0, quantity: Int32(c))
            }
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

private extension TransactionListProductTableViewCell {
    private func configureCell() {
        guard let cellData = cellData else { return }
        productName.text = cellData.name
        productPrice.text = cellData.price.formattedToRp
        stepperView.numberValue = cellData.quantity as NSNumber?
        productImage.image = getImageFromData(imageData: cellData.image)
    }
    
    private func addShadow(){
        cellBackgroundView.layer.masksToBounds = false
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellBackgroundView.layer.shadowRadius = 1
        cellBackgroundView.layer.shadowOpacity = 0.25
        cellBackgroundView.layer.shouldRasterize = true
        cellBackgroundView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func getImageFromData(imageData: Data?) -> UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return UIImage(named: "placeholder")
    }
}
