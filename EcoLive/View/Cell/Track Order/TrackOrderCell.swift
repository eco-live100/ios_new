//
//  TrackOrderCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 15/06/21.
//

import UIKit

class TrackOrderCell: UITableViewCell {

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewCircle: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
