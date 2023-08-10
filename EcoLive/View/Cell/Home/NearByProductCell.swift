//
//  NearByProductCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 06/12/21.
//

import UIKit

class NearByProductCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblFreeShipping: UILabel!
    @IBOutlet weak var viewShopLive: UIView!
    @IBOutlet weak var lblShopLive: UILabel!
    @IBOutlet weak var viewShopOnline: UIView!
    @IBOutlet weak var lblShopOnline: UILabel!
    
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
