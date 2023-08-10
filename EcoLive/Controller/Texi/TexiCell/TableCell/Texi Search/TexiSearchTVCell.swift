//
//  TexiSearchTVCell.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit
import MapKit

class TexiSearchTVCell: UITableViewCell {
    
    @IBOutlet var nowView : UIView!
    @IBOutlet var searchView : UIView!
    @IBOutlet var mapOutetView : UIView!
    @IBOutlet var mapView : UIView!
    @IBOutlet var searchbtn : UIButton!
    @IBOutlet var btnTapNow : UIButton!
    @IBOutlet var savedbtn : UIButton!
    @IBOutlet var destinationbtn : UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        nowView.layer.cornerRadius = 6
        searchView.layer.cornerRadius = 10
        mapOutetView.layer.cornerRadius = 10
        mapView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
