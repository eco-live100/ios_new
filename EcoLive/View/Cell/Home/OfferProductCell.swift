//
//  OfferProductCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 01/07/21.
//

import UIKit

class OfferProductCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewThumbnail: UIView!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewThumbnail.layer.cornerRadius = 15
            self.viewThumbnail.createButtonShadow()
        }
    }
}
