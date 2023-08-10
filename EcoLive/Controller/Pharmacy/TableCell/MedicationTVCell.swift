//
//  MedicationTVCell.swift
//  DemoApp
//
//  Created by apple on 08/11/22.
//

import UIKit

class MedicationTVCell: UITableViewCell {
    
    @IBOutlet var mainView : UIView!
    @IBOutlet var indicationView : UIView!
    @IBOutlet var additionalView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        indicationView.layer.borderWidth = 0.5
        indicationView.layer.borderColor = UIColor.darkGray.cgColor
        indicationView.layer.cornerRadius = 8
        
        additionalView.layer.borderWidth = 0.5
        additionalView.layer.borderColor = UIColor.darkGray.cgColor
        additionalView.layer.cornerRadius = 8
        mainView.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
