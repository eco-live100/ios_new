//
//  ProductImageCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 14/06/21.
//

import UIKit

class ProductImageCell: UICollectionViewCell {
    
    @IBOutlet weak var viewAdd: CustomDashedView!
    @IBOutlet weak var imgAdd: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
