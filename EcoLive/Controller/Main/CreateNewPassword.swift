//
//  CreateNewPassword.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 03/06/22.
//

import UIKit
import SwiftValidators
import CountryPickerView

class CreateNewPassword: UIViewController {
    
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewConfirmPassword: UIView!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!

    var userId = "0"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            
            self.viewPassword.layer.cornerRadius = self.viewPassword.frame.height / 2.0
            self.viewPassword.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewPassword.layer.borderWidth = 1.0
            
            self.viewConfirmPassword.layer.cornerRadius = self.viewConfirmPassword.frame.height / 2.0
            self.viewConfirmPassword.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewConfirmPassword.layer.borderWidth = 1.0
            
            self.btnSubmit.layer.cornerRadius = self.btnSubmit.frame.height / 2.0
            self.btnSubmit.createButtonShadow()
        }
        
    }
    

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        if self.txtPassword.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Password is required")
        }
        else if !Validator.minLength(6).apply(self.txtPassword.text!) {
            GlobalData.shared.showDarkStyleToastMesage(message: "Password should be 6 character long")
        }
        else if self.txtConfirmPassword.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Confirm password is required")
        }
        else if self.txtPassword.text != self.txtConfirmPassword.text {
            GlobalData.shared.showDarkStyleToastMesage(message: "Password and confirm password is not same")
        }else{
            apiCreatePassword()
        }
        
    }
    
    func apiCreatePassword(){
        var parm = ["userId": userId,
                    "newPassword" : ((txtConfirmPassword.text?.trimmingCharacters(in: .whitespaces)) ?? "")
        ] as [String : Any]
        
        print(parm)
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callService(url: NetworkManager.New_API_DIR + "reset-password", parameters: parm) {
            (resStatus) in
            GlobalData.shared.hideProgress()
            switch resStatus {
            case .failed(let errorMessage ):
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            case .success(let response ):
                // print(response)
               
                GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    let navController = UINavigationController.init(rootViewController: controller)
                    appDelegate.window?.rootViewController = navController
                }
            }
        }
    }


}
