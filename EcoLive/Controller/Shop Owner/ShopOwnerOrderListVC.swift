//
//  ShopOwnerOrderListVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 28/06/21.
//

import UIKit
import SideMenuSwift
import SwiftyJSON
import SDWebImage

class ShopOwnerOrderListVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    var isFromAccount:Bool = false
    
    var arrOrderList: [ShopOrderObject] = []
    
    var arrSearchOrder: [ShopOrderObject] = []
    var searchActive : Bool = false
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //ADDED NOTIFICATION OBSERVER TO NOTIFY ON KEYBOARD SHOW/HIDE
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        
        self.searchBar.showsCancelButton = false
        self.searchBar.delegate = self
        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
            
            self.viewSearch.layer.masksToBounds = false
            self.viewSearch.layer.shadowRadius = 1
            self.viewSearch.layer.shadowOpacity = 0.6
            self.viewSearch.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewSearch.layer.shadowOffset = CGSize(width: 0, height: 2)
            
            self.searchBar.setupSearchBar(background: .clear, inputText: Constants.Color.THEME_BLACK, placeholderText: Constants.Color.SEARCHBAR_PLACEHOLDER, image: Constants.Color.SEARCHBAR_IMAGE)
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
        
        self.tblView.register(UINib(nibName: "ShopOwnerOrderCell", bundle: nil), forCellReuseIdentifier: "ShopOwnerOrderCell")
        
        self.tblView.isHidden = true
        self.lblNoRecord.isHidden = true
        
        self.callShopOrderListAPI()
    }
    
    //MARK: - HELPER -
    
    //TO AVOIDE DATA GOES BEHIND TABLEVIEW WE SET TABLEVIEW BOTTOM OFFSET TO KEYBOARD HEIGHT SO THAT TABLEVIEW LAST RECORD DISPLAY ABOVE KEYBOARD
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            self.tblView.setBottomInset(to: keyboardHeight)
        }
    }

    //RESET TABLEVIEW BOTTOM OFFSET TO 0 ON KEYBOARD HIDES
    @objc func keyboardWillHide(notification: Notification) {
        self.tblView.setBottomInset(to: 0.0)
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        self.view.endEditing(true)
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension ShopOwnerOrderListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        if self.searchActive {
//            return self.arrSearchOrder.count
//        } else {
//            return self.arrOrderList.count
//        }
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopOwnerOrderCell", for: indexPath) as! ShopOwnerOrderCell
        
//        var objDict: ShopOrderObject!
//
//        if self.searchActive {
//            objDict = self.arrSearchOrder[indexPath.section]
//        } else {
//            objDict = self.arrOrderList[indexPath.section]
//        }
//
//        let date = objDict.createdAt
//        let qty = (objDict.qty as NSString).doubleValue
//        let price = (objDict.purchase_price as NSString).doubleValue
//        let totalPrice = qty * price
//
//        cell.lblOrderID.text = objDict._id
//        cell.lblOrderDate.text = date.fromUTCToLocalDateTime(OutputFormat: "dd MMM yyyy hh:mm a")
//        cell.lblOrderTitle.text = objDict.product_name
//        cell.lblProductName.text = "\(objDict.qty) x \(objDict.product_name)"
//        cell.lblProductPrice.text = "$\(objDict.purchase_price)"
//        cell.lblTotalBill.text = "Total bill $\(totalPrice)"
                
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161.0
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

//MARK: - UISEARCHBAR DELEGATE METHOD -

extension ShopOwnerOrderListVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if(searchBar.text != "") {
            self.searchActive = true
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.tblView.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        self.tblView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar.showsCancelButton = true
        if(searchText != "") {
            self.searchActive = true
            if (self.arrOrderList.count) > 0 {
//                self.arrSearchOrder = self.arrOrderList.filter() {
//                    return (($0 as ShopOrderObject).product_name.contains(searchText))
//                }
                
                self.arrSearchOrder = self.arrOrderList.filter() {
                let nameId = ("\(($0 as ShopOrderObject).product_name.lowercased()) \(($0 as ShopOrderObject)._id.lowercased())")
                    return nameId.contains(searchText.lowercased())
                }
            }
        } else {
            self.searchActive = false
        }
        
        if self.searchActive {
            if self.arrSearchOrder.count > 0 {
                self.lblNoRecord.isHidden = true
            } else {
                self.lblNoRecord.isHidden = false
            }
        } else {
            if self.arrOrderList.count > 0 {
                self.lblNoRecord.isHidden = true
            } else {
                self.lblNoRecord.isHidden = false
            }
        }
        
        self.tblView.reloadData()
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension ShopOwnerOrderListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - API CALL -

extension ShopOwnerOrderListVC {
    //SHOP ORDER LIST
    func callShopOrderListAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
                
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestGETURL(Constants.URLS.SHOP_ORDER) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            for i in 0..<payloadData.count {
                                let objOrder = ShopOrderObject.init(payloadData[i])
                                strongSelf.arrOrderList.append(objOrder)
                            }
                            
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
