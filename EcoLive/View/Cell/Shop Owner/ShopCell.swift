//
//  ShopCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 21/07/21.
//

import UIKit

class ShopCell: UITableViewCell {

    @IBOutlet weak var imgShop: UIImageView!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblShopType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.imgShop.layer.cornerRadius = self.imgShop.layer.frame.size.width / 2.0
//            self.imgShop.createButtonShadow()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
