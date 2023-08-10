//
//  ProductInputTextareaTableCell.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 19/07/22.
//

import UIKit

class ProductInputTextareaTableCell: UITableViewCell {

    @IBOutlet weak var labelInputText: UILabel!
    var cellModel : ProductAttribute!{
        didSet{
            labelInputText.text = cellModel.label
           
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

}
