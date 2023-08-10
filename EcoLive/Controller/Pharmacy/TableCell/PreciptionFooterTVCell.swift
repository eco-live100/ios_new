//
//  PreciptionFooterTVCell.swift
//  DemoApp
//
//  Created by apple on 08/11/22.
//

import UIKit

class PreciptionFooterTVCell: UITableViewCell {
    
    @IBOutlet var placebtn : UIButton!
    @IBOutlet var savebtn : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        placebtn.layer.cornerRadius = placebtn.frame.height/2
        savebtn.layer.cornerRadius = savebtn.frame.height/2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
