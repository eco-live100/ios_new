//
//  HomeVC+CollectionView.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 16/06/22.
//

import Foundation
import SDWebImage


//MARK: - UICOLLECTIONVIEW DATASOURSE & DELEGATES METHOD -

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clView {
            return arrSubProductCategory.count //3//self.arrNearProduct.count
        } else {
//            return 5//self.arrProductCategory.count
            return arrayofCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.clView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductCell", for: indexPath as IndexPath) as! HomeProductCell
            
            let objDict = self.arrSubProductCategory[indexPath.item]
            let image = (((objDict["file"] as! NSArray)[0] as! NSDictionary)["name"] as? String ?? "")
            let productData = (objDict["productData"] as! NSDictionary)

            cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProduct.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: "ic_no_image"))
//
            cell.lblProductTitle.text = productData["productName"] as? String ?? ""
            cell.lblFreeShipping.text = "Free shipping"
//
            cell.lblShopLive.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop live" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "$\(productData["priceLive"] as? String ?? "")", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize)!, strSecondColor: Constants.Color.THEME_YELLOW)
            cell.lblShopOnline.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop online" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "$\(productData["price"] as? String ?? "")", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize)!, strSecondColor: UIColor.init(hex: 0xFF0000))
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as! CategoryCell
            
//            let objProduct = self.arrProductCategory[indexPath.item]
//
//            cell.imgCategory.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
//            cell.imgCategory.sd_setImage(with: URL(string: objProduct.image), placeholderImage: UIImage.init(named: "ic_no_image"))
//
//            cell.lblProductTitle.text = objProduct.name
            cell.imgCategory.image = UIImage(named: arrayofCategory[indexPath.row])
            cell.lblProductTitle.text = arrayofCategory[indexPath.row]
//            cell.lblProductTitle.text = "Category \(indexPath.row)"

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView == self.clView {
//            let objDict = self.arrNearProduct[indexPath.item]
            let objDict = self.arrSubProductCategory[indexPath.item]

            let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            controller.strProductID = objDict["_id"] as? String ?? ""
            self.navigationController?.pushViewController(controller, animated: true)


        } else {
//            let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "ProductCategoryVC") as! ProductCategoryVC
////            controller.objCategory = self.arrProductCategory[indexPath.item]
//            self.navigationController?.pushViewController(controller, animated: true)
//            if indexPath.row == 0{
//                return
//            }

            let controller = FoodAndGroceryCategoryVC.getObject()
            switch indexPath.row {
            case 0:
                //controller.vcType = .taxi
                self.switchTaxiStorybord()
                return

            case 1:
                controller.vcType = .food
            case 2:
                let vc = MyGroceryHome.getObject()
                self.navigationController?.pushViewController(vc, animated: true)
                return
//                controller.vcType = .grocery
            case 3:
//                controller.vcType = .pharmacy

//                let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "PharmacyVC") as! PharmacyVC
                let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "PharmacyMenuVC") as! PharmacyMenuVC
                self.navigationController?.pushViewController(controller, animated: true)
                return 

            case 4:
                controller.vcType = .retail
            default:
                print("")
            }

            self.navigationController?.pushViewController(controller, animated: true)

//                let controller = ShopListInfoViewController.getObject()
//                self.navigationController?.pushViewController(controller, animated: true)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.clView {
            let noOfCellsInRow = 1.2
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: 420)
        } else {
            let noOfCellsInRow = 3.2
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            
            return CGSize(width: size, height: 120)
        }
    }
}
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }

