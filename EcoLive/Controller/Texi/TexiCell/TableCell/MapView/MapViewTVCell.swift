//
//  MapViewTVCell.swift
//  DemoApp
//
//  Created by Ishan Jha on 11/11/22.
//

import UIKit

class MapViewTVCell: UITableViewCell {
    
    @IBOutlet var mainV : UIView!
    @IBOutlet var mapView : UIView!
    @IBOutlet var mapViewHeight : NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mapViewHeight.constant = UIScreen.main.bounds.height/3.7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
