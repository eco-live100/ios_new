//
//  SaveAddressViewCell.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 07/06/22.
//

import UIKit

class SaveAddressViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblIconAddress: UIImageView!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.async { [self] in
            
            bgView.cornerRadius = 10
            bgView.clipsToBounds = true
            bgView.createButtonShadow()
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
