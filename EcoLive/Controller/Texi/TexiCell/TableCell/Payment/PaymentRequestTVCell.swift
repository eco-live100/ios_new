//
//  PaymentRequestTVCell.swift
//  DemoApp
//
//  Created by Ishan Jha on 11/11/22.
//

import UIKit

class PaymentRequestTVCell: UITableViewCell {
    
    
    @IBOutlet var mainV : UIView!
    @IBOutlet var searchView : UIView!
    @IBOutlet var clickbtn : UIButton!
    @IBOutlet var searchStackView : UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //searchView.dropShadowToCollC()
        // Initialization code
        clickbtn.layer.borderWidth = 1
        clickbtn.layer.borderColor = UIColor.black.cgColor
        clickbtn.layer.cornerRadius = 8
        //mainV.dropShadowToCollC()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
