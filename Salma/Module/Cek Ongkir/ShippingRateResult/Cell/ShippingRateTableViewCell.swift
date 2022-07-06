//
//  ShippingRateTableViewCell.swift
//  Salma
//
//  Created by gratianus.brianto on 06/07/22.
//

import UIKit

class ShippingRateTableViewCell: UITableViewCell {
    
    static let identifier = "ShippingRateTableViewCell"
    static let reusableID = "ShippingRate"
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var namaJasaLbl: UILabel!
    @IBOutlet weak var durasiPengirimanLbl: UILabel!
    @IBOutlet weak var biayaPengirimanLbl: UILabel!
    @IBOutlet weak var jasaImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}

extension ShippingRateTableViewCell {
    func configureCell(data: Pricing) {
        namaJasaLbl.text = data.courier_service_name
        durasiPengirimanLbl.text = data.duration
        biayaPengirimanLbl.text = data.price.formattedToRp
        jasaImg.image = UIImage(named: data.courier_name)
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
