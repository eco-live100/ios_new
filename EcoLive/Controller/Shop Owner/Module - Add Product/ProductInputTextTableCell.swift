//
//  ProductInputTextTableCell.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 19/07/22.
//

import UIKit

@available(iOS 14.0, *)
class ProductInputTextTableCell: UITableViewCell {
    
    @IBOutlet weak var labelInputText: UILabel!
    @IBOutlet weak var textInputProduct: UITextField!

    var vc : AddProductViewController?
    
    var cellModel : ProductAttribute!{
        didSet{
            if cellModel.inputType == "number"{
                textInputProduct.keyboardType = .numberPad
            }
            labelInputText.text = cellModel.label
            textInputProduct.placeholder = cellModel.placeHolder
        }
    }
    
    var strTextValue : String = ""{
        didSet{
            textInputProduct.text = strTextValue
            cellModel.inputValue = strTextValue
            vc?.productName = strTextValue
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
        
    @IBAction func onChangeText(_ sender: UITextField) {
        strTextValue = sender.text ?? ""
    }

}
