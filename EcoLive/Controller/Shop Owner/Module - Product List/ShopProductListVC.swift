//
//  ShopProductListVC.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 21/07/22.
//

import UIKit
import SDWebImage

class ShopProductListVC: UIViewController {
    
    static func getObject()-> ShopProductListVC {
        let storyboard = UIStoryboard(name: "ShopOwner", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShopProductListVC") as? ShopProductListVC
        if let vc = vc {
            return vc
        }
        return ShopProductListVC()
    }
    
    //MARK: - PROPERTIES & OUTLETS
    @IBOutlet weak var navigationHeaderView: UIView!
    @IBOutlet weak var collectionProductList: UICollectionView!
    @IBOutlet weak var labelNoDataFound: UILabel!

    var myShop : ShopObject!

    //api
    var arrSubProductCategory: [NSDictionary] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationHeaderView.roundCorners(corners: [.bottomLeft , .bottomRight ], radius: 15.0)
        // Do any additional setup after loading the view.
        collectionProductList.delegate = self
        collectionProductList.dataSource = self

    }

    override func viewDidAppear(_ animated: Bool) {
        callProductCategoryListAPI()

    }

    //MARK: - ACTIONS
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAddProductClick(_ sender: UIButton) {
        if #available(iOS 14.0, *) {
            let view = AddProductEcom.getObject()
//            view.selectedVendorShop = ""
//            view.myShop = myShop
            view.myShop = myShop

            self.navigationController?.pushViewController(view, animated: true)
        } else {
            
        }
    }
}

//MARK: - UICOLLECTIONVIEW DATASOURSE & DELEGATES METHOD -

extension ShopProductListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSubProductCategory.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCell", for: indexPath as IndexPath) as! ProductCategoryCell

        if let objProduct = self.arrSubProductCategory[indexPath.item] as? NSDictionary {

            if let image = ((objProduct["file"] as? NSArray)?[0] as? [String : Any])?["name"] as? String {
                cell.imgCategory.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgCategory.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: "ic_no_image"))
            }

            if let productData = objProduct["productData"] as? NSDictionary {
                cell.lblCatTitle.text = productData["productName"] as? String ?? ""
//                cell.lblCatDescription.text = objProduct[""]
            }

        }





        return cell
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

        if Constants.DeviceType.IS_IPHONE_5 {
            return CGSize(width: size, height: 220)
        } else if Constants.DeviceType.IS_IPHONE_6P {
            return CGSize(width: size, height: 225)
        } else if Constants.DeviceType.IS_IPHONE_X {
            return CGSize(width: size, height: 225)
        } else if Constants.DeviceType.IS_IPHONE_11_PRO_MAX {
            return CGSize(width: size, height: 230)
        } else if Constants.DeviceType.IS_IPHONE_12_PRO {
            return CGSize(width: size, height: 225)
        } else if Constants.DeviceType.IS_IPHONE_12_PRO_MAX {
            return CGSize(width: size, height: 235)
        } else {
            return CGSize(width: size, height: 220)
        }
    }
}


//MARK: - API CALL -

extension ShopProductListVC {
    //SUB PRODUCT CATEGORY LIST
    func callProductCategoryListAPI() {

        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

//        let params = ["shopCategoryId" : myShop._id
//        ] as! [String : Any]
        let params = ["vendorShopId" : myShop._id
        ] as! [String : Any]


        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.VENDOR_SHOP_ADDED_LIST, parameters: params) { responce in
            GlobalData.shared.hideProgress()
            self.arrSubProductCategory = []
            switch responce {
            case .success(let jsondata):
                let isSuccess:Int = jsondata["statusCode"] as! Int
                if(isSuccess == 200){

                    if let payloadData = jsondata["data"] as? NSDictionary {
                        if let docsArray = payloadData["docs"] as? NSArray {
                            self.arrSubProductCategory = docsArray as! [NSDictionary]
//                            for i in 0..<docsArray.count {
//                                let objSubProduct = StoreProductObject.init(docsArray[i] as! [String : Any])
//                                self.arrSubProductCategory.append(objSubProduct)
//                            }
                        }

                        GlobalData.shared.reloadCollectionView(collectionView: self.collectionProductList)

                        if self.arrSubProductCategory.count > 0 {
                            self.labelNoDataFound.isHidden = true
                        }else{
                            self.labelNoDataFound.isHidden = false
                        }
                    }




//                    do {
//                        let jsonNew = try JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
//
//                        print(jsonNew)
//
//
//
//                    } catch let error {
//                        print(error)
//                        print(error.localizedDescription)
//                    }
                }

            case .failed(let errorMessage):
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            }
        }



//        let strURL = Constants.URLS.VENDOR_SHOP_ADDED_LIST + "/" + "\(self.objCategory._id)"
//
//        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
//
//        AFWrapper.shared.requestGETURL(strURL) { [weak self] (JSONResponse) in
//            guard let strongSelf = self else { return }
//
//            GlobalData.shared.hideProgress()
//
//            if JSONResponse != JSON.null {
//                if let response = JSONResponse.rawValue as? [String : Any] {
//                    if response["status"] as? Int ?? 0 == successCode {
//
//                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
//                            for i in 0..<payloadData.count {
//                                let objSubProduct = SubProductCategoryObject.init(payloadData[i])
//                                strongSelf.arrSubProductCategory.append(objSubProduct)
//                            }
//
//                            GlobalData.shared.reloadCollectionView(collectionView: strongSelf.clView)
//                        }
//                    }
//                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
//                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
//                    }else {
//                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
//                    }
//                }
//            }
//        } failure: { (error) in
//            GlobalData.shared.hideProgress()
//            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
//        }
    }
}
