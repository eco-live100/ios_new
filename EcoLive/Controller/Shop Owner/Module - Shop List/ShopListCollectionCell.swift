//
//  ShopListCollectionCell.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 11/07/22.
//

import UIKit
import SDWebImage

class ShopListCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageShopLogo:UIImageView!
    @IBOutlet weak var labelShopName:UILabel!
    @IBOutlet weak var labelShopAddress:UILabel!
    @IBOutlet weak var buttonRemoveShop: UIButton!
    
    var cellModel : ShopObject!{
        didSet{
            labelShopName.text = cellModel.shopName
            labelShopAddress.text = cellModel.storeAddress
            imageShopLogo.sd_setImage(with: URL(string: cellModel.storeLogo ?? ""), placeholderImage: UIImage(named: "PlaceHolder"))
        }
    }
    
}

