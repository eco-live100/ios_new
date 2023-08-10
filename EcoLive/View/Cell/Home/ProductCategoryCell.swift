//
//  ProductCategoryCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 16/06/21.
//

import UIKit

class ProductCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCatTitle: UILabel!
    @IBOutlet weak var lblCatDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    
    @IBOutlet weak var btn3Dot: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
