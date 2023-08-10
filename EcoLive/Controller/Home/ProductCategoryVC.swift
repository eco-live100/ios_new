//
//  ProductCategoryVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 16/06/21.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ProductCategoryVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var clView: UICollectionView!
    
    var arrSubProductCategory: [SubProductCategoryObject] = []
    var objCategory: ProductCategoryObject!
    
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
        self.lblTitle.text = self.objCategory.name

        self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
                
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
        }
        
        self.callSubProductCategoryAPI()
    }
    
    //MARK: - HELPER -
    
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
}

//MARK: - UICOLLECTIONVIEW DATASOURSE & DELEGATES METHOD -

extension ProductCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSubProductCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCell", for: indexPath as IndexPath) as! ProductCategoryCell
        
        let objProduct = self.arrSubProductCategory[indexPath.item]
        
        cell.imgCategory.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgCategory.sd_setImage(with: URL(string: objProduct.image), placeholderImage: UIImage.init(named: "ic_no_image"))
        
        cell.lblCatTitle.text = objProduct.name
        cell.lblCatDescription.text = objProduct.descriptionn
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "SubProductCategoryVC") as! SubProductCategoryVC
        controller.objSubCategory = self.arrSubProductCategory[indexPath.item]
        self.navigationController?.pushViewController(controller, animated: true)
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

extension ProductCategoryVC {
    //SUB PRODUCT CATEGORY LIST
    func callSubProductCategoryAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let strURL = Constants.URLS.GET_SUBPRODUCT_CATEGORY + "/" + "\(self.objCategory._id)"
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestGETURL(strURL) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            for i in 0..<payloadData.count {
                                let objSubProduct = SubProductCategoryObject.init(payloadData[i])
                                strongSelf.arrSubProductCategory.append(objSubProduct)
                            }
                            
                            GlobalData.shared.reloadCollectionView(collectionView: strongSelf.clView)
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }else {
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
