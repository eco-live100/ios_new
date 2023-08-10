//
//  SenderAudioCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 02/10/21.
//

import UIKit

class SenderAudioCell: UITableViewCell {

    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblPlayerTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
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
