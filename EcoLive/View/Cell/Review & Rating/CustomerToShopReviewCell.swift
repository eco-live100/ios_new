//
//  CustomerToShopReviewCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 28/06/21.
//

import UIKit
import Cosmos

class CustomerToShopReviewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var viewReply: UIView!
    @IBOutlet weak var btnReply: UIButton!
    
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
