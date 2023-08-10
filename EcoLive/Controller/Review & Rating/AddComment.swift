//
//  AddComment.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 16/05/22.
//

import UIKit

class AddComment: BaseVC {
    
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var txtTitle: PaddingTextField!
    @IBOutlet weak var txtComment: KMPlaceholderTextView!
    @IBOutlet weak var btnSendOutlet: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        uiupdate()
    }
    
    func uiupdate(){
        
        self.txtTitle.layer.cornerRadius = self.txtTitle.frame.height / 2.0
        self.txtTitle.layer.borderWidth = 1.0
        self.txtTitle.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        
        self.btnSendOutlet.layer.cornerRadius = self.btnSendOutlet.frame.height / 2.0
//        self.btnSendOutlet.layer.borderWidth = 1.0
        
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    


}
