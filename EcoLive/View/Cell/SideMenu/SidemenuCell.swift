//
//  SidemenuCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 08/06/21.
//

import UIKit

class SidemenuCell: UITableViewCell {

    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var imgVwOption: UIImageView!
    @IBOutlet weak var lblOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
