//
//  ReceiverFileCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 21/06/21.
//

import UIKit

class ReceiverFileCell: UITableViewCell {

    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var imgFile: UIImageView!
    @IBOutlet weak var btnFile: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewMessage.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 7)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
