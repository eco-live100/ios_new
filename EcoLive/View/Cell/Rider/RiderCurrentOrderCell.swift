//
//  RiderCurrentOrderCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 17/06/21.
//

import UIKit

class RiderCurrentOrderCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblOrderTime: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblEarn: UILabel!
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewContainer.createButtonShadow()

            self.btnAccept.layer.cornerRadius = self.btnAccept.frame.height / 2.0
            self.btnDecline.layer.cornerRadius = self.btnDecline.frame.height / 2.0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
