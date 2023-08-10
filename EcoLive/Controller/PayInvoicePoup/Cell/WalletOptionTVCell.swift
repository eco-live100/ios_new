//
//  WalletOptionTVCell.swift
//  
//
//  Created by apple on 26/10/22.
//

import UIKit

class WalletOptionTVCell: UITableViewCell {
    
    @IBOutlet var mainView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = false
        mainView.layer.shadowColor = UIColor.lightGray.cgColor
        mainView.layer.shadowOpacity = 0.2
        mainView.layer.shadowOffset = CGSize(width: -1, height: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
