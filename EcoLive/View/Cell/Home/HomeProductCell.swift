//
//  HomeProductCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 29/06/21.
//

import UIKit

class HomeProductCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblFreeShipping: UILabel!
    @IBOutlet weak var lblShopLive: UILabel!
    @IBOutlet weak var lblShopOnline: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewContainer.drawShadow(borderWidth: 0.65)
            self.viewContainer.borderColor = .lightGray
            self.viewContainer.borderWidth  = 1.0
        }
    }
    
}
