//
//  MySaveAddress.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 07/06/22.
//

import UIKit
import SwiftyJSON


class MySaveAddress: BaseVC {
    
    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddmoreAddress: UIButton!
    
    var addressList = NSArray()

    var onSelectAddress : ((NSDictionary?) -> Void)?
    var isFromeSelectAddress = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }

    override func viewWillAppear(_ animated: Bool) {
        getAddress()
    }
    
    func initData() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        DispatchQueue.main.async {
        
            self.btnAddmoreAddress.layer.cornerRadius = (self.btnAddmoreAddress.layer.frame.size.height / 2)
            self.btnAddmoreAddress.clipsToBounds = true
            self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
            
        }
        
    }
    
    // MARK: - ACTIONS -
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func btnNewAddressClick(_ sender: UIButton) {
        
        let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "MyAddressVC") as! MyAddressVC
//        controller.arrAddress = self.arrAddress
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnDeleteAddress(_ sender: UIButton) {
        if let indexPath = self.tableView.indexPathForView(sender) {
            print("Button tapped at indexPath \(indexPath)")

            deleteAddress(id: (addressList[indexPath.row] as! NSDictionary)["_id"] as? String ?? "")
        }
    }
}

extension MySaveAddress: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaveAddressViewCell", for: indexPath) as! SaveAddressViewCell
        cell.selectionStyle = .none
        cell.lblTitle.text = (addressList[indexPath.row] as! NSDictionary)["addressType"] as? String ?? ""
        let name = (addressList[indexPath.row] as! NSDictionary)["fullName"] as? String ?? ""
        let mobile = (addressList[indexPath.row] as! NSDictionary)["mobile"] as? String ?? ""
        let title = (addressList[indexPath.row] as! NSDictionary)["title"] as? String ?? ""
        cell.lblSubTitle.text = name + "\n" + mobile + "\n" + title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ((Constants.ScreenSize.SCREEN_HEIGHT * 0.06))
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromeSelectAddress {
            if let cb = onSelectAddress {
                cb((addressList[indexPath.row] as! NSDictionary))
            }
            self.btnBackClick(UIButton())
        }
    }


    
}

//MARK: - API CALL -

extension MySaveAddress {
    func getAddress() {

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        NetworkManager.callServiceGetMethod(url: NetworkManager.New_API_DIR + Constants.URLS.GET_ADDRESS_New) { responceget in
            print(responceget)

            //            let strongSelf = self
            GlobalData.shared.hideProgress()
            switch responceget {
            case .success(let response):

                if let getData = response["data"] as? NSArray {

                    self.addressList = getData
                    self.tableView.reloadData()
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
//        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.GET_ADDRESS_New, parameters: [:],httpMethod: .get) { responceget in
//            print(responceget)
//
//            //            let strongSelf = self
//            GlobalData.shared.hideProgress()
//            switch responceget {
//            case .success(let response):
//
//                if let getData = response["data"] as? NSDictionary {
////                    let userDetail = response["data"] as! Dictionary<String, Any>
////                    let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
//
////                    if let data = try? JSONEncoder().encode(object) {
////                        //                        let useremailverify =  userDetail["checkEmailVerified"] as! Dictionary<String, Any>
////                        //                        let email = useremailverify["emailVerified"]
////                        //                        print(email!)
////                        //                        objUserDetail.isEmailVerified = (email != nil)
////                        defaults.set(data, forKey: kLoggedInUserData)
////                        defaults.synchronize()
////                        objUserDetail = object
////                    }
//                }else{
//                    if let message = response["validationError"] as? NSDictionary {
//                        GlobalData.shared.showDarkStyleToastMesage(message: message.getApiErrorMessage())
//                    }
//                }
//
//            case .failed(let errorMessage):
//
//                switch errorMessage {
//                default:
//                    self.handleDefaultResponse(errorMessage: errorMessage)
//                    break
//                }
//            }
//        }

    }

    func deleteAddress(id : String) {

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.DELETE_ADDRESS, parameters: ["addressId" : id]) { responceget in
            print(responceget)

            GlobalData.shared.hideProgress()
            switch responceget {
            case .success(let response):

                print(response)
                self.getAddress()

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
