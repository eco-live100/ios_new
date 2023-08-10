//
//  CartCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 23/06/21.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFreeShipping: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblProductTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        DispatchQueue.main.async {
//            self.viewContainer.createButtonShadow()
//        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
