//
//  SaveLocationTVCell.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit

class SaveLocationTVCell: UITableViewCell {
    
    @IBOutlet var nowView : UIView!
    @IBOutlet var searchView : UIView!
    @IBOutlet var mapOutetView : UIView!
    @IBOutlet var mapView : UIView!
    @IBOutlet var searchbtn : UIButton!
    @IBOutlet var savedbtn : UIButton!

    @IBOutlet weak var btnDestination: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        searchView.layer.cornerRadius = 10
        mapOutetView.layer.cornerRadius = 10
        mapView.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
