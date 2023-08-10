//
//  DialPadVC.swift
//  LancerT
//
//  Created by SunflowerLab on 28/10/22.
//

import UIKit

class DialPadVC: UIViewController {

    @IBOutlet weak var phoneNumTxtFld: UITextField!
    @IBOutlet weak var getSubCriptionView: UIView!
    
    var phoneNumArr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpUI(){
        self.getSubCriptionView.layer.cornerRadius = 25
    }
    @IBAction func didTapOnKeyBaordActio(sender: UIButton){
        switch (sender.tag){
        case 1:
            updatePhoneNumer(number: "\(sender.tag)")
        case 2:
            updatePhoneNumer(number: "\(sender.tag)")
        case 3:
            updatePhoneNumer(number: "\(sender.tag)")
        case 4:
            updatePhoneNumer(number: "\(sender.tag)")
        case 5:
            updatePhoneNumer(number: "\(sender.tag)")
        case 6:
            updatePhoneNumer(number: "\(sender.tag)")
        case 7:
            updatePhoneNumer(number: "\(sender.tag)")
        case 8:
            updatePhoneNumer(number: "\(sender.tag)")
        case 9:
            updatePhoneNumer(number: "\(sender.tag)")
        case 10:
            updatePhoneNumer(number: "+")
        case 11:
            updatePhoneNumer(number: "0")
        case 12:
            updatePhoneNumer(number: "#")
        case 13:
            print("message")

            let controller = GlobalData.friendStoryBoard().instantiateViewController(withIdentifier: "ContactDetailVC") as! ContactDetailVC
            self.navigationController?.pushViewController(controller, animated: true)

        case 14:
            print("Call")
        case 15:
            guard phoneNumArr.count > 0 else {return}
            phoneNumArr.removeLast()
            self.phoneNumTxtFld.text = phoneNumArr.joined()
        default:
            print("")
        }
    }
    
    func updatePhoneNumer(number: String){
        phoneNumArr.append(number)
        self.phoneNumTxtFld.text = phoneNumArr.joined()
    }
}
