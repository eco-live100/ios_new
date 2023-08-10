//
//  PreciptionTVCell.swift
//  DemoApp
//
//  Created by Ishan Jha on 08/11/22.
//

import UIKit

class PreciptionTVCell: UITableViewCell {
    
    @IBOutlet var callView : UIView!
    @IBOutlet var chatView : UIView!
    @IBOutlet var contactbtn : UIButton!
    @IBOutlet var mainView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        callView.layer.cornerRadius = 5
        chatView.layer.cornerRadius = 5
        mainView.layer.cornerRadius = 10
        contactbtn.layer.cornerRadius = contactbtn.frame.height/2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
