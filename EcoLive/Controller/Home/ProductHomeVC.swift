//
//  ProductHomeVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 30/06/21.
//

import UIKit
import AdvancedPageControl

class ProductHomeVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnBackTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewMen: UIView!
    @IBOutlet weak var viewWomen: UIView!
    @IBOutlet weak var viewKids: UIView!
    
    @IBOutlet weak var clViewPromotion: UICollectionView!
    @IBOutlet var pageControl: AdvancedPageControlView!
    
    @IBOutlet weak var clViewNear: UICollectionView!
    @IBOutlet weak var clViewNearHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var clView: UICollectionView!
    
    var arrPromotion: [UIImage] = [#imageLiteral(resourceName: "temp8"), #imageLiteral(resourceName: "temp4"), #imageLiteral(resourceName: "temp8")]
    var nearProductCount: Int = 11
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            if self.nearProductCount < 6 {
                self.clViewNearHeightConstraint.constant = 160
            } else {
                self.clViewNearHeightConstraint.constant = 328
            }
        }
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        if UIDevice.current.hasNotch {
            self.btnBackTopConstraint.constant = 35
        } else {
            self.btnBackTopConstraint.constant = 20
        }
        
        self.pageControl.drawer = ExtendedDotDrawer(numberOfPages: self.arrPromotion.count,
                                                    height: 5.0,
                                                    width: 5.0,
                                                    space: 12.0,
                                                    indicatorColor: UIColor.white,
                                                    dotsColor: UIColor.init(hex: 0x707070),
                                                    isBordered: false,
                                                    borderWidth: 0.0,
                                                    indicatorBorderColor: .clear,
                                                    indicatorBorderWidth: 0.0)
        
        DispatchQueue.main.async {
            self.viewSearch.layer.cornerRadius = self.viewSearch.frame.height / 2.0
            
            self.viewMen.layer.masksToBounds = false
            self.viewMen.layer.shadowRadius = 1
            self.viewMen.layer.shadowOpacity = 0.6
            self.viewMen.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.6).cgColor
            self.viewMen.layer.shadowOffset = CGSize.zero //CGSize(width: 1, height: 1)
            
            self.viewWomen.layer.masksToBounds = false
            self.viewWomen.layer.shadowRadius = 1
            self.viewWomen.layer.shadowOpacity = 0.6
            self.viewWomen.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.6).cgColor
            self.viewWomen.layer.shadowOffset = CGSize.zero //CGSize(width: 1, height: 1)
            
            self.viewKids.layer.masksToBounds = false
            self.viewKids.layer.shadowRadius = 1
            self.viewKids.layer.shadowOpacity = 0.6
            self.viewKids.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.6).cgColor
            self.viewKids.layer.shadowOffset = CGSize.zero //CGSize(width: 1, height: 1)
        }
        
        self.lblOffer.text = "Up to min 50% off"
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCartClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.cartStoryBoard().instantiateViewController(withIdentifier: "CartVC") as! CartVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
        }
    }
    
    @IBAction func btnMicrophoneClick(_ sender: UIButton) {
        debugPrint("Microphone Click")
    }
    
    @IBAction func btnMenProductClick(_ sender: UIButton) {
        debugPrint("Men Click")
    }
    
    @IBAction func btnWomenProductClick(_ sender: UIButton) {
        debugPrint("Women Click")
    }
    
    @IBAction func btnKidsProductClick(_ sender: UIButton) {
        debugPrint("Kids Click")
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension ProductHomeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UICOLLECTIONVIEW DATASOURCE & DELEGATE METHOD -

extension ProductHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clViewPromotion {
            return self.arrPromotion.count
        } else if collectionView == self.clViewNear {
            return self.nearProductCount
        } else {
            return 8
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.clViewPromotion {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCell", for: indexPath as IndexPath) as! PromotionCell
            
            cell.imgPromotion.image = self.arrPromotion[indexPath.item]
            
            return cell
        } else if collectionView == self.clViewNear {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearProductCell", for: indexPath as IndexPath) as! NearProductCell
            
            cell.imgProduct.image = UIImage.init(named: "temp5")
            cell.lblProductTitle.text = "Watch"
            cell.lblShopLive.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop live" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "$ 520", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopLive.font.pointSize)!, strSecondColor: Constants.Color.THEME_YELLOW)
            cell.lblShopOnline.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop online" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "$ 420", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: cell.lblShopOnline.font.pointSize)!, strSecondColor: UIColor.init(hex: 0xFF0000))
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferProductCell", for: indexPath as IndexPath) as! OfferProductCell
            
            if indexPath.item == 0 {
                cell.imgThumbnail.image = UIImage.init(named: "temp9")
                cell.lblTitle.text = "Men's formal shirts"
            } else if indexPath.item == 1 {
                cell.imgThumbnail.image = UIImage.init(named: "temp10")
                cell.lblTitle.text = "Women' jewellery"
            } else if indexPath.item == 2 {
                cell.imgThumbnail.image = UIImage.init(named: "temp11")
                cell.lblTitle.text = "kid's sneakers"
            } else {
                cell.imgThumbnail.image = UIImage.init(named: "temp5")
                cell.lblTitle.text = "Test"
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.clViewPromotion {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        else if collectionView == self.clViewNear {
            let noOfCellsInRow = 3
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            
            return CGSize(width: size, height: 160)
        }
        else {
            let width = (self.clView.frame.size.width - 10) / 2
            let height = self.clView.frame.size.height
            
            return CGSize(width: width, height: height)
        }
    }
}

//MARK: - UISCROLLVIEW DELEGATE -

extension ProductHomeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.clViewPromotion {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width

            self.pageControl.setPage(Int(round(offSet / width)))
            self.pageControl.setPageOffset(offSet / width)
        } else {
            debugPrint("collectionview")
        }
    }
}
