//
//  ScheduleSearchTVCell.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit

class ScheduleSearchTVCell: UITableViewCell {
    
    @IBOutlet weak var searchView : UIView!
    @IBOutlet var plusbtn : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        searchView.dropShadowToCollC()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension UIView{
    func dropShadowToCollC(scale: Bool = true, cornerRadious:CGFloat = 10.0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        layer.cornerRadius = cornerRadious
    }
}
