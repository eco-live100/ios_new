//
//  MessageCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 18/06/21.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSeprate: UILabel!
    @IBOutlet weak var viewSelected: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewSelected.layer.cornerRadius = self.viewSelected.frame.height / 2.0

            self.imgUser.layer.cornerRadius = self.imgUser.layer.frame.size.width / 2
            self.imgUser.layer.borderColor = Constants.Color.GrayColor.cgColor
            self.imgUser.layer.borderWidth = 1.0
            self.imgUser.clipsToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         if selected {
            //self.viewSelected.backgroundColor = UIColor.init(hex: 0x3663f5, a: 0.19)
//            self.contentView.backgroundColor = UIColor.clear
         } else {
            self.viewSelected.backgroundColor = UIColor.clear
//            self.contentView.backgroundColor = UIColor.clear
         }
     }
}
