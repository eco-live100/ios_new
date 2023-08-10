//
//  ShopProductCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 10/06/21.
//

import UIKit

class ShopProductCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDescription: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewContainer.createButtonShadow()
            
//            self.viewContainer.layer.borderColor = UIColor.lightGray.cgColor
//            self.viewContainer.layer.borderWidth = 0.3
//
//            self.viewContainer.layer.masksToBounds = false
//            self.viewContainer.layer.shadowRadius = 1
//            self.viewContainer.layer.shadowOpacity = 0.6
//            self.viewContainer.layer.shadowColor = UIColor.lightGray.cgColor
//            self.viewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
