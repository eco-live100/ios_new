//
//  MyOrderVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 09/06/21.
//

import UIKit
import SideMenuSwift
import SwiftyJSON
import SDWebImage

class MyOrderVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    var isFromAccount:Bool = false
    
    var arrOrderList: [OrderObject] = []
    var dicOrderDate = [String : [OrderObject]]()
    
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
        
        let headerNIB = UINib(nibName: "MyOrderDateHeaderView", bundle: nil)
        self.tblView.register(headerNIB, forHeaderFooterViewReuseIdentifier: "MyOrderDateHeaderView")
        
        self.tblView.isHidden = true
        self.lblNoRecord.isHidden = true
        
        self.callOrderListAPI()
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCartClick(_ sender: UIButton) {
        let controller = GlobalData.cartStoryBoard().instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension MyOrderVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dicOrderDate.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(self.dicOrderDate.keys.sorted(by: >)) //Array(self.dicOrderDate.keys.sorted())
        let item = self.dicOrderDate[keys[section]]
        return item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        
        let keys = Array(self.dicOrderDate.keys.sorted(by: >)) //Array(self.dicOrderDate.keys.sorted())
        let item = self.dicOrderDate[keys[indexPath.section]]
        let objOrder = item?[indexPath.row]
        
        cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgProduct.sd_setImage(with: URL(string: objOrder?.product_image ?? ""), placeholderImage: UIImage.init(named: "ic_no_image"))
        cell.lblName.text = objOrder?.product_name
        cell.lblStatus.text = objOrder?.createdAt ?? ""//"Delivered on wed, oct 26th"
        cell.lblPrice.text = "$" + "\(objOrder?.purchase_price ?? "")"
        cell.ratingView.rating = 3.0
        cell.ratingView.text = "(3.0)"
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let keys = Array(self.dicOrderDate.keys.sorted(by: >)) //Array(self.dicOrderDate.keys.sorted())
        let item = self.dicOrderDate[keys[indexPath.section]]
        let objSelected = item?[indexPath.row]
        
        let controller = GlobalData.trackOrderStoryBoard().instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
        controller.orderID = objSelected?.order_id ?? ""
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //HEADER VIEW
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .clear
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tblView.dequeueReusableHeaderFooterView(withIdentifier: "MyOrderDateHeaderView") as! MyOrderDateHeaderView
        
        let keys = Array(self.dicOrderDate.keys.sorted(by: >)) //Array(self.dicOrderDate.keys.sorted())
        let key = keys[section]
        let value = self.dicOrderDate[keys[section]]
        
        let date = "\(key)" //key.fromUTCToLocalDateTime(OutputFormat: "E, MMM d, yyyy")
        let finalDate = GlobalData.shared.formattedDateFromString(dateString: date, InputFormat: "yyyy/MM/dd", OutputFormat: "E, MMM d, yyyy")
        let orderID = value?[0]._id
        
        header.lblDate.text = "\(finalDate ?? "")" + " " + "(\(orderID ?? ""))"
        
        return header
    }
    
    //FOOTER VIEW
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
        footerView.backgroundColor = .clear
        return footerView
    }
}

//MARK: - API CALL -

extension MyOrderVC {
    //ORDER LIST
    func callOrderListAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
                
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        //Constants.URLS.ORDER
        AFWrapper.shared.requestGETURL("order/") { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            for i in 0..<payloadData.count {
                                let objOrder = OrderObject.init(payloadData[i])
                                strongSelf.arrOrderList.append(objOrder)
                            }
                            
                            //GROUPING BY DATE
                            strongSelf.dicOrderDate = Dictionary(grouping: strongSelf.arrOrderList, by: { $0.orderDate})
                            debugPrint(strongSelf.dicOrderDate)
                            
                            if strongSelf.arrOrderList.count > 0 {
                                strongSelf.lblNoRecord.isHidden = true
                            } else {
                                strongSelf.lblNoRecord.isHidden = false
                            }
                            strongSelf.tblView.isHidden = false
                            
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
