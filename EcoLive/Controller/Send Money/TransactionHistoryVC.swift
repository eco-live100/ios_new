//
//  TransactionHistoryVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 23/06/21.
//

import UIKit
import SwiftyJSON
import SDWebImage

class TransactionHistoryVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var viewMore: UIView!
    
    var arrTransactionHistory: [TransactionHistoryObject] = []
    
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
        self.tblView.tableFooterView = UIView()
        
        self.tblView.isHidden = true
        self.lblNoRecord.isHidden = true
        
        self.viewMore.isHidden = true
        
        self.callTransationHistoryAPI()
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMoreClick(_ sender: UIButton) {
        self.viewMore.isHidden = false
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension TransactionHistoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3//self.arrTransactionHistory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        
//        let objData = self.arrTransactionHistory[indexPath.section]
//        
//        if objData.image == "" {
//            cell.imgDP.isHidden = true
//            cell.viewDP.isHidden = false
//            
//            let userName = objData.userName
//            if userName.contains(" ") {
//                let userNameArr = userName.components(separatedBy: " ")
//                let firstName = userNameArr[0]
//                let lastName = userNameArr[1]
//                let dpName = firstName.prefix(1) + lastName.prefix(1)
//                
//                cell.lblDP.text = "\(dpName)".uppercased()
//            } else {
//                let dpName = userName.prefix(1)
//                
//                cell.lblDP.text = "\(dpName)".uppercased()
//            }
//            
//            cell.lblFullName.text = userName
//        } else {
//            cell.imgDP.isHidden = false
//            cell.viewDP.isHidden = true
//            
//            cell.imgDP.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
//            cell.imgDP.sd_setImage(with: URL(string: objData.image), placeholderImage: UIImage.init(named: "user_placeholder"))
//            
//            cell.lblFullName.text = objData.userName
//        }
//                
//        cell.lblDate.text = objData.createdAt.fromUTCToLocalDateTime(OutputFormat: "d MMM, h:mm a")
//        cell.lblAmount.text = objData.amount
//
//        if objData.transaction_mode == "debit" {
//            cell.lblAmount.textColor = UIColor.init(hex: 0xFF0000)
//        } else {
//            cell.lblAmount.textColor = Constants.Color.THEME_YELLOW
//        }
//        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - API CALL -

extension TransactionHistoryVC {
    //TRANSACTION HISTORY
    func callTransationHistoryAPI() {
        self.tblView.isHidden = false
        self.lblNoRecord.isHidden = true

        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let params: [String:Any] = [:]
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.TRANSACTION_HISTORY, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let data = response["data"] as? Dictionary<String, Any> {
                            
                            if let payloadData = data["payload"] as? [Dictionary<String, Any>] {
                                
                                for i in 0..<payloadData.count {
                                    let objHistory = TransactionHistoryObject.init(payloadData[i])
                                    strongSelf.arrTransactionHistory.append(objHistory)
                                }
                                
                                if strongSelf.arrTransactionHistory.count > 0 {
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
