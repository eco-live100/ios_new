//
//  ColorCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 18/06/21.
//

import UIKit

class ColorCell: UITableViewCell {

    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var lblColorName: UILabel!
    @IBOutlet weak var btnRadio: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewColor.layer.cornerRadius = self.viewColor.layer.frame.size.width / 2
            self.viewColor.clipsToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class bgColorCell : UICollectionViewCell {
    
    @IBOutlet weak var bgImage: UIImageView!
    
}
