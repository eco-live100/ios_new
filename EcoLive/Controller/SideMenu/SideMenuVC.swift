//
//  SideMenuVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 08/06/21.
//

import UIKit
import SideMenuSwift
import SDWebImage
import DropDown

struct SideMenuOption {
    var image: UIImage
    var title: String
}

class SideMenuVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    //HEADER
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tblVW: UITableView!
    @IBOutlet weak var viewSignout: UIView!
    @IBOutlet weak var imgUserTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewSignoutBottomConstraint: NSLayoutConstraint!

    var arrOptions = [SideMenuOption]()
    var strUserSelect: String = "select user"
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.setupViewDetail()
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        DispatchQueue.main.async {
            if UIDevice.current.hasNotch {
                self.imgUserTopConstraint.constant = 40
                self.viewSignoutBottomConstraint.constant = 20
            } else {
                self.imgUserTopConstraint.constant = 25
                self.viewSignoutBottomConstraint.constant = 0
            }
                        
            if defaults.object(forKey: kAuthToken) != nil {
                self.viewSignout.isHidden = false
            } else {
                self.viewSignout.isHidden = true
            }
        }
        
        if defaults.object(forKey: kAuthToken) != nil {
            if objUserDetail.profileImage != "" {
                self.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.white
                self.imgUser.sd_setImage(with: URL(string: objUserDetail.profileImage.trim()), placeholderImage: nil)
            } else {
                self.imgUser.image = UIImage.init(named: "ic_user")
            }
            self.lblUserName.text = objUserDetail.firstName + " " + objUserDetail.lastName
        } else {
            self.imgUser.image = UIImage.init(named: "ic_user")
            self.lblUserName.text = "Guest User"
        }
        
        self.imgUser.layer.cornerRadius = self.imgUser.layer.frame.size.width / 2
        self.imgUser.clipsToBounds = true
        
        if defaults.object(forKey: kAuthToken) != nil {
            if objUserDetail.userType == "user" {
                self.arrOptions = [
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_home"), title: "Home"),
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_myorder"), title: "My Order"),
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_scan"), title: "My QRCode"),
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_account"), title: "My Account"),
                ]
            } else if objUserDetail.userType == "vendor" {
                self.arrOptions = [
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_home"), title: "Home"),
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_myorder"), title: "My Order"),
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_shop"), title: "My Shop"),
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_scan"), title: "My QRCode"),
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_account"), title: "My Account"),
                ]
            } else {
                self.arrOptions = [
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_home"), title: "Home"),
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_myorder"), title: "My Order"),
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_myorder"), title: "Current Order"),
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_scan"), title: "My QRCode"),
                    SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_account"), title: "My Account"),
                ]
            }
        } else {
            self.arrOptions = [
                SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_home"), title: "Home"),
                SideMenuOption(image: #imageLiteral(resourceName: "ic_menu_signin"), title: "Sign in"),
            ]
        }
        
        self.tblVW.register(UINib(nibName: "SidemenuCell", bundle: nil), forCellReuseIdentifier: "SidemenuCell")
        self.tblVW.register(UINib(nibName: "SidemenuSwitchUserCell", bundle: nil), forCellReuseIdentifier: "SidemenuSwitchUserCell")
        self.tblVW.reloadData()
    }
    
    //MARK: - ACTION -
    
    @IBAction func btnSignoutClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to signout?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction) in
            appDelegate.drawerController.hideMenu(animated: true, completion:nil)
            appDelegate.logoutUser()
//            self.goToHomePage()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
   
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension SideMenuVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrOptions.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == self.arrOptions.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SidemenuSwitchUserCell") as! SidemenuSwitchUserCell
            cell.strUserRole = strUserSelect
            cell.selectionStyle = .none
         
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
            cell.imgVwOption.image = self.arrOptions[indexPath.section].image
            cell.lblOption.text = self.arrOptions[indexPath.section].title
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == self.arrOptions.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SidemenuSwitchUserCell") as! SidemenuSwitchUserCell
            cell.userRoleDropDown.show()
            cell.userRoleAction = {(result) in
                self.strUserSelect = result
                self.tblVW.reloadData()
                self.goToHomePage()
            }
        } else {
            let name = self.arrOptions[indexPath.section].title
            if name == "Home" {
                self.goToHomePage()
            }
            else if name == "Sign in" {
                let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let navController = UINavigationController.init(rootViewController: controller)
                appDelegate.drawerController.contentViewController = navController
                appDelegate.drawerController.hideMenu(animated: true, completion:nil)
            }
            else if name == "My Order" {
                if objUserDetail.userType == "user" {
                    let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
                    controller.isFromAccount = false
                    let navController = UINavigationController.init(rootViewController: controller)
                    appDelegate.drawerController.contentViewController = navController
                    appDelegate.drawerController.hideMenu(animated: true, completion:nil)
                } else if objUserDetail.userType == "vendor" { //vendor
                    let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopOwnerOrderListVC") as! ShopOwnerOrderListVC
                    controller.isFromAccount = false
                    let navController = UINavigationController.init(rootViewController: controller)
                    appDelegate.drawerController.contentViewController = navController
                    appDelegate.drawerController.hideMenu(animated: true, completion:nil)
                } else {
                    let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RiderOrderHistoryVC") as! RiderOrderHistoryVC
                    controller.isFromAccount = false
                    let navController = UINavigationController.init(rootViewController: controller)
                    appDelegate.drawerController.contentViewController = navController
                    appDelegate.drawerController.hideMenu(animated: true, completion:nil)
                }
            }
            else if name == "Current Order" {
                let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RiderCurrentOrderVC") as! RiderCurrentOrderVC
                controller.isFromSideMenu = true
                let navController = UINavigationController.init(rootViewController: controller)
                appDelegate.drawerController.contentViewController = navController
                appDelegate.drawerController.hideMenu(animated: true, completion:nil)
            }
            else if name == "My Shop" {
                let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopListVC") as! ShopListVC
                let navController = UINavigationController.init(rootViewController: controller)
                appDelegate.drawerController.contentViewController = navController
                appDelegate.drawerController.hideMenu(animated: true, completion:nil)
            }
            else if name == "My QRCode" {
                let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "MyQRCodeVC") as! MyQRCodeVC
                let navController = UINavigationController.init(rootViewController: controller)
                appDelegate.drawerController.contentViewController = navController
                appDelegate.drawerController.hideMenu(animated: true, completion:nil)
            }
            else if name == "My Account" {
                let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountVC
                let navController = UINavigationController.init(rootViewController: controller)
                appDelegate.drawerController.contentViewController = navController
                appDelegate.drawerController.hideMenu(animated: true, completion:nil)
            }
        }
        
   
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == self.arrOptions.count{
            return 160
        }else{
            return UITableView.automaticDimension
        }
    }
}

extension SideMenuVC {
    func goToHomePage(){
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.hideMenu(animated: true, completion:nil)
    }
}
