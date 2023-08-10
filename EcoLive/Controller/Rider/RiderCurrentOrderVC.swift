//
//  RiderCurrentOrderVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 17/06/21.
//

import UIKit
import SwiftyJSON
import SDWebImage

class RiderCurrentOrderVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    var arrCurrentOrder: [RiderOrderObject] = []
    
    var isFromSideMenu:Bool = false
    
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
        
//        if self.isFromSideMenu {
            self.btnMenu.isHidden = false
            self.btnBack.isHidden = true
//        } else {
//            self.btnMenu.isHidden = true
//            self.btnBack.isHidden = false
//        }
        
        self.tblView.showsVerticalScrollIndicator = false
        self.tblView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: 1))
        
        self.tblView.isHidden = true
        self.lblNoRecord.isHidden = true
        
    
        
        //self.callRiderCurrentOrderAPI()
        
        lblNoRecord.isHidden = true
        tblView.isHidden = false
        
        GlobalData.shared.reloadTableView(tableView: tblView)
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension RiderCurrentOrderVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5 //self.arrCurrentOrder.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RiderCurrentOrderCell", for: indexPath) as! RiderCurrentOrderCell
        
//        let objDict = self.arrCurrentOrder[indexPath.section]
//        let date = objDict.createdAt
//
//        cell.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
//        cell.imgUser.sd_setImage(with: URL(string: objDict.product_image), placeholderImage: UIImage.init(named: "ic_no_image"))
//
//        cell.lblUsername.text = objDict.product_name
//        cell.lblOrderDate.text = date.fromUTCToLocalDateTime(OutputFormat: "dd MMM yyyy")
//        cell.lblOrderTime.text = date.fromUTCToLocalDateTime(OutputFormat: "hh:mm a")
//        cell.lblDeliveryTime.text = "1 Hour"
//        cell.lblEarn.text = "$ 50"
//        cell.lblPaymentMode.text = "Debit card"
//
//        cell.btnAccept.tag = indexPath.section
//        cell.btnAccept.addTarget(self, action: #selector(btnAcceptClick), for: .touchUpInside)
//
//        cell.btnDecline.tag = indexPath.section
//        cell.btnDecline.addTarget(self, action: #selector(btnDeclineClick), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let objDict = self.arrCurrentOrder[indexPath.section]
//        
//        let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RiderOrderAddressVC") as! RiderOrderAddressVC
//        controller.objOrderDetail = objDict
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 183.0
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
    
    @objc func btnAcceptClick(_ sender: UIButton) {
        let objDict = self.arrCurrentOrder[sender.tag]
        self.callAcceptDeclineOrderAPI(DeliveryId: objDict._id, OrderId: objDict.order_id, OrderStatus: "Accept")
    }
    
    @objc func btnDeclineClick(_ sender: UIButton) {
        let objDict = self.arrCurrentOrder[sender.tag]
        self.callAcceptDeclineOrderAPI(DeliveryId: objDict._id, OrderId: objDict.order_id, OrderStatus: "Decline")
    }
}

//MARK: - API CALL -

extension RiderCurrentOrderVC {
    //RIDER CURRENT ORDER LIST
    func callRiderCurrentOrderAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["user_id"] = objUserDetail._id
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.RIDER_ORDER, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let data = response["data"] as? Dictionary<String, Any> {
                            
                            if let payloadData = data["payload"] as? [Dictionary<String, Any>] {
                                for i in 0..<payloadData.count {
                                    let objProduct = RiderOrderObject.init(payloadData[i])
                                    if objProduct.status == "Open" {
                                        strongSelf.arrCurrentOrder.append(objProduct)
                                    }
                                }
                                
                                if strongSelf.arrCurrentOrder.count > 0 {
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
    
    //ACCEPT/DECLINE ORDER
    func callAcceptDeclineOrderAPI(DeliveryId deliveryId: String, OrderId orderId: String, OrderStatus orderStatus: String) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["delivery_id"] = deliveryId
        params["order_id"] = orderId
        params["status"] = orderStatus
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.ACCEPT_DECLINE_ORDER, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let row = strongSelf.arrCurrentOrder.firstIndex(where: {$0._id == deliveryId}) {
                            strongSelf.arrCurrentOrder.remove(at: row)
                        }
                        
                        if strongSelf.arrCurrentOrder.count > 0 {
                            strongSelf.lblNoRecord.isHidden = true
                        } else {
                            strongSelf.lblNoRecord.isHidden = false
                        }
                        strongSelf.tblView.isHidden = false
                                                
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)
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
}
