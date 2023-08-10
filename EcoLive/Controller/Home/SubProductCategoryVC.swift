//
//  SubProductCategoryVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 16/06/21.
//

import UIKit
import SwiftyJSON
import SDWebImage

class SubProductCategoryVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    var objSubCategory: SubProductCategoryObject!
    var arrProductList: [ProductObject] = []
    
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
        self.lblTitle.text = self.objSubCategory.name

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
        
        self.tblView.isHidden = true
        self.lblNoRecord.isHidden = true
        
        self.callProductListAPI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateWishList), name: NSNotification.Name(rawValue: kUpdateWishList), object: nil)
    }
    
    //MARK: - HELPER -
    
    @objc func updateWishList() {
        self.callProductListAPI()
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnWishlistClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "ProductWishlistVC") as! ProductWishlistVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnCartClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.cartStoryBoard().instantiateViewController(withIdentifier: "CartVC") as! CartVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension SubProductCategoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrProductList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubProductCategoryCell", for: indexPath) as! SubProductCategoryCell
        
        let objProductDetail = self.arrProductList[indexPath.section]
        let objImages = objProductDetail.arrProductImages
        
        if objImages.count > 0 {
            cell.imgSubCategory.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgSubCategory.sd_setImage(with: URL(string: objImages[0].image), placeholderImage: UIImage.init(named: "ic_no_image"))
        } else {
            cell.imgSubCategory.image = UIImage.init(named: "ic_no_image")
        }
        
        cell.lblTitle.text = objProductDetail.name
        cell.lblDescription.text = objProductDetail.productDescription
        cell.lblStatus.text = "IN STOCK"
        cell.lblCategory.text = self.objSubCategory.name
                
        cell.lblShopLive.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop live" + " " + "$" + "\(objProductDetail.live_price)" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: cell.lblShopLive.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "(1 hour delivery service)", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize - 1)!, strSecondColor: Constants.Color.THEME_YELLOW)
        
        cell.lblShopOnline.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop online" + " " + "$" + "\(objProductDetail.online_price)" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: cell.lblShopOnline.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "(one or more days delivery service)", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize - 1)!, strSecondColor: Constants.Color.THEME_YELLOW)
        
        if objProductDetail.isfavourite == false {
            cell.btnFavourite.isSelected = false
        } else {
            cell.btnFavourite.isSelected = true
        }
        
        cell.btnFavourite.tag = indexPath.section
        cell.btnFavourite.addTarget(self, action: #selector(btnFavouriteTapped), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        controller.strProductID = self.arrProductList[indexPath.section]._id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 182.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    //CELL ACTION
    @objc func btnFavouriteTapped(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        
        if defaults.object(forKey: kAuthToken) != nil {
            let objProductDetail = self.arrProductList[sender.tag]

            if sender.isSelected == false {
                self.callAddFavouriteProductAPI(SelectedProductID: objProductDetail._id, SelectedIndex: sender.tag)
            } else {
                self.callDeleteFavouriteProductAPI(SelectedProductID: objProductDetail.isfavouriteId, SelectedIndex: sender.tag)
            }
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
}

//MARK: - API CALL -

extension SubProductCategoryVC {
    //PRODUCT LIST API
    func callProductListAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["subcategory"] = self.objSubCategory._id
        
        if defaults.object(forKey: kAuthToken) != nil {
            params["user_id"] = objUserDetail._id
        }
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.SEARCH_PRODUCT, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let data = response["data"] as? Dictionary<String, Any> {
                            if let payloadData = data["payload"] as? [Dictionary<String, Any>] {
                                strongSelf.arrProductList.removeAll()
                                for i in 0..<payloadData.count {
                                    let objProduct = ProductObject.init(payloadData[i])
                                    strongSelf.arrProductList.append(objProduct)
                                }
                                
                                if strongSelf.arrProductList.count > 0 {
                                    strongSelf.lblNoRecord.isHidden = true
                                } else {
                                    strongSelf.lblNoRecord.isHidden = false
                                }
                                strongSelf.tblView.isHidden = false
                                
                                GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)
                            }
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
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //ADD FAVOURITE PRODUCT API
    func callAddFavouriteProductAPI(SelectedProductID selectedProductID: String, SelectedIndex selectedIndex: Int) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["productId"] = selectedProductID
        params["type"] = true
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.FAVOURITE_PRODUCT, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            let objProduct = ProductObject.init(payload)
                            
                            if let row = strongSelf.arrProductList.firstIndex(where: {$0._id == selectedProductID}) {
                                strongSelf.arrProductList[row] = objProduct
                            }
                            
                            strongSelf.tblView.reloadSections(IndexSet(integer: selectedIndex), with: .none)
                            
//                            if let cell = strongSelf.tblView.cellForRow(at: IndexPath(row: 0, section: selectedIndex)) as? SubProductCategoryCell {
//                                cell.btnFavourite.isSelected = true
//                            }
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
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //DELETE FAVOURITE PRODUCT API
    func callDeleteFavouriteProductAPI(SelectedProductID selectedProductID: String, SelectedIndex selectedIndex: Int) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let strURL = Constants.URLS.FAVOURITE_PRODUCT + "/" + "\(selectedProductID)"
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestDELETEURL(strURL) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let row = strongSelf.arrProductList.firstIndex(where: {$0.isfavouriteId == selectedProductID}) {
                            strongSelf.arrProductList[row].isfavourite = false
                            strongSelf.arrProductList[row].isfavouriteId = ""
                        }
                        
                        strongSelf.tblView.reloadSections(IndexSet(integer: selectedIndex), with: .none)
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
