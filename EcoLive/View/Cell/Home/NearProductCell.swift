//
//  NearProductCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 01/07/21.
//

import UIKit

class NearProductCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblShopLive: UILabel!
    @IBOutlet weak var lblShopOnline: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewContainer.drawShadow()
            
            self.viewDetail.roundCorners(corners: [.topRight, .bottomRight], radius: 7)
        }
    }
}
