//
//  ShopListVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 20/07/21.
//

import UIKit
import SideMenuSwift
import SwiftyJSON
import SDWebImage

class ShopListVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    var arrShopCategory: [ShopCategoryObject] = []
    var arrShopList: [ShopObject] = []
    
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
        self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
        }
        
        self.tblView.showsVerticalScrollIndicator = false
        self.tblView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: 1))
        
        //FETCH SHOP CATEGORY DATA
        if let data = defaults.value(forKey: configurationData) as? Data,
            let configData = try? JSONDecoder().decode(UtilityObject.self, from: data) {
            GlobalData.shared.objConfiguration = configData
            
            self.arrShopCategory = GlobalData.shared.objConfiguration.arrShopCategory
        }
        
        self.callShopListAPI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateShopList), name: NSNotification.Name(rawValue: kUpdateShopList), object: nil)
    }
    
    //MARK: - HELPER -
    
    @objc func updateShopList() {
        self.callShopListAPI()
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension ShopListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrShopList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as! ShopCell
        
        let objShop = self.arrShopList[indexPath.section]
        let objShopCategory = self.arrShopCategory.filter{ $0._id == objShop.category}.first

        cell.imgShop.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgShop.sd_setImage(with: URL(string: objShop.image), placeholderImage: UIImage.init(named: "ic_no_image"))
        cell.lblShopName.text = objShop.shopName
        cell.lblShopType.text = objShopCategory?.name
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let objShop = self.arrShopList[indexPath.section]
        
        let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopDetailVC") as! ShopDetailVC
        controller.isFromShopList = true
        controller.strShopID = objShop._id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - API CALL -

extension ShopListVC {
    
    func callShopListAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestGETURL(Constants.URLS.GET_SHOP) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            strongSelf.arrShopList.removeAll()
                            for i in 0..<payloadData.count {
                                let objShop = ShopObject.init(payloadData[i])
                                strongSelf.arrShopList.append(objShop)
                            }
                            
                            GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                    }
                }
            }
        } failure: { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
}
