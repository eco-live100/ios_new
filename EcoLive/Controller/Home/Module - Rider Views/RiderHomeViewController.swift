//
//  RiderHomeViewController.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 20/06/22.
//

import UIKit

class RiderHomeViewController: BaseVC {
    
    static func getObject()-> RiderHomeViewController {
        let storyboard = UIStoryboard(name: "Rider", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RiderHomeViewController") as? RiderHomeViewController
        if let vc = vc {
            return vc
        }
        return RiderHomeViewController()
    }
    
    //MARK: - PROPERTIES & OUTLETS
    @IBOutlet weak var viewBottem: UIView!
    @IBOutlet weak var viewInfoRider: UIView!
    @IBOutlet weak var tableRiderOrders:UITableView!
    
    //MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBottem.roundCorners(corners: [.topLeft, .topRight], radius: 50.0)
        self.viewInfoRider.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        self.setupTableView()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func setupTableView() {
        self.tableRiderOrders.register(UINib(nibName: "RidersOrdersTableCell", bundle: nil), forCellReuseIdentifier: "RidersOrdersTableCell")
        self.tableRiderOrders.reloadData()
    }
    
    //MARK: - ACTIONS
    @IBAction func btnMenuClick(_ sender: UIButton) {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func actionCheckDemandClick(_ sender: UIButton) {
        let controller = RiderDemandViewController.getObject()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func actionUserClick(_ sender: UIButton) {
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.hideMenu(animated: true, completion:nil)
    }
    
    @IBAction func actionShopOwner(_ sender: UIButton){
        if defaults.object(forKey: kAuthToken) != nil {
            if (objUserDetail.isVendor) {
                if objUserDetail.isVendorVerified == true{
                    let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopDetailVC") as! ShopDetailVC
                    self.push(controller: controller)
                } else {
                        let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopListInfoViewController") as! ShopListInfoViewController
                        self.push(controller: controller)
                }
            } else {
                let controller = SoleProprietorsCorporationsSelectionVC.getObject()
                self.push(controller: controller)
            }
            
            
        } else {
                let controller = LoginVC.getObject()
                let navController = UINavigationController.init(rootViewController: controller)
                appDelegate.drawerController.contentViewController = navController
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
