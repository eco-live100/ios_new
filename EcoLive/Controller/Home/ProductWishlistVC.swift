//
//  ProductWishlistVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 06/07/21.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ProductWishlistVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    var arrProductList: [FavouriteProductObject] = []
    
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
        
        self.tblView.isHidden = true
        self.lblNoRecord.isHidden = true
        
        self.callFavouriteProductListAPI()
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension ProductWishlistVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrProductList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishlistCell", for: indexPath) as! WishlistCell
        
        let objProductDetail = self.arrProductList[indexPath.section]
        let objImages = objProductDetail.arrProductImages
        
        if objImages.count > 0 {
            cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProduct.sd_setImage(with: URL(string: objImages[0].name), placeholderImage: UIImage.init(named: "ic_no_image"))
        } else {
            cell.imgProduct.image = UIImage.init(named: "ic_no_image")
        }
        
        cell.lblTitle.text = objProductDetail.name
        cell.lblDescription.text = objProductDetail.productDescription
        
        cell.lblShopLive.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop live" + " " + "$" + "\(objProductDetail.live_price)" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: cell.lblShopLive.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "(1 hour delivery service)", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize - 1)!, strSecondColor: Constants.Color.THEME_YELLOW)
        
        cell.lblShopOnline.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop online" + " " + "$" + "\(objProductDetail.online_price)" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: cell.lblShopOnline.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "(one or more days delivery service)", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize - 1)!, strSecondColor: Constants.Color.THEME_YELLOW)
        
        cell.btnDelete.tag = indexPath.section
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteClick), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        controller.strProductID = self.arrProductList[indexPath.section].productId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145.0
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
    @objc func btnDeleteClick(_ sender: UIButton) {
        let objProductDetail = self.arrProductList[sender.tag]
        
        GlobalData.shared.displayConfirmationAlert(self, title: "Delete Product", message: "Would you like to delete this product from favourite?", btnTitle1: "Cancel", btnTitle2: "Delete", actionBlock: { (isConfirmed) in
            if isConfirmed {
                self.callDeleteFavouriteProductAPI(SelectedProductID: objProductDetail._id)
            }
        })
    }
}

//MARK: - API CALL -

extension ProductWishlistVC {
    //FAVOURITE PRODUCT LIST API
    func callFavouriteProductListAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let params: [String:Any] = [:]
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestGETURL(Constants.URLS.FAVOURITE_PRODUCT_LIST, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            strongSelf.arrProductList = []
            GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
//                    if response["status"] as? Int ?? 0 == successCode {
                        
//                        if let data = response["data"] as? Dictionary<String, Any> {
                            
                            if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                                
                                for i in 0..<payloadData.count {
                                    if (((payloadData[i] as? NSDictionary)?["liked"] as? Bool ?? false) == true) {
                                        let objProduct = FavouriteProductObject.init(payloadData[i])
                                        strongSelf.arrProductList.append(objProduct)
                                    }
                                }

                                if strongSelf.arrProductList.count > 0 {
                                    strongSelf.lblNoRecord.isHidden = true
                                } else {
                                    strongSelf.lblNoRecord.isHidden = false
                                }
                                strongSelf.tblView.isHidden = false
                                
                                GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)
                            }
                     //   }
//                    }
//                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
//                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
//                    }
//                    else {
//                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
//                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //DELETE FAVOURITE PRODUCT API
    func callDeleteFavouriteProductAPI(SelectedProductID selectedProductID: String) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["productId"] = selectedProductID//self.objProductDetail._id
        params["type"] = false
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        AFWrapper.shared.requestPOSTURL(Constants.URLS.FAVOURITE_PRODUCT, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }

            GlobalData.shared.hideProgress()

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {

                    self?.callFavouriteProductListAPI()
                    NotificationCenter.default.post(name: Notification.Name(kUpdateWishList), object: nil)

                    if response["status"] as? Int ?? 0 == successCode {

//                        if let payload = response["data"] as? Dictionary<String, Any> {
////                            strongSelf.objProductDetail = ProductObject.init(payload)
//
////                            if strongSelf.objProductDetail.isfavourite == false {
////                                strongSelf.btnFavourite.isSelected = false
////                            } else {
////                                strongSelf.btnFavourite.isSelected = true
////                            }
//
////                            NotificationCenter.default.post(name: Notification.Name(kUpdateWishList), object: nil)
//
//
//                        }
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

        
        
//        AFWrapper.shared.requestDELETEURL(strURL) { [weak self] (JSONResponse) in
//            guard let strongSelf = self else { return }
//
//            GlobalData.shared.hideProgress()
//
//            if JSONResponse != JSON.null {
//                if let response = JSONResponse.rawValue as? [String : Any] {
//                    if response["status"] as? Int ?? 0 == successCode {
//                        if let row = strongSelf.arrProductList.firstIndex(where: {$0._id == selectedProductID}) {
//                            strongSelf.arrProductList.remove(at: row)
//                        }
//
//                        if strongSelf.arrProductList.count > 0 {
//                            strongSelf.lblNoRecord.isHidden = true
//                        } else {
//                            strongSelf.lblNoRecord.isHidden = false
//                        }
//                        strongSelf.tblView.isHidden = false
//
//                        NotificationCenter.default.post(name: Notification.Name(kUpdateWishList), object: nil)
//
//                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
//                        GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)
//                    }
//                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
//                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
//                    }
//                    else {
//                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
//                    }
//                }
//            }
//        } failure: { (error) in
//            GlobalData.shared.hideProgress()
//            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
//        }
    }
}
