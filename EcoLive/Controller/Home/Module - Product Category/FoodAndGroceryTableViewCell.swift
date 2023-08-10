//
//  FoodAndGroceryTableViewCell.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 30/06/22.
//

import UIKit

class FoodAndGroceryTableViewCell: UITableViewCell {

    @IBOutlet weak var viewTopDiscount: UIView!
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var lblItem: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewTopDiscount.roundCorners(corners: [.topRight , .bottomRight ], radius: 17.5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
