//
//  CreatGroupCell.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 26/05/22.
//

import UIKit

class CreateGroupChatUser: UITableViewCell {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.imgUser.layer.cornerRadius = self.imgUser.layer.frame.size.width / 2
            self.imgUser.layer.borderColor = Constants.Color.GrayColor.cgColor
            self.imgUser.layer.borderWidth = 1.0
            self.imgUser.clipsToBounds = true
        }
    }
    
    
    
}
