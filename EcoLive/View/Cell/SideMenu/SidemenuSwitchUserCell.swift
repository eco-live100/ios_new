//
//  SidemenuSwitchUserCell.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 14/06/22.
//

import UIKit
import DropDown

class SidemenuSwitchUserCell: UITableViewCell {
    
    @IBOutlet weak var viewUserRole: UIView!
    @IBOutlet weak var labelUserRole: UILabel!
    
    var strUserRole : String = ""{
        didSet{
            labelUserRole.text = strUserRole
        }
    }
    
 
    var userRoleDropDown = DropDown()
    var userRoleAction: ((String) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUserRoleDropDown()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
       
    }
    
    func setupUserRoleDropDown() {
        self.userRoleDropDown = DropDown()
        let arrCategory = ["As a Rider","As a User","As a Shop"]
        self.userRoleDropDown.backgroundColor = .white
        self.userRoleDropDown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.userRoleDropDown.textColor = Constants.Color.THEME_BLACK
        self.userRoleDropDown.selectedTextColor = .white
        
        self.userRoleDropDown.anchorView = viewUserRole
        self.userRoleDropDown.bottomOffset = CGPoint(x: 0, y:((self.userRoleDropDown.anchorView?.plainView.bounds.height)! + 10))
        self.userRoleDropDown.dataSource = arrCategory
        self.userRoleDropDown.direction = .bottom
        self.userRoleDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.userRoleDropDown.cellHeight = 42
        
        self.userRoleDropDown.selectionAction = { (index: Int, item: String) in
            self.labelUserRole.text = item
            self.userRoleAction?(item)
        }
    }
}
