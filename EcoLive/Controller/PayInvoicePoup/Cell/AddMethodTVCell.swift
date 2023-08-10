//
//  AddMethodVC.swift
//  
//
//  Created by apple on 26/10/22.
//

import UIKit

class AddMethodTVCell: UITableViewCell {
    
    @IBOutlet weak var mainV : UIView!
    @IBOutlet var cvvView : UIView!
    @IBOutlet var goodsYesBtn : UIButton!
    @IBOutlet var goodsNoBtn : UIButton!
    
    @IBOutlet var payingYesBtn : UIButton!
    @IBOutlet var payingNoBtn : UIButton!
    @IBOutlet var btnCheckUncheck : UIButton!
    @IBOutlet var paybtn : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        paybtn.layer.cornerRadius = paybtn.frame.height/2
        payingYesBtn.layer.cornerRadius = payingYesBtn.frame.height/2
        payingNoBtn.layer.cornerRadius = payingNoBtn.frame.height/2
        
        goodsYesBtn.layer.cornerRadius = goodsYesBtn.frame.height/2
        goodsNoBtn.layer.cornerRadius = goodsNoBtn.frame.height/2
        cvvView.layer.cornerRadius = 25.0
        cvvView.layer.cornerRadius = cvvView.frame.height/2
        cvvView.layer.borderColor = UIColor.lightGray.cgColor
        cvvView.layer.borderWidth = 0.7
        
        mainV.layer.masksToBounds = false
        mainV.layer.shadowColor = UIColor.lightGray.cgColor
        mainV.layer.shadowOpacity = 0.2
        mainV.layer.shadowOffset = CGSize(width: -1, height: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnCheckUncheck(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            btnCheckUncheck.setImage(UIImage(named: "square"), for: .normal)
            btnCheckUncheck.isSelected = false
        } else {
            btnCheckUncheck.setImage(UIImage(named: "check"), for: .normal)
            btnCheckUncheck.isSelected = true
        }
    }
}
