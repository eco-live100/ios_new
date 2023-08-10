//
//  CartFooterView.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 24/06/21.
//

import UIKit

class CartFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var lblItemTotal: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var btnBuyNow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.btnBuyNow.layer.cornerRadius = self.btnBuyNow.frame.height / 2.0
            self.btnBuyNow.createButtonShadow()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

