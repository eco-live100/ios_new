//
//  FriendCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 21/09/21.
//

import UIKit

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var viewDP: UIView!
    @IBOutlet weak var imgDP: UIImageView!
    @IBOutlet weak var lblDP: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.imgDP.layer.cornerRadius = self.imgDP.layer.frame.size.width / 2.0
            self.viewDP.layer.cornerRadius = self.viewDP.layer.frame.size.width / 2.0
            self.viewDP.createButtonShadow()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
