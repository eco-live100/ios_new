//
//  WishlistCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 06/07/21.
//

import UIKit

class WishlistCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewShopLive: UIView!
    @IBOutlet weak var lblShopLive: UILabel!
    @IBOutlet weak var viewShopOnline: UIView!
    @IBOutlet weak var lblShopOnline: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewContainer.createButtonShadow()
            
            self.viewShopLive.createButtonShadow()
            self.viewShopOnline.createButtonShadow()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
