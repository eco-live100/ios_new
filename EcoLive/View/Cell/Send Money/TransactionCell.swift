//
//  TransactionCell.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 23/06/21.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var viewDP: UIView!
    @IBOutlet weak var imgDP: UIImageView!
    @IBOutlet weak var lblDP: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.imgDP.layer.cornerRadius = self.imgDP.layer.frame.size.width / 2.0
            self.viewDP.layer.cornerRadius = self.viewDP.layer.frame.size.width / 2.0
            self.viewDP.createButtonShadow()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
}
