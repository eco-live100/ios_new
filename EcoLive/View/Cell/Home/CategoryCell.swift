//
//  CategoryCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 10/08/21.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var lblProductTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewContainer.drawShadow()
            self.viewDetail.roundCorners(corners: [.topRight, .bottomRight], radius: 12)
        }
        
    }
}
