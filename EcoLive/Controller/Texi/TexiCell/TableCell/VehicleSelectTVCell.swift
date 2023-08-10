//
//  VehicleSelectTVCell.swift
//  DemoApp
//
//  Created by Ishan Jha on 11/11/22.
//

import UIKit

class VehicleSelectTVCell: UITableViewCell {
    
    @IBOutlet var vehicleView1 : UIView!
    @IBOutlet var vehicleView2 : UIView!
    @IBOutlet var vehicleView3 : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vehicleView1.dropShadowToCollC()
        vehicleView2.dropShadowToCollC()
        vehicleView3.dropShadowToCollC()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
