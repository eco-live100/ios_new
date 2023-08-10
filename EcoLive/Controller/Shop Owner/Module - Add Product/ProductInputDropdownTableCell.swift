//
//  ProductInputDropdownTableCell.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 19/07/22.
//

import UIKit
import DropDown

class ProductInputDropdownTableCell: UITableViewCell {

    @IBOutlet weak var labelInputText: UILabel!
    @IBOutlet weak var textInputProduct: UITextField!
    @IBOutlet weak var viewDropDown: UIView!
    
    var productDropdown = DropDown()
    var productDropdownSource:[String] = [String]()
    
    var cellModel : ProductAttribute!{
        didSet {
            labelInputText.text = cellModel.label
            textInputProduct.placeholder = cellModel.dropdownList[0].option
            setupDropDown()
        }
    }
    
    var strTextValue : String = ""{
        didSet{
            textInputProduct.text = strTextValue
            cellModel.inputValue = strTextValue
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state  
    }
    
    @IBAction func actionShowDropDown(_ sender: UIButton) {
        productDropdownSource.removeAll()
        self.productDropdown.show()
    }
    
    func setupDropDown() {
        
        for item in cellModel.dropdownList{
            productDropdownSource.append(item.option)
        }
        productDropdownSource.removeFirst()
        
        self.productDropdown = DropDown()
        self.productDropdown.backgroundColor = .white
        self.productDropdown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.productDropdown.textColor = Constants.Color.THEME_BLACK
        self.productDropdown.selectedTextColor = .white
        
        self.productDropdown.anchorView = self.viewDropDown
        self.productDropdown.bottomOffset = CGPoint(x: 0, y:((self.productDropdown.anchorView?.plainView.bounds.height)! + 10))
        self.productDropdown.dataSource = productDropdownSource
        self.productDropdown.direction = .top
        self.productDropdown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.productDropdown.cellHeight = 42
        
        self.productDropdown.selectionAction = { (index: Int, item: String) in
            self.strTextValue = item
        }
        
    }

}
