//
//  ProductDetailVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 01/07/21.
//

import UIKit
import Cosmos
import SwiftyJSON
import SDWebImage
import DLRadioButton

class ProductDetailVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewOff: UIView!
    @IBOutlet weak var lblOff: UILabel!
    @IBOutlet weak var clViewProductImages: UICollectionView!
    @IBOutlet weak var clViewProductImagesHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewProductDetail: UIView!
    @IBOutlet weak var lblProductCategory: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var viewShopLive: UIView!
    @IBOutlet weak var lblShopLive: UILabel!
    @IBOutlet weak var viewShopOnline: UIView!
    @IBOutlet weak var lblShopOnline: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var lblColorName: UILabel!
    @IBOutlet weak var clViewColor: UICollectionView!
//    @IBOutlet var btnBuyOption: DLRadioButton!
    @IBOutlet weak var lblFreeDelivery: UILabel!
    @IBOutlet weak var lblFastDelivery: UILabel!
    @IBOutlet weak var tblOffer: ContentSizedTableView!
    @IBOutlet weak var viewBGVisitShopItem: UIView!
    @IBOutlet weak var viewButtomItemCard: UIView!
    @IBOutlet weak var lblItemAbout: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblQTY: UILabel!
    @IBOutlet weak var tblItemDescription: ContentSizedTableView!
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var btnAddCart: UIButton!
    @IBOutlet weak var tblOfferHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblItemDescriptionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var clViewSimilarProduct: UICollectionView!


    @IBOutlet weak var lblDeliveryTimeAp: UILabel!
    @IBOutlet weak var lblFastDeliveryTime: UILabel!

    
    var strPurchaseType = "online"//""
    
    var strProductID = ""
    var dicProductData = NSDictionary()
    var arImages = NSArray()

    
    var objFirstAddress = AddressObject.init([:])
    var objProductDetail = ProductObject.init([:])

    var similarProductList : [NSDictionary] = []

    var arrProductColor: [ColorDataObject] = []
    var strSelectedColor = ""
    var strSelColorName = ""

    var timer = Timer()
    var counter = 0

    private var productID = ""
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
            
        self.callProductDetailAPI()
        self.callProductCategoryListAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.tblOfferHeightConstraint.constant = self.tblOffer.contentSize.height
            self.tblItemDescriptionHeightConstraint.constant = self.tblItemDescription.contentSize.height
        }
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        
        self.view.backgroundColor = Constants.Color.THEME_BLUE
        self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        
       // self.btnBuyOption.isMultipleSelectionEnabled = false
        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
            
            self.viewHeader.createButtonShadow()
            self.viewOff.roundCorners(corners: [.topRight, .bottomRight], radius: 15)
//            self.viewProductDetail.roundCorners(corners: [.topRight, .bottomRight], radius: 15)
//            self.viewProductDetail.createButtonShadow()
//            self.viewShopLive.createButtonShadow()
//            self.viewShopOnline.createButtonShadow()
            
            self.tblOffer.createButtonShadow()
            
            self.btnBuyNow.layer.cornerRadius = self.btnBuyNow.frame.height / 2.0
            self.btnBuyNow.createButtonShadow()
            
            self.btnAddCart.layer.cornerRadius = self.btnAddCart.frame.height / 2.0
            self.btnAddCart.createButtonShadow()
            self.viewBGVisitShopItem.createButtonShadow()

            self.lblItemAbout.text = "* Care Instruction: Hand wash \n* Color Name: White-Orange\n* Material: Velvet Universal\n* You Naver Know where the day will take you, but at least you know you're going to look fresh while you figure it out."
            
            self.viewButtomItemCard.addTopShadow()
            
        }
        
        self.btnAddCart.setTitle("ADD TO CART", for: [])
        
        self.tblOffer.showsVerticalScrollIndicator = false
        self.tblOffer.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblOffer.frame.size.width, height: 1))
        
        self.tblItemDescription.showsVerticalScrollIndicator = false
        self.tblItemDescription.tableFooterView = UIView()
        
        self.callGetAddressAPI()
    }
    
    func setupData() {

        let productData = self.dicProductData["productData"] as? NSDictionary
        self.lblTitle.text = productData?["productName"] as? String ?? ""
        self.lblProductName.text = productData?["productName"] as? String ?? ""
        let arImages = (dicProductData["file"] as? NSArray ?? [])
        self.arImages = arImages
        self.pageControl.numberOfPages = arImages.count
        self.pageControl.currentPage = 0

        self.lblShopLive.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop live" + "\n", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 13)!, strFirstColor: Constants.Color.GrayColor, strSecond: "$" + "\(productData?["priceLive"] ?? "") \n" , strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: 30)!, strSecondColor: Constants.Color.THEME_BLACK,strThree: "(1 hour delivery service)",strThreeFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 13)!,strThreeColor: Constants.Color.THEME_YELLOW)
        self.lblShopOnline.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop online" + "\n", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 13)!, strFirstColor: Constants.Color.GrayColor, strSecond: "$" + "\(productData?["price"] ?? "") \n" , strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: 30)!, strSecondColor: Constants.Color.THEME_BLACK,strThree: "(one or more days delivery service)",strThreeFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 13)!,strThreeColor: Constants.Color.THEME_YELLOW)
        GlobalData.shared.reloadCollectionView(collectionView: self.clViewProductImages)

        arrProductColor = []

        if let colors = productData?["color"] as? NSArray{
            for i in colors {
                arrProductColor.append(ColorDataObject(hexcode: i as? String ?? "", color_name: i as? String ?? ""))
            }
        }

        GlobalData.shared.reloadCollectionView(collectionView: self.clViewColor)

        self.productID = self.dicProductData["_id"] as? String ?? ""


        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }

        lblDeliveryTimeAp.text = "FREE DELIVERY: \(self.dicProductData["freeDeliveryTime"] as? String ?? "")"
        lblFastDeliveryTime.text = "Fastest delivery: \(self.dicProductData["fastDeliver"] as? String ?? "")"

        self.callSubProductCategoryAPI()

        return
        self.lblTitle.text = self.objProductDetail.name
        
        self.pageControl.numberOfPages = self.objProductDetail.arrProductImages.count
        self.pageControl.currentPage = 0


        GlobalData.shared.reloadCollectionView(collectionView: self.clViewProductImages)
        GlobalData.shared.reloadCollectionView(collectionView: self.clViewSimilarProduct)

        if self.objProductDetail.isfavourite == false {
            self.btnFavourite.isSelected = false
        } else {
            self.btnFavourite.isSelected = true
        }
        
        self.lblOff.text = "20% off"
        self.lblProductName.text = self.objProductDetail.name
        
        self.viewRating.rating = 3.5
//        self.viewRating.text = "(202)"
                
        self.lblShopLive.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop live" + "\n", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 13)!, strFirstColor: Constants.Color.GrayColor, strSecond: "$" + "\(self.objProductDetail.online_price) \n" , strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: 30)!, strSecondColor: Constants.Color.THEME_BLACK,strThree: "(1 hour delivery service)",strThreeFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 13)!,strThreeColor: Constants.Color.THEME_YELLOW)
        self.lblShopOnline.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop online" + "\n", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 13)!, strFirstColor: Constants.Color.GrayColor, strSecond: "$" + "\(self.objProductDetail.live_price) \n" , strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: 30)!, strSecondColor: Constants.Color.THEME_BLACK,strThree: "(one or more days delivery service)",strThreeFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 13)!,strThreeColor: Constants.Color.THEME_YELLOW)

//        self.lblShopOnline.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop online" + " " + "$" + "\(self.objProductDetail.online_price)" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: self.lblShopOnline.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "(one or more days delivery service)", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: self.lblShopOnline.font.pointSize - 1)!, strSecondColor: Constants.Color.THEME_YELLOW)
        
//        self.lblFreeDelivery.attributedText = GlobalData.shared.setColoredSelectedLabel(mainStr: "FREE DELIVERY: Friday, March 19", mainColor: UIColor.init(hex: 0x333333), selectedstr: "FREE DELIVERY", selectedColor: Constants.Color.THEME_YELLOW)
//
//        self.lblFastDelivery.attributedText = GlobalData.shared.setColoredSelectedLabel(mainStr: "Fastest delivery: TOMORROW", mainColor: UIColor.init(hex: 0x333333), selectedstr: "TOMORROW", selectedColor: Constants.Color.THEME_YELLOW)
        
        self.lblStatus.text = "IN STOCK"
        self.lblQTY.text = "1"
        
        var colorString = self.objProductDetail.colors
        colorString = colorString.replacingOccurrences(of: "&#x5C;", with: "")
        do {
            let jsonData1 = colorString.data(using: .utf8)!
            self.arrProductColor = try JSONDecoder().decode([ColorDataObject].self, from: jsonData1)
        } catch {
            debugPrint(error)
        }
        
        GlobalData.shared.reloadCollectionView(collectionView: self.clViewColor)
        
    }
    
    //MARK: - HELPER -
    
    @objc func changeImage() {
        if self.counter < self.arImages.count {
            let index = IndexPath.init(item: self.counter, section: 0)
            self.clViewProductImages.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.pageControl.currentPage = self.counter
            self.counter += 1
        } else {
            self.counter = 0
            let index = IndexPath.init(item: self.counter, section: 0)
            self.clViewProductImages.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            self.pageControl.currentPage = self.counter
            self.counter = 1
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnWishlistClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "ProductWishlistVC") as! ProductWishlistVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnCartClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.cartStoryBoard().instantiateViewController(withIdentifier: "CartVC") as! CartVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnSelectLocationClick(_ sender: UIButton) {
        debugPrint("Select Location Click")
    }
    
    @IBAction func btnFavouriteClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            if sender.isSelected == false {
                self.callAddFavouriteProductAPI()
            } else {
                self.callDeleteFavouriteProductAPI()
            }
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnShareClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            debugPrint("Share Click")
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnChatClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            debugPrint("Chat Click")
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnVisitShopClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopDetailVC") as! ShopDetailVC
            controller.isFromShopList = false
            controller.strShopID = self.objProductDetail.shop
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnMessageClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            debugPrint("Message Click")
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnCallClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            debugPrint("Call Click")
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnBuyNowClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            if self.strSelectedColor == "" {
                GlobalData.shared.showDarkStyleToastMesage(message: "Color is required")
            } else if self.strPurchaseType == "" {
                GlobalData.shared.showDarkStyleToastMesage(message: "Purchase type is required")
            } else {
                var productPrice:Double = 0.0
                if self.strPurchaseType == "live" {
                    productPrice = self.objProductDetail.live_price
                } else if self.strPurchaseType == "online" {
                    productPrice = self.objProductDetail.online_price
                }
                
                let controller = GlobalData.cartStoryBoard().instantiateViewController(withIdentifier: "PaymentOptionVC") as! PaymentOptionVC
                controller.strShopID = self.objProductDetail.shop
                controller.payAmount = productPrice
                controller.objFirstAddress = self.objFirstAddress
                controller.strProductId = self.strProductID
                controller.strProductColor = self.strSelectedColor
                controller.strPurchaseType = self.strPurchaseType
                controller.isBuyNow = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnAddCartClick(_ sender: UIButton) {



        if defaults.object(forKey: kAuthToken) != nil {

            self.btnAddCart.isUserInteractionEnabled = false
            self.callAddtoCartAPI()

            return

            if self.btnAddCart.titleLabel?.text == "ADD TO CART" {
                if self.strSelectedColor == "" {
                    GlobalData.shared.showDarkStyleToastMesage(message: "Color is required")
                } else if self.strPurchaseType == "" {
                    GlobalData.shared.showDarkStyleToastMesage(message: "Purchase type is required")
                } else {
                    if GlobalData.shared.arrCartList.count > 0 {
                        let objFirst = GlobalData.shared.arrCartList[0]
                        let shopID = objFirst.shop_id
                        
                        if shopID == self.objProductDetail.shop {
                            self.btnAddCart.isUserInteractionEnabled = false
                            self.callAddtoCartAPI()
                        } else {
                            let alert = UIAlertController(title: "Alert", message: "There is some product from other shop are already added in your cart. Do you want to continue with your existing cart or need to replace this product with existing cart?", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction) in
                                
                                self.callDeleteCartAPI()
                            }))
                            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        self.btnAddCart.isUserInteractionEnabled = false
                        self.callAddtoCartAPI()
                    }
                }
            } else {
                let controller = GlobalData.cartStoryBoard().instantiateViewController(withIdentifier: "CartVC") as! CartVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnBuyOptionClick(radioButton : DLRadioButton) {
        if radioButton.accessibilityIdentifier ?? "" ==  "Live" {
            self.strPurchaseType = "live"
        } else if radioButton.accessibilityIdentifier ?? "" ==  "Online" {
            self.strPurchaseType = "online"
        }
        debugPrint("SELECTED OPTION:- \(self.strPurchaseType)")
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension ProductDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblOffer {
            return 3
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblOffer {
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            
            if (cell == nil) {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            }

            if indexPath.row == 0 {
                cell?.imageView?.image =  UIImage.init(named: "ic_offer")
                cell?.textLabel?.attributedText = GlobalData.shared.attributedText(withString:"Save extra with 2 offers", boldString: "Save extra", font: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: self.lblFreeDelivery.font.pointSize)!)
                
                cell?.textLabel?.textColor = UIColor.init(hex: 0x333333)
                let itemSize = CGSize.init(width: 20, height: 20)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
                let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
                cell?.imageView?.image!.draw(in: imageRect)
                cell?.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            } else if indexPath.row == 1 {
                cell?.textLabel?.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "CASHBACK", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: self.lblFreeDelivery.font.pointSize)!, strFirstColor: UIColor.init(hex: 0xFF0000), strSecond: ": " + "5% back  ICICI bank credit card for prime membership", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: self.lblFreeDelivery.font.pointSize)!, strSecondColor: UIColor.init(hex: 0x333333))
            } else if indexPath.row == 2 {
                cell?.textLabel?.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "NO COST EMI", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: self.lblFreeDelivery.font.pointSize)!, strFirstColor: UIColor.init(hex: 0xFF0000), strSecond: ": " + "Avail no cost EMI on select cards for orders above $ 2500", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: self.lblFreeDelivery.font.pointSize)!, strSecondColor: UIColor.init(hex: 0x333333))
            }
            
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.lineBreakMode = .byWordWrapping
            
            return cell!
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblOffer {
            return 44.0
        } else {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - UICOLLECTIONVIEW DATASOURCE & DELEGATE METHOD -

extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clViewProductImages {
            return self.arImages.count //objProductDetail.arrProductImages.count
        } else if collectionView == self.clViewSimilarProduct {
            return self.similarProductList.count//self.objProductDetail.arrProductImages.count
        } else {
            return self.arrProductColor.count
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.clViewProductImages {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCell", for: indexPath as IndexPath) as! PromotionCell
            
            let objData = self.arImages[indexPath.item] as! NSDictionary
            
            cell.imgPromotion.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgPromotion.sd_setImage(with: URL(string: objData["name"] as? String ?? ""), placeholderImage: UIImage.init(named: "ic_no_shop"))
            
            cell.imgPromotion.contentMode = .scaleAspectFit
            
            return cell
        } else if collectionView == clViewSimilarProduct {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearProductCell", for: indexPath as IndexPath) as! NearProductCell
            if let objData = similarProductList[indexPath.row] as? NSDictionary {
                if let productData = objData["productData"] as? NSDictionary {

                    cell.lblShopLive.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop live" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "$\(productData["priceLive"] as? String ?? "")", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize)!, strSecondColor: Constants.Color.THEME_YELLOW)
                    cell.lblShopOnline.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop online" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "$\(productData["price"] as? String ?? "")", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize)!, strSecondColor: UIColor.init(hex: 0xFF0000))

                    cell.lblProductTitle.text = productData["productName"] as? String ?? ""
                }
                if let file = objData["file"] as? NSArray {
                    if let productData = file.firstObject as? NSDictionary {
                        let image = productData["name"] as? String ?? ""
                        cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgProduct.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: "ic_no_shop"))
                    }
                }
                cell.imgProduct.contentMode = .scaleAspectFit
            }
            //self.objProductDetail.arrProductImages[indexPath.item]
            

            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductColorCell", for: indexPath as IndexPath) as! ProductColorCell
            
            cell.imgAdd.isHidden = true
            cell.imgView.isHidden = false
            
            let hexCode = self.arrProductColor[indexPath.item].hexcode
            cell.imgView.backgroundColor = GlobalData.shared.hexStringToUIColor(hex: hexCode)
            
            cell.imgView.isUserInteractionEnabled = true
            cell.imgView.tag = indexPath.item
            
            let objGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageColorClick(_:)))
            objGesture.numberOfTapsRequired = 1
            cell.imgView.addGestureRecognizer(objGesture)
            
            if hexCode == self.strSelectedColor {
                cell.imgView.layer.borderColor = UIColor.init(hex: 0x333333).cgColor
            } else {
                cell.imgView.layer.borderColor = UIColor.clear.cgColor
            }
            
            cell.imgView.layer.cornerRadius = cell.imgView.layer.frame.size.height / 2
            cell.imgView.layer.borderWidth = 1.5
            cell.imgView.clipsToBounds = true
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == clViewSimilarProduct {
            if let objData = similarProductList[indexPath.row] as? NSDictionary {
                self.strProductID = objData["_id"] as? String ?? ""
                self.callProductDetailAPI()
                self.callProductCategoryListAPI()
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.clViewProductImages {
            if Constants.DeviceType.IS_IPHONE_5 {
                self.clViewProductImagesHeight.constant = 280
            } else if Constants.DeviceType.IS_IPHONE_6 {
                self.clViewProductImagesHeight.constant = 300
            } else if Constants.DeviceType.IS_IPHONE_6P {
                self.clViewProductImagesHeight.constant = 320
            } else if Constants.DeviceType.IS_IPHONE_X {
                self.clViewProductImagesHeight.constant = 320
            } else if Constants.DeviceType.IS_IPHONE_11_PRO_MAX {
                self.clViewProductImagesHeight.constant = 320
            } else if Constants.DeviceType.IS_IPHONE_12_PRO {
                self.clViewProductImagesHeight.constant = 330
            } else if Constants.DeviceType.IS_IPHONE_12_PRO_MAX {
                self.clViewProductImagesHeight.constant = 340
            }
            
            return CGSize(width: collectionView.frame.width, height: self.clViewProductImagesHeight.constant)
        }else if collectionView == self.clViewSimilarProduct {
            return CGSize(width: collectionView.frame.width / 2, height: 300)
        }
        else {
            let size = self.clViewColor.frame.size.height
            return CGSize(width: size, height: size)
        }
    }
    
    @objc func imageColorClick(_ sender:UITapGestureRecognizer) -> Void {
        self.strSelectedColor = self.arrProductColor[sender.view!.tag].hexcode
        self.strSelColorName = self.arrProductColor[sender.view!.tag].color_name
        
        GlobalData.shared.reloadCollectionView(collectionView: self.clViewColor)
        
        self.lblColorName.text = "Color name: \(self.arrProductColor[sender.view!.tag].color_name)"
    }
}

//MARK: - UISCROLLVIEW DELEGATE -

extension ProductDetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.clViewProductImages {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width

            self.pageControl.currentPage = Int(round(offSet / width))
        } else {
            debugPrint("collectionview")
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let visibleRect = CGRect(origin: self.clViewProductImages.contentOffset, size: self.clViewProductImages.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        if let visibleIndexPath = self.clViewProductImages.indexPathForItem(at: visiblePoint) {
//            self.pageControl.currentPage = visibleIndexPath.row
//        }
//    }
}

//MARK: - API CALL -

extension ProductDetailVC {
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
                            }
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        if defaults.object(forKey: kAuthToken) != nil {
                            GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                        }
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
    
    //PRODUCT DETAIL API
    func callProductDetailAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let strURL = Constants.URLS.PRODUCT_DETAIL + "/" + "\(self.strProductID)"
        
        var params: [String:Any] = [:]
        if defaults.object(forKey: kAuthToken) != nil {
            params["user_id"] = objUserDetail._id
        }
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(strURL, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            strongSelf.objProductDetail = ProductObject.init(payload)
                            //strongSelf.setupData()
                        }
                        
                        if let row = GlobalData.shared.arrCartList.firstIndex(where: {$0.product_id == strongSelf.objProductDetail._id}) {
                            debugPrint(row)
                            strongSelf.btnAddCart.setTitle("GO TO CART", for: [])
                        } else {
                            strongSelf.btnAddCart.setTitle("ADD TO CART", for: [])
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


    // similar-product -->
    func callSubProductCategoryAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

        let strURL = Constants.URLS.SIMILAR_PRODUCT

        var params: [String:Any] = [:]
        if defaults.object(forKey: kAuthToken) != nil {
            params["productId"] = self.productID
        }

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        AFWrapper.shared.requestPOSTURL(strURL, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }

            GlobalData.shared.hideProgress()
            strongSelf.similarProductList = []
            strongSelf.clViewSimilarProduct.reloadData()

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["statusCode"] as? Int ?? 0 == successCodeNew {
                        if let payload = response["data"] as? [Dictionary<String, Any>] {
                            for i in payload{
//                                strongSelf.objProductDetail = ProductObject.init(payload)
                                strongSelf.similarProductList.append(i as NSDictionary)
                            }
                            strongSelf.clViewSimilarProduct.reloadData()
                            //strongSelf.setupData()
                        }

//                        if let row = GlobalData.shared.arrCartList.firstIndex(where: {$0.product_id == strongSelf.objProductDetail._id}) {
//                            debugPrint(row)
//                            strongSelf.btnAddCart.setTitle("GO TO CART", for: [])
//                        } else {
//                            strongSelf.btnAddCart.setTitle("ADD TO CART", for: [])
//                        }
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
    
    //SUB PRODUCT CATEGORY LIST
//    func callSubProductCategoryAPI() {
//        if GlobalData.shared.checkInternet() == false {
//            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
//            return
//        }
//
//        let strURL = Constants.URLS.GET_SUBPRODUCT_CATEGORY + "/" + "\(self.objProductDetail.category)"
//
//        AFWrapper.shared.requestGETURL(strURL) { (JSONResponse) in
//
//            if JSONResponse != JSON.null {
//                if let response = JSONResponse.rawValue as? [String : Any] {
//                    if response["status"] as? Int ?? 0 == successCode {
//
//                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
//
//                            var arrSubProductCategory: [SubProductCategoryObject] = []
//
//                            for i in 0..<payloadData.count {
//                                let objSubProduct = SubProductCategoryObject.init(payloadData[i])
//                                arrSubProductCategory.append(objSubProduct)
//                            }
//
//                            let objSubProductCategory = arrSubProductCategory.filter{ $0._id == self.objProductDetail.subcategory}.first
//
//                            self.lblProductCategory.text = objSubProductCategory?.name
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
//        } failure: { (error) in
//            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
//        }
//    }
    
    //ADD TO CART API
    func callAddtoCartAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

//        {
//            "shop_id": "6374c3f49e8d0f27d4d7a141",
//            "qty": "7",
//            "product_id": "638d995f16272b64c4ec9ab1",
//            "purchase_type": "fdsg",
//            "product_color": "red"
//        }
        
        var params: [String:Any] = [:]
        params["product_id"] = self.dicProductData["_id"] ?? ""
        params["shop_id"] = "6374c3f49e8d0f27d4d7a141"//self.objProductDetail.shop
        params["qty"] = "1"
        params["purchase_type"] = self.strPurchaseType
        params["product_color"] = self.strSelColorName
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.CART, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        
                        strongSelf.btnAddCart.isUserInteractionEnabled = true
                        strongSelf.btnAddCart.setTitle("GO TO CART", for: [])
                        
                        NotificationCenter.default.post(name: Notification.Name(kUpdateCartList), object: nil)
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnAddCart.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnAddCart.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnAddCart.isUserInteractionEnabled = true
        }
    }
    
    //DELETE ALL CART API
    func callDeleteCartAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        AFWrapper.shared.requestDELETEURL(Constants.URLS.CART) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
                        
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        GlobalData.shared.arrCartList = []
                        
                        strongSelf.btnAddCart.isUserInteractionEnabled = false
                        strongSelf.callAddtoCartAPI()
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
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //ADD FAVOURITE PRODUCT API
    func callAddFavouriteProductAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["productId"] = strProductID//self.objProductDetail._id
        params["type"] = true
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.FAVOURITE_PRODUCT, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            strongSelf.objProductDetail = ProductObject.init(payload)
                            
                            if strongSelf.objProductDetail.isfavourite == false {
                                strongSelf.btnFavourite.isSelected = false
                            } else {
                                strongSelf.btnFavourite.isSelected = true
                            }
                            
                            NotificationCenter.default.post(name: Notification.Name(kUpdateWishList), object: nil)
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
    
    //DELETE FAVOURITE PRODUCT API
    func callDeleteFavouriteProductAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let strURL = Constants.URLS.FAVOURITE_PRODUCT + "/" + "\(self.objProductDetail.isfavouriteId)"
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestDELETEURL(strURL) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        strongSelf.objProductDetail.isfavourite = false
                        strongSelf.objProductDetail.isfavouriteId = ""
                        
                        if strongSelf.objProductDetail.isfavourite == false {
                            strongSelf.btnFavourite.isSelected = false
                        } else {
                            strongSelf.btnFavourite.isSelected = true
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name(kUpdateWishList), object: nil)
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



    func callProductCategoryListAPI() {

        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.VENDOR_SHOP_ADDED_LIST, parameters: ["productId":strProductID]) { [self] responce in
            GlobalData.shared.hideProgress()
            self.dicProductData = NSDictionary()
            switch responce {
            case .success(let jsondata):
                let isSuccess:Int = jsondata["statusCode"] as! Int
                if(isSuccess == 200){

                    if let payloadData = jsondata["data"] as? NSDictionary {
                        if let docsArray = payloadData["docs"] as? NSArray {
                           // self.arrSubProductCategory = docsArray as! [NSDictionary]
                            self.dicProductData = docsArray[0] as! NSDictionary
                            self.setupData()
                        }
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
