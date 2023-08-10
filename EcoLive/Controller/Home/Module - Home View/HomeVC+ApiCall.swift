//
//  HomeVC+ApiCall.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 16/06/22.
//

import Foundation
import UIKit
import SwiftyJSON

extension HomeVC {
    //MARK: - API CALL 
    
    //SHOP CATEGORY
    func callGetShopCategoryAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        AFWrapper.shared.requestGETURL(Constants.URLS.SHOP_CATEGORY) { (JSONResponse) in
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                                   if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            self.arrShopCategory.removeAll()
                            for i in 0..<payloadData.count {
                                let objCat = ShopCategoryObject.init(payloadData[i])
                                self.arrShopCategory.append(objCat)
                            }
                                           if self.arrShopCategory.count > 0 {
                                self.setupCategoryDropDown()
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
        } failure: { (error) in
           // GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //GET VEHICLE INFORMATION
    func callGetVehicleInfoAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["user_id"] = objUserDetail._id
           AFWrapper.shared.requestPOSTURL(Constants.URLS.VEHICLE_INFORMATION, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
                       if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                                                           if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            for i in 0..<payloadData.count {
                                let objVehicle = VehicleObject.init(payloadData[i])
                                strongSelf.arrVehicleList.append(objVehicle)
                            }
                                           strongSelf.callUpdateRiderLocationAPI()
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
            //GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //UPDATE RIDER LOCATION
    func callUpdateRiderLocationAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var vehicleID: String = ""
        var vehicleName: String = ""
        var vehicleCategory: String = ""
        
        if self.arrVehicleList.count > 0 {
            let objFirstData = self.arrVehicleList[0]
            vehicleID = objFirstData._id
            vehicleName = objFirstData.vehicalName
            vehicleCategory = objFirstData.category
        }
        
        let strLattitude = String(self.userLocation.latitude) //String(format: "%.7f", place.coordinate.latitude)
        let strLongitude = String(self.userLocation.longitude) //String(format: "%.7f", place.coordinate.longitude)
        
        let strURL = Constants.URLS.VEHICLE_INFORMATION + "/" + "\(vehicleID)"
        
        var params: [String:Any] = [:]
        params["vehicalName"] = vehicleName
        params["category"] = vehicleCategory
        params["latitude"] = strLattitude
        params["longitude"] = strLongitude
        
        AFWrapper.shared.requestPOSTURL(strURL, params: params, headers: nil, success: { (JSONResponse) -> Void in
                       if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        debugPrint("Rider Location update")
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
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //GET NEAR BY PRODUCT
    func callGetNearByProductAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var strLattitude = ""
        var strLongitude = ""
        
        if self.selectedLocation == nil {
            strLattitude = String(self.userLocation.latitude) //String(format: "%.7f", place.coordinate.latitude)
            strLongitude = String(self.userLocation.longitude) //String(format: "%.7f", place.coordinate.longitude)
        } else {
            strLattitude = String(self.selectedLocation.latitude) //String(format: "%.7f", place.coordinate.latitude)
            strLongitude = String(self.selectedLocation.longitude) //String(format: "%.7f", place.coordinate.longitude)
        }
            
        var params: [String:Any] = [:]
        params["latitude"] = strLattitude
        params["longitude"] = strLongitude
        params["category"] = self.selectedShopCategory
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.NEARBY_PRODUCT, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let data = response["data"] as? Dictionary<String, Any> {
                            if let payloadData = data["payload"] as? [Dictionary<String, Any>] {
                                strongSelf.arrNearProduct.removeAll()
                                for i in 0..<payloadData.count {
                                    let objOrder = NearByProductObject.init(payloadData[i])
                                    strongSelf.arrNearProduct.append(objOrder)
                                                           if strongSelf.arrNearProduct.count >= 10 {
                                        break
                                    }
                                }
                                                   if strongSelf.arrNearProduct.count > 0 {
                                    strongSelf.lblNoNearProduct.isHidden = true
                                } else {
                                    //strongSelf.lblNoNearProduct.isHidden = false
                                }
//                                strongSelf.clView.isHidden = false
                                                   if strongSelf.arrNearProduct.count < 6 {
//                                    strongSelf.clViewHeightConstraint.constant = 300//230
                                } else {
//                                    strongSelf.clViewHeightConstraint.constant = 300//468
                                }
                                                   GlobalData.shared.reloadCollectionView(collectionView: strongSelf.clView)
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
//            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //GET NEAR RIDER
    func callGetNearRiderAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let strLattitude = String(self.userLocation.latitude) //String(format: "%.7f", place.coordinate.latitude)
        let strLongitude = String(self.userLocation.longitude) //String(format: "%.7f", place.coordinate.longitude)
        
        var params: [String:Any] = [:]
        params["latitude"] = strLattitude
        params["longitude"] = strLongitude
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.NEAR_RIDER, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let data = response["data"] as? Dictionary<String, Any> {
                            if let payloadData = data["payload"] as? [Dictionary<String, Any>] {
                                strongSelf.arrNearRider.removeAll()
                                for i in 0..<payloadData.count {
                                    let objRider = NearRiderObject.init(payloadData[i])
                                    strongSelf.arrNearRider.append(objRider)
                                }
                                                   strongSelf.showCurrentLocationOnMap()

                                if defaults.object(forKey: kAuthToken) != nil {
                                    strongSelf.callRiderCurrentOrderAPI()
                                }
                   //                                GlobalData.shared.deliveryJob = strongSelf.arrNearRider.count
//
//                                strongSelf.lblDeliveryJob.text = "Delivery Jobs \(GlobalData.shared.deliveryJob)"
//
//                                if objUserDetail.userType == "rider" {
//                                    if GlobalData.shared.deliveryJob > 0 {
//                                        strongSelf.viewDeliveryJob.isHidden = false
//                                    } else {
//                                        strongSelf.viewDeliveryJob.isHidden = true
//                                    }
//                                } else {
//                                    strongSelf.viewDeliveryJob.isHidden = true
//                                }
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
//            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //RIDER CURRENT ORDER LIST
    func callRiderCurrentOrderAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["user_id"] = objUserDetail._id
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callService(url: NetworkManager.API_URL + Constants.URLS.RIDER_ORDER, parameters: params) { JSONResponse in
            GlobalData.shared.hideProgress()
            
            switch  JSONResponse {
            case .success(let jsondata):
                print(jsondata)
                if let response = jsondata as? [String : Any] {
                    if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                        var arrCart: [CartObject] = []
                        for i in 0..<payloadData.count {
                            let objCart = CartObject.init(payloadData[i])
                            arrCart.append(objCart)
                        }
                        GlobalData.shared.arrCartList = arrCart
                    }
                }
            case .failed(let errorMessage):
                print(errorMessage)
//                switch errorMessage {
//                default:
//                    self.handleDefaultResponse(errorMessage: errorMessage)
//                    break
//                }
            }

        }

        
//        AFWrapper.shared.requestPOSTURL(Constants.URLS.RIDER_ORDER, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
//            guard let strongSelf = self else { return }
//
//            GlobalData.shared.hideProgress()
//            switch  JSONResponse {
//            case .success(let jsondata):
//                print(jsondata)
//                if let response = jsondata as? [String : Any] {
//                    if response["status"] as? Int ?? 0 == successCode {
//
//                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
//                            var arrCart: [CartObject] = []
//                            for i in 0..<payloadData.count {
//                                let objCart = CartObject.init(payloadData[i])
//                                arrCart.append(objCart)
//                            }
//
//                            GlobalData.shared.arrCartList = arrCart
//                        }
//                    }
//                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
//                        //                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
//                    }
//                    else {
//                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
//                    }
//                }
//            case .failed(let errorMessage):
//
//                switch errorMessage {
//                default:
//                    GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
//                    break
//                }
//            }
//
//
//            if JSONResponse != JSON.null {
//                if let response = JSONResponse.rawValue as? [String : Any] {
//                    if response["status"] as? Int ?? 0 == successCode {
//
//                        if let data = response["data"] as? Dictionary<String, Any> {
//
//                            if let payloadData = data["payload"] as? [Dictionary<String, Any>] {
//                                var arrCurrentOrder: [RiderOrderObject] = []
//                                for i in 0..<payloadData.count {
//                                    let objProduct = RiderOrderObject.init(payloadData[i])
//                                    if objProduct.status == "Open" {
//                                        arrCurrentOrder.append(objProduct)
//                                    }
//                                }
//
//                                GlobalData.shared.deliveryJob = arrCurrentOrder.count
//
//                                strongSelf.lblDeliveryJob.text = "Delivery Jobs \(GlobalData.shared.deliveryJob)"
//
//                                if objUserDetail.userType == "rider" {
////                                    if GlobalData.shared.deliveryJob > 0 {
//                                        strongSelf.viewDeliveryJob.isHidden = false
////                                    } else {
////                                        strongSelf.viewDeliveryJob.isHidden = true
////                                    }
//                                } else {
//                                    strongSelf.viewDeliveryJob.isHidden = true
//                                }
//                            }
//                        }
//                    }
//                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
//                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
//                    }
//                    else {
//                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
//                    }
//                }
//            }
//        }) { (error) in
//            GlobalData.shared.hideProgress()
//            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
//        }
    }
    
    //GET CART LIST
    func callCartListAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callServiceGetMethod(url: Constants.URLS.CART) { JSONResponse in
            
//        AFWrapper.shared.requestGETURL(Constants.URLS.CART) { (JSONResponse) in
            
            GlobalData.shared.hideProgress()

            switch  JSONResponse {
            case .success(let jsondata):
                print(jsondata)
                if let response = jsondata as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                                   if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            var arrCart: [CartObject] = []
                            for i in 0..<payloadData.count {
                                let objCart = CartObject.init(payloadData[i])
                                arrCart.append(objCart)
                            }
                                           GlobalData.shared.arrCartList = arrCart
                        }
                    }
//                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
//                        //                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
//                    }
//                    else {
//                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
//                    }
//                    self.handleDefaultResponse(errorMessage: (response["message"] as? String ?? ""))
                    GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
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
    
    //PRODUCT CATEGORY LIST
    func callProductCategoryAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        AFWrapper.shared.requestGETURL(Constants.URLS.GET_PRODUCT_CATEGORY) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                                   if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            for i in 0..<payloadData.count {
                                let objProduct = ProductCategoryObject.init(payloadData[i])
                                strongSelf.arrProductCategory.append(objProduct)
                            }
                                           GlobalData.shared.reloadCollectionView(collectionView: strongSelf.clViewCategory)
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
//                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                    }
                }
            }
        } failure: { (error) in
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //QRCODE USER DETAIL
    func callQRCodeUserDetail(QRCodeValue qrCodeValue: String) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["email"] = qrCodeValue
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.PROFILE_BY_EMAIL, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            let object: UserDetail = UserDetail.initWith(dict: payload.removeNull())
                                           let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "SendMoneyToContactVC") as! SendMoneyToContactVC
                            controller.isFromQRScan = true
                            controller.objQRCodeUserDetail = object
                            strongSelf.navigationController?.pushViewController(controller, animated: true)
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
    // GET USER DETAILS
    
    func getProfileDetails() {
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.GET_PROFILE_DETAILS, parameters: [:]) { responceget in
            print(responceget)
            
//            let strongSelf = self
            GlobalData.shared.hideProgress()
            switch responceget {
            case .success(let response):
                
                if let getData = response["data"] as? NSDictionary {
                    let userDetail = response["data"] as! Dictionary<String, Any>
                    let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
                    
                    if let data = try? JSONEncoder().encode(object) {
//                        let useremailverify =  userDetail["checkEmailVerified"] as! Dictionary<String, Any>
//                        let email = useremailverify["emailVerified"]
//                        print(email!)
//                        objUserDetail.isEmailVerified = (email != nil)
                        defaults.set(data, forKey: kLoggedInUserData)
                        defaults.synchronize()
                        objUserDetail = object
                        self.setUpUserRoleButton()
                    }
                }else{
                    if let message = response["validationError"] as? NSDictionary {
                        GlobalData.shared.showDarkStyleToastMesage(message: message.getApiErrorMessage())
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

                        GlobalData.shared.reloadCollectionView(collectionView: self.clView)

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
