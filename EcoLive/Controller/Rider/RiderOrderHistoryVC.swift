//
//  RiderOrderHistoryVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 17/06/21.
//

import UIKit
import SideMenuSwift
import SwiftyJSON
import SDWebImage

class RiderOrderHistoryVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    var isFromAccount:Bool = false
    
    var arrRiderOrder: [RiderOrderObject] = []
    
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
        
        if self.isFromAccount == false {
            self.btnMenu.isHidden = false
            self.btnBack.isHidden = true
        } else {
            self.btnMenu.isHidden = true
            self.btnBack.isHidden = false
        }
        
        self.tblView.showsVerticalScrollIndicator = false
        self.tblView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: 1))
        
        self.tblView.isHidden = true
        self.lblNoRecord.isHidden = true
        
        self.callRiderOrderAPI()
    }
    
    //MARK: - HELPER -
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension RiderOrderHistoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2//self.arrRiderOrder.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RiderOrderHistoryCell", for: indexPath) as! RiderOrderHistoryCell
        
//        let objDict = self.arrRiderOrder[indexPath.section]
//        let orderDate = objDict.createdAt.fromUTCToLocalDateTime(OutputFormat: "yyyy-MM-dd")
//        let currentDate = (Date().string(format: "yyyy-MM-dd"))
//        let startDate = GlobalData.shared.convertStringToDate(StrDate: orderDate, DateFormat: "yyyy-MM-dd")
//        let endDate = GlobalData.shared.convertStringToDate(StrDate: currentDate, DateFormat: "yyyy-MM-dd")
//        let difference = self.daysBetweenDates(startDate: startDate, endDate: endDate)
//
//        if difference > 1 {
//            cell.lblDaysAgo.text = "Days ago"
//        } else {
//            cell.lblDaysAgo.text = "Day ago"
//        }
//        cell.lblDays.text = "\(difference)"
//        cell.lblOrderTitle.text = objDict.product_name
//        cell.lblOrderID.text = "OrderID: " + objDict._id
//        cell.lblOrderStatus.text = "Order status: " + objDict.orderStatus
//        cell.lblAddress.text = "Address: " + objDict.location_address
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let objSelected = self.arrRiderOrder[indexPath.section]
//
//        let controller = GlobalData.trackOrderStoryBoard().instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
//        controller.orderID = objSelected.order_id
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
}

//MARK: - API CALL -

extension RiderOrderHistoryVC {
    //RIDER ORDER LIST
    func callRiderOrderAPI() {
        
        self.tblView.isHidden = false

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
                                    if objProduct.status == "Accept" || objProduct.status == "Decline" {
                                        strongSelf.arrRiderOrder.append(objProduct)
                                    }
                                }
                                
                                if strongSelf.arrRiderOrder.count > 0 {
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
}
