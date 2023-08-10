//
//  OptionSignupVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 07/06/21.
//

import UIKit
import DLRadioButton

enum OPTION_TYPE : Int {
    case USER       = 0
    case RIDER      = 1
    case SHOP_OWNER = 2
}

class OptionSignupVC: BaseVC {
    
    static func getObject()-> OptionSignupVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OptionSignupVC") as? OptionSignupVC
        if let vc = vc {
            return vc
        }
        return OptionSignupVC()
    }
    
    //MARK: - PROPERTIES & OUTLETS -
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewRider: UIView!
    @IBOutlet weak var viewShopOwner: UIView!
    @IBOutlet var btnOption: [DLRadioButton]!
    @IBOutlet weak var btnNext: UIButton!
    
    var selectedOption:Int = -1
    var isFrome = "Login"

    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        self.viewContent.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        
//        self.btnOption.isMultipleSelectionEnabled = false
        for i in btnOption {
            i.isMultipleSelectionEnabled = false
        }

        DispatchQueue.main.async {
            self.viewUser.createButtonShadow()
            self.viewRider.createButtonShadow()
            self.viewShopOwner.createButtonShadow()
            
            self.btnNext.layer.cornerRadius = self.btnNext.frame.height / 2.0
            self.btnNext.createButtonShadow()
        }
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOptionClick(radioButton : DLRadioButton) {
        if radioButton.accessibilityIdentifier ?? "" ==  "User" {
            self.selectedOption = OPTION_TYPE.USER.rawValue
        } else if radioButton.accessibilityIdentifier ?? "" ==  "Rider" {
            self.selectedOption = OPTION_TYPE.RIDER.rawValue
        } else if radioButton.accessibilityIdentifier ?? "" ==  "ShopOwner" {
            self.selectedOption = OPTION_TYPE.SHOP_OWNER.rawValue
        }
        debugPrint("SELECTED OPTION:- \(self.selectedOption)")
    }
    
    @IBAction func btnSwitchType(_ sender: UIButton) {
        
        for i in 0 ..< btnOption.count{
            btnOption[i].isSelected = false
        }
        if sender.tag == 1 {
            self.selectedOption = OPTION_TYPE.USER.rawValue
            btnOption[0].isSelected = true
        } else if sender.tag == 2{
            self.selectedOption = OPTION_TYPE.RIDER.rawValue
            btnOption[1].isSelected = true
        }else if sender.tag == 3{
            self.selectedOption = OPTION_TYPE.SHOP_OWNER.rawValue
            btnOption[2].isSelected = true
        }
        
    }
    
    @IBAction func btnNextClick(_ sender: UIButton) {
        if self.selectedOption == -1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Please select any option")
        } else {
//            if isFrome == "Login" {
//                let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//                self.navigationController?.pushViewController(controller, animated: true)
//            }else{
                if self.selectedOption == 0 {
                    self.pushHomeController()
                } else if self.selectedOption == 1 {
                    let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "VehicleInformationVC") as! VehicleInformationVC
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                } else if self.selectedOption == 2 {
//                    let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "ShopOwnerSignupVC") as! ShopOwnerSignupVC
//                    self.navigationController?.pushViewController(controller, animated: true)
                    let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "SoleProprietorsCorporationsSelectionVC") as! SoleProprietorsCorporationsSelectionVC
                    self.navigationController?.pushViewController(controller, animated: true)
                }
//            }
        }
    }
    
    func pushHomeController() {
        let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.menuViewController = leftMenuVC
        appDelegate.window?.rootViewController = appDelegate.drawerController
    }
}
