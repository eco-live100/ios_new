//
//  NotificationCell.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 19/05/22.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewButtommLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
