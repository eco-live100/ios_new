//
//  MyGroceryHome.swift
//  DemoApp
//
//  Created by  on 26/11/22.
//
import UIKit
import SwiftyJSON
import SDWebImage
import DropDown

class MyGroceryHome: BaseVC {

    static func getObject()-> MyGroceryHome {
        let storyboard = UIStoryboard(name: "GroceryBord", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyGroceryHome") as? MyGroceryHome
        if let vc = vc {
            return vc
        }
        return MyGroceryHome()
    }

    //MARK: - PROPERTIES & OUTLETS

    @IBOutlet weak var lblTitleVC: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgShop: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblShopDescription: UILabel!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnAllProduct: UIButton!
    @IBOutlet weak var btnOutofStock: UIButton!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnBackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewMenuList: UIButton!

    @IBOutlet weak var viewAddProduct: UIView!


    var isFromShopList:Bool = false
    var strShopID = ""
    var objShopDetail = ShopObject.init([:])
    var arrProductList: [ProductObject] = []
    var arrSearchProduct: [ProductObject] = []
    var searchActive : Bool = false
    var categoryDropDown = DropDown()
    var categoryCellDropDown = DropDown()


    enum GroceryType {
        case Home
        case HomeEdit
    }

    var groceryType : GroceryType = .Home



    //MARK: - VIEWCONTROLLER LIFE CYCLE -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewDetail()

        self.btnEdit.isHidden = true
        self.btnCamera.isHidden = true
        self.viewAddProduct.isHidden = true
        self.lblTitleVC.text = "Home"

        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnSelect(_:)))
        imgShop.isUserInteractionEnabled = true
        imgShop.addGestureRecognizer(imageTap)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async {
            self.tblViewHeightConstraint.constant = self.clView.contentSize.height
        }
    }

    //MARK: - SETUP VIEW -

    @objc func handleTapOnSelect(_ sender: UITapGestureRecognizer? = nil){
        if groceryType == .Home {
            groceryType = .HomeEdit
        }
        updateUiEddting()
    }

    func updateUiEddting(){

        if groceryType == .Home {

            self.btnEdit.isHidden = true
            self.btnCamera.isHidden = true
            self.viewAddProduct.isHidden = true
            self.lblTitleVC.text = "Home"


        }else if groceryType == .HomeEdit{

            self.btnEdit.isHidden = false
            self.btnCamera.isHidden = false
            self.viewAddProduct.isHidden = false
            self.lblTitleVC.text = "My Grocery Store"

        }

        self.clView.reloadData()

    }

    func setupViewDetail() {
        self.tblViewHeightConstraint.constant = 0

        if UIDevice.current.hasNotch {
            self.btnBackTopConstraint.constant = 35
        } else {
            self.btnBackTopConstraint.constant = 20
        }

        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.searchBar.showsCancelButton = false
        self.searchBar.delegate = self

        DispatchQueue.main.async {
            //            self.viewSearch.drawShadow()
            self.viewSearch.layer.masksToBounds = false
            self.viewSearch.layer.shadowRadius = 1
            self.viewSearch.layer.shadowOpacity = 0.6
            self.viewSearch.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewSearch.layer.shadowOffset = CGSize(width: 0, height: 2)

            self.searchBar.setupSearchBar(background: .clear, inputText: Constants.Color.THEME_BLACK, placeholderText: Constants.Color.SEARCHBAR_PLACEHOLDER, image: Constants.Color.SEARCHBAR_IMAGE)
        }

//        self.btnAllProduct.backgroundColor = Constants.Color.THEME_YELLOW
        self.btnAllProduct.setTitleColor(UIColor.white, for: [])

//        self.btnOutofStock.backgroundColor = UIColor.init(hex: 0xD4D4D4)
        self.btnOutofStock.setTitleColor(UIColor.init(hex: 0x333333), for: [])

        //        self.tblView.showsVerticalScrollIndicator = false
        //        self.tblView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: 1))

        //        self.clView.isHidden = true
        self.lblNoRecord.isHidden = true

//        if objUserDetail.userType == "vendor" {
//            if self.isFromShopList == true {
//                self.btnEdit.isHidden = false
//                self.viewMenuList.isHidden = true
//            } else {
//                self.btnEdit.isHidden = true
//                self.viewMenuList.isHidden = false
//
//            }
//        } else {
//            self.btnEdit.isHidden = true
//            self.viewMenuList.isHidden = false
//
//        }

        self.btnEdit.isHidden = false
        self.viewMenuList.isHidden = false

        self.callShopDetailAPI()
        self.callProductListAPI()

        self.btnOutofStock.setTitle("Out of stock (2)", for: [])
        self.btnOutofStock.isHidden = false

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateShopInformation), name: NSNotification.Name(rawValue: kUpdateShopInformation), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateProductList), name: NSNotification.Name(rawValue: kUpdateProductList), object: nil)

        setupCategoryDropDown()
    }

    //MARK: - HELPER -

    @objc func updateShopInformation() {
        self.callShopDetailAPI()
    }

    @objc func updateProductList() {
        self.callProductListAPI()
    }

    //MARK: - ACTIONS -

    @IBAction func btnBackClick(_ sender: UIButton) {
        if groceryType == .HomeEdit {
            groceryType = .Home
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        updateUiEddting()
    }

    @IBAction func btnEditClick(_ sender: UIButton) {
        let vc = GroceryProductCreate.getObject()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnAllProductClick(_ sender: UIButton) {
//
//        self.btnOutofStock.backgroundColor = .white//
//        self.btnOutofStock.setTitleColor(Constants.Color.blackColor, for: [])
//
//        self.btnAllProduct.backgroundColor = Constants.Color.blackColor
//        self.btnAllProduct.setTitleColor(.white, for: [])

        if sender.tag == 3 {
            let vc = GroceryProductCreate.getObject()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btnOutofStockClick(_ sender: UIButton) {
//        self.btnOutofStock.backgroundColor = Constants.Color.blackColor
//        self.btnOutofStock.setTitleColor(.white, for: [])
//
//        self.btnAllProduct.backgroundColor = .white
//        self.btnAllProduct.setTitleColor(Constants.Color.blackColor, for: [])

        self.clView.reloadData()
    }

    @IBAction func btnMenuClick(_ sender: UIButton) {
        self.categoryDropDown.show()
    }

    //MARK: - HELPER -

    func setupCategoryDropDown() {

        let arrCategory = ["Message","Call","Money Transfer"]

        self.categoryDropDown.backgroundColor = .white
        self.categoryDropDown.selectionBackgroundColor = .white //Constants.Color.THEME_YELLOW
        self.categoryDropDown.textColor = Constants.Color.THEME_BLACK
        self.categoryDropDown.selectedTextColor = Constants.Color.THEME_BLACK //white

        self.categoryDropDown.anchorView = self.viewMenuList
        self.categoryDropDown.bottomOffset = CGPoint(x: 0, y:((self.categoryDropDown.anchorView?.plainView.bounds.height)! + 20))
        self.categoryDropDown.dataSource = arrCategory
        self.categoryDropDown.direction = .bottom
        self.categoryDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.categoryDropDown.cellHeight = 42

        self.categoryDropDown.selectionAction = { (index: Int, item: String) in
            debugPrint(item)
            self.categoryDropDown.hide()
        }
    }

}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

//extension ShopDetailVC: UITableViewDataSource, UITableViewDelegate {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if self.searchActive {
//            return self.arrSearchProduct.count
//        } else {
//            return self.arrProductList.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopProductCell", for: indexPath) as! ShopProductCell
//
//        var objProductDetail: ProductObject!
//
//        if self.searchActive {
//            objProductDetail = self.arrSearchProduct[indexPath.section]
//        } else {
//            objProductDetail = self.arrProductList[indexPath.section]
//        }
//
//        let objImages = objProductDetail.arrProductImages
//
//        if objImages.count > 0 {
//            cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
//            cell.imgProduct.sd_setImage(with: URL(string: objImages[0].image), placeholderImage: UIImage.init(named: "ic_no_image"))
//        } else {
//            cell.imgProduct.image = UIImage.init(named: "ic_no_image")
//        }
//
//        cell.lblProductName.text = objProductDetail.name
//        cell.lblProductDescription.text = objProductDetail.productDescription
//        cell.lblProductPrice.text = "$\(objProductDetail.live_price)"
//
//        cell.selectionStyle = .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 110.0
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
//        footerView.backgroundColor = .clear
//        return footerView
//    }
//}

//MARK: - UISEARCHBAR DELEGATE METHOD -

extension MyGroceryHome: UISearchBarDelegate {
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
        self.clView.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        self.clView.reloadData()
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
            if (self.arrProductList.count) > 0 {
                self.arrSearchProduct = self.arrProductList.filter() {
                    return (($0 as ProductObject).name.contains(searchText))
                }
            }
        } else {
            self.searchActive = false
        }

        if self.searchActive {
            if self.arrSearchProduct.count > 0 {
                self.lblNoRecord.isHidden = true
            } else {
                self.lblNoRecord.isHidden = false
            }
        } else {
            if self.arrProductList.count > 0 {
                self.lblNoRecord.isHidden = true
            } else {
                self.lblNoRecord.isHidden = false
            }
        }

        self.clView.reloadData()
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension MyGroceryHome: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - API CALL -

extension MyGroceryHome {

    //SHOP DETAIL API
    func callShopDetailAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

        let strURL = Constants.URLS.GET_SHOP + "/" + "\(self.strShopID)"

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        AFWrapper.shared.requestGETURL(strURL) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }

            GlobalData.shared.hideProgress()

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {

                    print(response)

                    if response["status"] as? Int ?? 0 == successCode {
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            strongSelf.objShopDetail = ShopObject.init(payload)

                            strongSelf.imgShop.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                            strongSelf.imgShop.sd_setImage(with: URL(string: strongSelf.objShopDetail.image), placeholderImage: UIImage.init(named: "ic_no_shop"))

                            strongSelf.lblShopName.text = strongSelf.objShopDetail.shopName
                            strongSelf.lblShopDescription.text = strongSelf.objShopDetail.shopDescription
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

    //PRODUCT LIST API
    func callProductListAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

        let strURL = Constants.URLS.GET_PRODUCT_LIST + "/" + "\(self.strShopID)"

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        AFWrapper.shared.requestGETURL(strURL) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }

            GlobalData.shared.hideProgress()

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {



                    if response["status"] as? Int ?? 0 == successCode {

                        if let data = response["data"] as? Dictionary<String, Any> {

                            if let payloadData = data["payload"] as? [Dictionary<String, Any>] {
                                strongSelf.arrProductList.removeAll()
                                for i in 0..<payloadData.count {
                                    let objProduct = ProductObject.init(payloadData[i])
                                    strongSelf.arrProductList.append(objProduct)
                                }

                                if strongSelf.arrProductList.count > 0 {
                                    strongSelf.lblNoRecord.isHidden = true
                                } else {
                                    strongSelf.lblNoRecord.isHidden = false
                                }
                                //                                strongSelf.clView.isHidden = false

                                strongSelf.btnAllProduct.setTitle("All product (\(strongSelf.arrProductList.count))", for: [])

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
        } failure: { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
}

//MARK: - UICOLLECTIONVIEW DATASOURSE & DELEGATES METHOD -

extension MyGroceryHome: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.arrSubProductCategory.count
        if self.searchActive {
            return self.arrSearchProduct.count
        } else {
            return 10//self.arrProductList.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCell", for: indexPath as IndexPath) as! ProductCategoryCell

//        var objProduct: ProductObject!
//
//        if self.searchActive {
//            objProduct = self.arrSearchProduct[indexPath.section]
//        } else {
//            objProduct = self.arrProductList[indexPath.section]
//        }
//
//        let objImages = objProduct.arrProductImages
//
//        if objImages.count > 0 {
//            cell.imgCategory.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
//            cell.imgCategory.sd_setImage(with: URL(string: objImages[0].image), placeholderImage: UIImage.init(named: "ic_no_image"))
//        } else {
//            cell.imgCategory.image = UIImage.init(named: "ic_no_image")
//        }
//
//        cell.lblCatTitle.text = "Men's Watch"
//        cell.lblCatTitle.textColor = Constants.Color.THEME_YELLOW
//        cell.lblCatDescription.text = (objProduct.productDescription) + "\n" + "$ \(objProduct.online_price)"
//        cell.lblCatDescription.textColor = Constants.Color.THEME_BLACK

//                cell.lblProductPrice.text = "$\(objProduct.live_price)"
//                cell.lblProductName.text = objProduct.name
//                cell.lblProductDescription.text = objProduct.productDescription
//                cell.lblProductPrice.text = "$\(objProduct.live_price)"
        if groceryType == .Home {
            cell.btn3Dot.isHidden = true
        }else{
            cell.btn3Dot.isHidden = false
        }

        cell.lblCatTitle.text = "Grocery"
        cell.lblCatDescription.text = "Spinach"
        cell.lblPrice.text = "100 $"

        cell.btn3Dot.addTarget(self, action: #selector(cell3DotAction(sender:)), for: .touchUpInside)

        return cell
    }

    @objc func cell3DotAction(sender: UIButton) {

        let arrCategory = ["Change Product ","Update product’s number","Add a discount deal now","Delete"]


        self.categoryCellDropDown.backgroundColor = .white
        self.categoryCellDropDown.selectionBackgroundColor = .white //Constants.Color.THEME_YELLOW
        self.categoryCellDropDown.textColor = Constants.Color.THEME_BLACK
        self.categoryCellDropDown.selectedTextColor = Constants.Color.THEME_BLACK //white

        self.categoryCellDropDown.anchorView = sender
//        self.categoryCellDropDown.bottomOffset = CGPoint(x: 0, y:((self.categoryDropDown.anchorView?.plainView.bounds.height)! + 20))
        self.categoryCellDropDown.dataSource = arrCategory
        self.categoryCellDropDown.direction = .bottom
        self.categoryCellDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.categoryCellDropDown.cellHeight = 42

        self.categoryCellDropDown.selectionAction = { (index: Int, item: String) in
            debugPrint(item)
            self.categoryCellDropDown.hide()
        }
        categoryCellDropDown.show()



    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        //        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "SubProductCategoryVC") as! SubProductCategoryVC
        //        controller.objSubCategory = self.arrSubProductCategory[indexPath.item]
        //        self.navigationController?.pushViewController(controller, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        let newadd = 52
        if Constants.DeviceType.IS_IPHONE_5 {
            return CGSize(width: size, height: 220 + newadd)
        } else if Constants.DeviceType.IS_IPHONE_6P {
            return CGSize(width: size, height: 225 + newadd)
        } else if Constants.DeviceType.IS_IPHONE_X {
            return CGSize(width: size, height: 225 + newadd)
        } else if Constants.DeviceType.IS_IPHONE_11_PRO_MAX {
            return CGSize(width: size, height: 230 + newadd)
        } else if Constants.DeviceType.IS_IPHONE_12_PRO {
            return CGSize(width: size, height: 225 + newadd)
        } else if Constants.DeviceType.IS_IPHONE_12_PRO_MAX {
            return CGSize(width: size, height: 235 + newadd)
        } else {
            return CGSize(width: size, height: 220 + newadd)
        }


    }
}
