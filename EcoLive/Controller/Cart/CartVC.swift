//
//  CartVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 23/06/21.
//

import UIKit
import SwiftyJSON
import SDWebImage

class CartVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewMyAddressBG: UIView!
    @IBOutlet weak var lblDeliverTo: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var tblView: UITableView!

    var objFirstAddress = AddressObject.init([:])

    var totalAmount: Double = 0.0
    var grandTotal: Double = 0.0

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
        self.tblView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: .leastNormalMagnitude)) //FOR REMOVING EXTRA TOP SPACING OF TABLEVIEW
        self.tblView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: 1))

        let footerNIB = UINib(nibName: "CartFooterView", bundle: nil)
        self.tblView.register(footerNIB, forHeaderFooterViewReuseIdentifier: "CartFooterView")

        self.viewMyAddressBG.isHidden = true
        self.tblView.isHidden = true
        self.lblNoRecord.isHidden = true

        self.callGetAddressAPI()
        self.callCartListAPI()
    }

    //MARK: - HELPER -

    //MARK: - ACTIONS -

    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnWishlistClick(_ sender: UIButton) {
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "ProductWishlistVC") as! ProductWishlistVC
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func btnSelectAddressAction(_ sender: UIButton) {

        let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "MySaveAddress") as! MySaveAddress
        controller.isFromeSelectAddress = true
        controller.onSelectAddress = { [self]
            (address) in
            objFirstAddress._id = address?["_id"] as? String ?? ""
            objFirstAddress.userAddresssLine1 = address?["title"] as? String ?? ""
            self.lblAddress.text = address?["title"] as? String ?? ""
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE METHOD -

extension CartVC: UITableViewDataSource, UITableViewDelegate {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.shared.arrCartList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell

                let objCartDetail = GlobalData.shared.arrCartList[indexPath.row]
                let purchaseType = objCartDetail.purchase_type

                cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgProduct.sd_setImage(with: URL(string: objCartDetail.product_image), placeholderImage: UIImage.init(named: "ic_no_image"))

                cell.lblTitle.text = objCartDetail.product_name
                if purchaseType == "online" {
                    cell.lblPrice.text = "$\(objCartDetail.live_price)"
                } else {
                    cell.lblPrice.text = "$\(objCartDetail.live_price)"
                }
                cell.lblFreeShipping.text = "Eligible for free shipping"
                cell.lblStatus.text = "IN STOCK"
                cell.lblQuantity.text = "\(objCartDetail.quantity)"
                cell.lblProductTotal.text = "= $ \(objCartDetail.total_price)"

                cell.btnMinus.tag = indexPath.row
                cell.btnMinus.addTarget(self, action: #selector(btnMinusClick), for: .touchUpInside)

                cell.btnPlus.tag = indexPath.row
                cell.btnPlus.addTarget(self, action: #selector(btnPlusClick), for: .touchUpInside)

                cell.btnDelete.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(btnDeleteClick), for: .touchUpInside)

        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    //FOOTER VIEW
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footerView = view as? UITableViewHeaderFooterView {
            footerView.contentView.backgroundColor = .clear
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 225.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CartFooterView") as? CartFooterView

        let taxValue: Double = 0.0
        self.grandTotal = self.totalAmount + taxValue

        footerView?.lblItemTotal.text = "$ \(self.totalAmount)"
        footerView?.lblTax.text = "$ \(taxValue)"
        footerView?.lblGrandTotal.text = "$ \(self.grandTotal)"

        footerView?.btnBuyNow.tag = section
        footerView?.btnBuyNow.addTarget(self, action: #selector(btnBuyNowClick), for: .touchUpInside)

        return footerView
    }

    //CELL ACTION
    @objc func btnMinusClick(_ sender: UIButton) {
        if let cell = self.tblView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? CartCell {
            let objCartDetail = GlobalData.shared.arrCartList[sender.tag]
            let currentQTY = objCartDetail.quantity

            if currentQTY > 1 {
                let newQTY = objCartDetail.quantity - 1

                cell.btnPlus.isUserInteractionEnabled = false
                cell.btnMinus.isUserInteractionEnabled = false
                self.callUpdateCartAPI(SelectedCartObject: objCartDetail, SelectedIndex: sender.tag, Quantity: newQTY)
            }
        }
    }

    @objc func btnPlusClick(_ sender: UIButton) {
        if let cell = self.tblView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? CartCell {
            let objCartDetail = GlobalData.shared.arrCartList[sender.tag]
            let qty = objCartDetail.quantity + 1

            cell.btnPlus.isUserInteractionEnabled = false
            cell.btnMinus.isUserInteractionEnabled = false
            self.callUpdateCartAPI(SelectedCartObject: objCartDetail, SelectedIndex: sender.tag, Quantity: qty)
        }
    }

    @objc func btnDeleteClick(_ sender: UIButton) {
        let objCartDetail = GlobalData.shared.arrCartList[sender.tag]

        GlobalData.shared.displayConfirmationAlert(self, title: "Delete Product", message: "Would you like to delete this product from cart?", btnTitle1: "Cancel", btnTitle2: "Delete", actionBlock: { (isConfirmed) in
            if isConfirmed {
                self.callDeleteProductFromCartAPI(SelectedProductID: objCartDetail._id)
            }
        })
    }

    @objc func btnBuyNowClick(button: UIButton) {

        if objFirstAddress._id.count == 0 {

            GlobalData.shared.showDarkStyleToastMesage(message: "Please select address")

            return
        }

        let section = button.tag
        debugPrint("FOOTER SECTION IS: \(section)")

        for item in GlobalData.shared.arrCartList {

            let shop_id = item.shop_id
            let userType = "Registered"
            let total_amount = self.totalAmount
            let description = ""
            let address = objFirstAddress._id
            let paymentType = "Online"
            let product = item.product_id

            var parm = ["shop_id" : shop_id,
                        "userType" : userType,
                        "total_amount" : "\(item.total_price)",
                        "discount_amount" : "0",
                        "description" : description,
                        "address" : address,
                        "paymentType" : paymentType,
                        "product" : product

            ] as! NSDictionary as! [String : Any]
            self.buyOrder(parm: parm as NSDictionary)


        }

//        let controller = GlobalData.cartStoryBoard().instantiateViewController(withIdentifier: "PaymentOptionVC") as! PaymentOptionVC
//        controller.strShopID = GlobalData.shared.arrCartList[0].shop_id
//        controller.payAmount = self.grandTotal
//        controller.objFirstAddress = self.objFirstAddress
//        controller.isBuyNow = false
//        self.navigationController?.pushViewController(controller, animated: true)
    }


}

//MARK: - API CALL -

extension CartVC {
    //GET ADDRESS
    func callGetAddressAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

        let params: [String:Any] = [:]

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        AFWrapper.shared.requestPOSTURL(Constants.URLS.GET_ADDRESS, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }

            GlobalData.shared.hideProgress()

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {

                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            var arrAddress: [AddressObject] = []
                            for i in 0..<payloadData.count {
                                let objAddress = AddressObject.init(payloadData[i])
                                arrAddress.append(objAddress)
                            }

                            if arrAddress.count > 0 {
                                strongSelf.objFirstAddress = arrAddress[0]

                                let attString = GlobalData.shared.convertStringtoAttributedText(strFirst: "Deliver To:" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: strongSelf.lblDeliverTo.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x9F9F9F), strSecond: "\(strongSelf.objFirstAddress.userName), \(strongSelf.objFirstAddress.userPincode)", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: strongSelf.lblDeliverTo.font.pointSize + 1)!, strSecondColor: UIColor.init(hex: 0x333333))

                                strongSelf.lblDeliverTo.attributedText = attString
                                strongSelf.lblAddress.text = strongSelf.objFirstAddress.userAddresssLine1 + ", " + strongSelf.objFirstAddress.city + ", " + strongSelf.objFirstAddress.state + ", " + strongSelf.objFirstAddress.country
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

    //GET CART LIST
    func callCartListAPI() {

        self.tblView.isHidden = false
        self.lblNoRecord.isHidden = true

        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        AFWrapper.shared.requestGETURL(Constants.URLS.CART) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }

            GlobalData.shared.hideProgress()

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {

                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            var arrCart: [CartObject] = []
                            for i in 0..<payloadData.count {
                                let objCart = CartObject.init(payloadData[i])
                                arrCart.append(objCart)
                            }

                            GlobalData.shared.arrCartList = arrCart

                            if GlobalData.shared.arrCartList.count > 0 {
                                let arrTotal = GlobalData.shared.arrCartList.map { $0.total_price }
                                strongSelf.totalAmount = arrTotal.sum()
                                debugPrint(strongSelf.totalAmount)
                            }

                            if GlobalData.shared.arrCartList.count > 0 {
                                strongSelf.viewMyAddressBG.isHidden = false
                                strongSelf.lblNoRecord.isHidden = true
                                strongSelf.tblView.isHidden = false
                            } else {
                                strongSelf.viewMyAddressBG.isHidden = true
                                strongSelf.lblNoRecord.isHidden = false
                                strongSelf.tblView.isHidden = true
                            }

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

    //UPDATE CART
    func callUpdateCartAPI(SelectedCartObject selectedCartObject: CartObject, SelectedIndex selectedIndex: Int, Quantity quantiry: Int) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

        let strURL = Constants.URLS.CART + "/" + "\(selectedCartObject._id)"

        var params: [String:Any] = [:]
        params["product_id"] = selectedCartObject.product_id
        params["shop_id"] = selectedCartObject.shop_id
        params["qty"] = "\(quantiry)"
        params["product_color"] = selectedCartObject.product_color

        AFWrapper.shared.requestPOSTURL(strURL, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }

            if let cell = strongSelf.tblView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? CartCell {
                cell.btnPlus.isUserInteractionEnabled = true
                cell.btnMinus.isUserInteractionEnabled = true
            }
            if JSONResponse != JSON.null {

                
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {

                        strongSelf.callCartListAPI()

                        if let payload = response["data"] as? Dictionary<String, Any> {
                            let objCart = CartObject.init(payload)

                            if let row = GlobalData.shared.arrCartList.firstIndex(where: {$0._id == selectedCartObject._id}) {
                                GlobalData.shared.arrCartList[row] = objCart
                            }

                            if GlobalData.shared.arrCartList.count > 0 {
                                let arrTotal = GlobalData.shared.arrCartList.map { $0.total_price }
                                strongSelf.totalAmount = arrTotal.sum()
                                debugPrint(strongSelf.totalAmount)
                            }

                            if let cell = strongSelf.tblView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? CartCell {
                                cell.btnPlus.isUserInteractionEnabled = true
                                cell.btnMinus.isUserInteractionEnabled = true
                            }

                            //                            let indexPosition = IndexPath(row: selectedIndex, section: 0)
                            //                            strongSelf.tblView.reloadRows(at: [indexPosition], with: .none)

                            GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        if let cell = strongSelf.tblView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? CartCell {
                            cell.btnPlus.isUserInteractionEnabled = true
                            cell.btnMinus.isUserInteractionEnabled = true
                        }
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        if let cell = strongSelf.tblView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? CartCell {
                            cell.btnPlus.isUserInteractionEnabled = true
                            cell.btnMinus.isUserInteractionEnabled = true
                        }
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            if let cell = self.tblView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? CartCell {
                cell.btnPlus.isUserInteractionEnabled = true
                cell.btnMinus.isUserInteractionEnabled = true
            }
        }
    }

    //DELETE PRODUCT FROM CART
    func callDeleteProductFromCartAPI(SelectedProductID selectedProductID: String) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

        let strURL = Constants.URLS.CART + "/" + "\(selectedProductID)"

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        AFWrapper.shared.requestDELETEURL(strURL) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }

            GlobalData.shared.hideProgress()

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {

                        if let row = GlobalData.shared.arrCartList.firstIndex(where: {$0._id == selectedProductID}) {
                            GlobalData.shared.arrCartList.remove(at: row)
                        }

                        if GlobalData.shared.arrCartList.count > 0 {
                            let arrTotal = GlobalData.shared.arrCartList.map { $0.total_price }
                            strongSelf.totalAmount = arrTotal.sum()
                            debugPrint(strongSelf.totalAmount)
                        }

                        if GlobalData.shared.arrCartList.count > 0 {
                            strongSelf.viewMyAddressBG.isHidden = false
                            strongSelf.lblNoRecord.isHidden = true
                            strongSelf.tblView.isHidden = false
                        } else {
                            strongSelf.viewMyAddressBG.isHidden = true
                            strongSelf.lblNoRecord.isHidden = false
                            strongSelf.tblView.isHidden = true
                        }

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
        } failure: { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }


    func buyOrder(parm : NSDictionary){
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        //Constants.URLS.ORDER
        AFWrapper.shared.requestPOSTURL("order/", params: parm as! [String : Any]) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }

            GlobalData.shared.hideProgress()

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {

                        self?.navigationController?.popToRootViewController(animated: true)
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
