//
//  NearByProductListVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 06/12/21.
//

import UIKit
import SwiftyJSON
import SDWebImage
import CoreLocation

class NearByProductListVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    var userLocation: CLLocationCoordinate2D!
    var selectedLocation: CLLocationCoordinate2D!
    var selectedShopCategory = ""
    
    var arrNearProduct: [NearByProductObject] = []
    
    private var OFFSET: Int = 0
    private var PAGING_LIMIT: Int = 20
    private var requestState: REQUEST = .notStarted

    var arrSubProductCategory: [NSDictionary] = []

    
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
        
        self.callGetNearByProductAPI()
        self.callProductCategoryListAPI()
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - PAGINATION METHOD -
    
    private func nextPageForProductListIfNeeded(at indexPath: IndexPath) {
        if self.arrNearProduct.count >= 20 {
            if indexPath.section == (self.arrNearProduct.count - 1) {
                if self.requestState != REQUEST.failedORNoMoreData {
                    self.OFFSET = self.OFFSET + 1
                    self.PAGING_LIMIT = 20
                    //self.callGetNearByProductAPI()
                }
            }
        }
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension NearByProductListVC: UITableViewDataSource, UITableViewDelegate {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.arrSubProductCategory.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.lblNoRecord.isHidden = true
        return self.arrSubProductCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearByProductCell", for: indexPath) as! NearByProductCell

        let objDict = self.arrSubProductCategory[indexPath.row]
        let image = (((objDict["file"] as! NSArray)[0] as! NSDictionary)["name"] as? String ?? "")
        let productData = (objDict["productData"] as! NSDictionary)

        cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgProduct.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: "ic_no_image"))
        //
        cell.lblProductTitle.text = productData["productName"] as? String ?? ""
                    cell.lblFreeShipping.text = "Free shipping"
        //
        cell.lblShopLive.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop live" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "$\(productData["priceLive"] as? String ?? "")", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize)!, strSecondColor: Constants.Color.THEME_YELLOW)
        cell.lblShopOnline.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop online" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "$\(productData["price"] as? String ?? "")", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize)!, strSecondColor: UIColor.init(hex: 0xFF0000))

        return cell
//        let objDict = self.arrNearProduct[indexPath.section]
//        
//        cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
//        cell.imgProduct.sd_setImage(with: URL(string: objDict.product_image), placeholderImage: UIImage.init(named: "ic_no_image"))
//        
//        cell.lblProductTitle.text = objDict.product_name
//        cell.lblFreeShipping.text = "Free shipping"
//
//        cell.lblShopLive.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop live" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "$\(objDict.product_live_price)", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize)!, strSecondColor: Constants.Color.THEME_YELLOW)
//        cell.lblShopOnline.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop online" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "$\(objDict.product_online_price)", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize)!, strSecondColor: UIColor.init(hex: 0xFF0000))
        
        self.nextPageForProductListIfNeeded(at: indexPath)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        let objDict = self.arrSubProductCategory[indexPath.row]
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        controller.strProductID = objDict["_id"] as? String ?? ""//objDict.product_id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - API CALL -

extension NearByProductListVC {
    //GET NEAR BY PRODUCT
    func callGetNearByProductAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var strLattitude = ""
        var strLongitude = ""
        
        if self.selectedLocation == nil {
            strLattitude = String(GlobalUserCurrent.location.coordinate.latitude ?? 0.0) //String(format: "%.7f", place.coordinate.latitude)
            strLongitude = String(GlobalUserCurrent.location.coordinate.longitude ?? 0.0) //String(format: "%.7f", place.coordinate.longitude)
        } else {
            strLattitude = String(self.selectedLocation.latitude) //String(format: "%.7f", place.coordinate.latitude)
            strLongitude = String(self.selectedLocation.longitude) //String(format: "%.7f", place.coordinate.longitude)
        }
            
        var params: [String:Any] = [:]
        params["latitude"] = strLattitude
        params["longitude"] = strLongitude
        params["category"] = self.selectedShopCategory
        params["offset"] = self.OFFSET
        params["limit"] = self.PAGING_LIMIT
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.NEARBY_PRODUCT, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let data = response["data"] as? Dictionary<String, Any> {
                            if let payloadData = data["payload"] as? [Dictionary<String, Any>] {
                                
                                strongSelf.requestState = REQUEST.notStarted
                                
                                if strongSelf.OFFSET == 0 {
                                    strongSelf.arrNearProduct.removeAll()
                                }
                                
                                for i in 0..<payloadData.count {
                                    let objOrder = NearByProductObject.init(payloadData[i])
                                    strongSelf.arrNearProduct.append(objOrder)
                                }
                                
                                if strongSelf.PAGING_LIMIT >= 20 {
                                    if payloadData.count < strongSelf.PAGING_LIMIT {
                                        strongSelf.requestState = REQUEST.failedORNoMoreData
                                    }
                                }
                                
                                if strongSelf.arrNearProduct.count > 0 {
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
                        strongSelf.requestState = REQUEST.failedORNoMoreData
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        strongSelf.requestState = REQUEST.failedORNoMoreData
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                    }
                }
            }
        }) { (error) in
            self.requestState = REQUEST.failedORNoMoreData
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }


    func callProductCategoryListAPI() {

        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.VENDOR_SHOP_ADDED_LIST, parameters: [:]) { responce in
            GlobalData.shared.hideProgress()
            self.arrSubProductCategory = []
            switch responce {
            case .success(let jsondata):
                let isSuccess:Int = jsondata["statusCode"] as! Int
                if(isSuccess == 200){

                    if let payloadData = jsondata["data"] as? NSDictionary {
                        if let docsArray = payloadData["docs"] as? NSArray {
                            self.arrSubProductCategory = docsArray as! [NSDictionary]
                        }

                        self.tblView.reloadData()
                        self.lblNoRecord.isHidden = true

//                        GlobalData.shared.reloadCollectionView(collectionView: self.tblView)

                        //                        if self.arrSubProductCategory.count > 0 {
                        //                            self.labelNoDataFound.isHidden = true
                        //                        }else{
                        //                            self.labelNoDataFound.isHidden = false
                        //                        }
                    }

                }

            case .failed(let errorMessage):
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            }
        }
    }
}
