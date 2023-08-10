//
//  SenderImageCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 21/06/21.
//

import UIKit

class SenderImageCell: UITableViewCell {

    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewMessage.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 7)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
