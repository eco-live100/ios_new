//
//  CustomerToProductReviewCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 29/06/21.
//

import UIKit
import Cosmos

class CustomerToProductReviewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblContent1: UILabel!
    @IBOutlet weak var lblContent2: UILabel!
    @IBOutlet weak var lblContent3: UILabel!
    @IBOutlet weak var stackviewImgReview: UIStackView!
    @IBOutlet weak var imgReview: UIImageView!
    @IBOutlet weak var lblReview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.imgUser.layer.cornerRadius = self.imgUser.layer.frame.size.width / 2.0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
