//
//  SelectMoneyTypes.swift
//  EcoLive
//
//  Created by  on 22/10/22.
//

import UIKit
import DLRadioButton

class SelectMoneyTypes: BaseVC {

    static func getObject()-> SelectMoneyTypes {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectMoneyTypes") as? SelectMoneyTypes
        if let vc = vc {
            return vc
        }
        return SelectMoneyTypes()
    }

    //MARK: - PROPERTIES & OUTLETS -
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet var viewBorder: [UIView]!
    @IBOutlet var labelTitle: [UILabel]!
    @IBOutlet var btnOption: [DLRadioButton]!
    @IBOutlet var btnTitlesName: [UIButton]!
    @IBOutlet weak var btnNext: UIButton!

    @IBOutlet weak var viewContentPoup: UIView!


    enum OPTION_TYPE : Int {
        case ELWallet                = 0
        case payBillResturent        = 1
        case SendTOFriend            = 2
        case SendToPaymetReq         = 3
        case MakePaymentToOrg        = 4
        case LocalInternationPayment = 5
    }

    struct Item {
        var name : String
        var isSelect : Bool
        var bgColor = UIColor.white
        var type = "normal"
        var optionType : OPTION_TYPE
    }

    var allButtonsName : [Item] = []
    //["Add money to my wallet","Pay Bill in resturent / business","Send Money to Friend","Send Payment Requests","Make payment to Organizations","Local/International Money transfer"]

    var selectedOption:Int = -1
    var isFrome = "Login"


    //MARK: - VIEWCONTROLLER LIFE CYCLE -

    override func viewDidLoad() {
        super.viewDidLoad()
        allButtonsName = [Item(name: "Add money to my wallet", isSelect:true, bgColor: Constants.Color.THEME_YELLOW,optionType: .ELWallet),
                          Item(name: "Pay Bill in resturent / business", isSelect: false, bgColor: Constants.Color.THEME_YELLOW, optionType: .payBillResturent),
                          Item(name: "Send Money to Friend", isSelect: false, bgColor: Constants.Color.THEME_YELLOW, optionType: .SendTOFriend),
                          Item(name: "Send Payment Requests", isSelect: false, bgColor: Constants.Color.THEME_YELLOW, optionType: .SendToPaymetReq),
                          Item(name: "Make payment to Organizations", isSelect: false, bgColor: Constants.Color.NAV_TEXT_COLOR, optionType: .MakePaymentToOrg),
                          Item(name: "Local/International Money transfer", isSelect: false, bgColor: Constants.Color.NAV_TEXT_COLOR, optionType: .LocalInternationPayment),
        ]
        self.setupViewDetail()
        viewContentPoup.isHidden = true

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    @IBAction func btnHidePoupAction(_ sender: UIButton) {
        viewContentPoup.isHidden = true
    }

    @IBAction func btnsPoupAction(_ sender: UIButton) {
        if sender.tag == 0 {
            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "SendMoneyFirstStepVC") as! SendMoneyFirstStepVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if sender.tag == 1 {
            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "FriendListEcolive") as! FriendListEcolive
            controller.titleVC = "Select Recipients"
            self.navigationController?.pushViewController(controller, animated: true)
        }
        viewContentPoup.isHidden = true
    }
    
    //MARK: - SETUP VIEW -

    func setupViewDetail() {

        self.viewContent.roundCorners(corners: [.topLeft, .topRight], radius: 30)

        for i in 0 ..< btnTitlesName.count {
            labelTitle[i].text = allButtonsName[i].name
            labelTitle[i].numberOfLines = 0
            btnTitlesName[i].tag = i
            btnOption[i].isMultipleSelectionEnabled = false
            btnTitlesName[i].tag = i
        }

        btnOption[0].isSelected = true

        DispatchQueue.main.async {

            for i in self.viewBorder {
                i.createButtonShadow()
            }
//            self.viewUser.createButtonShadow()
//            self.viewRider.createButtonShadow()
//            self.viewShopOwner.createButtonShadow()

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




//        if radioButton.accessibilityIdentifier ?? "" ==  "User" {
//            self.selectedOption = OPTION_TYPE.USER.rawValue
//        } else if radioButton.accessibilityIdentifier ?? "" ==  "Rider" {
//            self.selectedOption = OPTION_TYPE.RIDER.rawValue
//        } else if radioButton.accessibilityIdentifier ?? "" ==  "ShopOwner" {
//            self.selectedOption = OPTION_TYPE.SHOP_OWNER.rawValue
//        }
        //debugPrint("SELECTED OPTION:- \(self.selectedOption)")
    }

    @IBAction func btnSwitchType(_ sender: UIButton) {

        print(sender.tag)
        for i in 0 ..< btnOption.count{
            btnOption[i].isSelected = false
        }

        btnOption[sender.tag].isSelected = true

//        btnOption[0].isSelected = true



//        if sender.tag == 1 {
//            self.selectedOption = OPTION_TYPE.USER.rawValue
//            btnOption[0].isSelected = true
//        } else if sender.tag == 2{
//            self.selectedOption = OPTION_TYPE.RIDER.rawValue
//            btnOption[1].isSelected = true
//        }else if sender.tag == 3{
//            self.selectedOption = OPTION_TYPE.SHOP_OWNER.rawValue
//            btnOption[2].isSelected = true
//        }

    }

    @IBAction func btnNextClick(_ sender: UIButton) {

        let selctItem = (btnOption.filter({ $0.isSelected == true }).first!)
        switch selctItem.tag {
        case 0:
            let controller = GlobalData.addMoneyStoryBoard().instantiateViewController(withIdentifier: "AddMoneyVC") as! AddMoneyVC
            controller.isFromCartPayment = false
            self.navigationController?.pushViewController(controller, animated: true)
        case 1:
            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "PayResturentAndBusiness") as! PayResturentAndBusiness
//            self.navigationController?.pushViewController(controller, animated: true)
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: true, completion: nil)

        case 2:
            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "FriendListEcolive") as! FriendListEcolive
            self.navigationController?.pushViewController(controller, animated: true)
        case 3:
            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "SendPaymentReqInvoiceVC") as! SendPaymentReqInvoiceVC
            self.navigationController?.pushViewController(controller, animated: true)
        case 4:
            viewContentPoup.isHidden = false
        case 5:
            print("")
            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "SendMoneyToContactVC") as! SendMoneyToContactVC
//            controller.isFromQRScan = true
//            controller.objQRCodeUserDetail = object
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            print("")
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
