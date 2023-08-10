//
//  ShopListInfoViewController.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 11/07/22.
//

import Foundation
import UIKit
import SwiftyJSON

class ShopListInfoViewController: BaseVC {
    
    static func getObject()-> ShopListInfoViewController {
        let storyboard = UIStoryboard(name: "ShopOwner", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShopListInfoViewController") as? ShopListInfoViewController
        if let vc = vc {
            return vc
        }
        return ShopListInfoViewController()
    }
    //MARK: - PROPERTIES & OUTLETS
    
    @IBOutlet weak var collectionShopList: UICollectionView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageUserProfile: UIImageView!
    

    //MARK: - PROPERTY OBESEVERR
    
    var arrShopList: [ShopObject] = [ShopObject]() {
        didSet{
            collectionShopList.reloadData()
        }
    }
    var registrationType:String = ""
 
    //MARK: - VIEWCONTROLLER LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callGetShopListAPI()
        collectionShopList.delegate = self
        collectionShopList.dataSource = self
        
        if defaults.object(forKey: kAuthToken) != nil {
            labelName.text = objUserDetail.firstName + " " + objUserDetail.lastName
            imageUserProfile.sd_setImage(with: URL(string: objUserDetail.profileImage), placeholderImage: UIImage(named: "user_default"))
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - SETUP VIEW
    //MARK: - HELPER
    //MARK: - ACTIONS

    @IBAction func btnTaxiTabAction(_ sender: UIButton) {
        self.switchTaxiStorybord()
    }

    func switchTaxiStorybord(){
        let controller = GlobalData.taxiTabbarStoryBoard().instantiateViewController(withIdentifier: "TaxiTabbarVC") as! TaxiTabbarVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func actionAddStore(_ sender: UIButton) {
        let view = SoleProprietorsRegistrationVC.getObject()
        view.typeofRegistration = self.registrationType
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func actionMenuClick(_ sender: UIButton) {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func actionUserClick(_ sender: UIButton) {
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.hideMenu(animated: true, completion:nil)
    }
    
    
    @IBAction func actionRiderClick(_ sender: UIButton) {
        
        if defaults.object(forKey: kAuthToken) != nil {
            if (objUserDetail.isRider) {
                let controller = RiderHomeViewController.getObject()
                self.push(controller: controller)
            } else {
                let controller = VehicleCategoryViewController.getObject()
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .crossDissolve
                controller.buttonSubmitCallBack = { [weak self] (vehicleType) in
                    let controller = VehicleInformationVC.getObject()
                    self!.push(controller: controller)
                }
                self.present(controller, animated: true)
            }
        } else {
                let controller = LoginVC.getObject()
                let navController = UINavigationController.init(rootViewController: controller)
                appDelegate.drawerController.contentViewController = navController
        }
    }
    
    @IBAction func btnSendMoneyClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "SendMoneyFirstStepVC") as! SendMoneyFirstStepVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.guestUserLogin()
        }
    }
    
    
    @IBAction func btnAddMoneyClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.addMoneyStoryBoard().instantiateViewController(withIdentifier: "AddMoneyVC") as! AddMoneyVC
            controller.isFromCartPayment = false
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.guestUserLogin()
        }
    }
    
    @IBAction func btnMakepaymentClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "SendMoneyToBankVC") as! SendMoneyToBankVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.guestUserLogin()
        }
    }
    
    @IBAction func btnMessagesClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.guestUserLogin()
        }
    }
    
    
    func guestUserLogin() {
        let controller = LoginVC.getObject()
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
    }
    
    @IBAction func btnCallFriendsClick(_ sender: UIButton) {
        debugPrint("Call Friends")
        
        //TEMPORARY
        dummyAction()
        return
        
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.friendStoryBoard().instantiateViewController(withIdentifier: "FriendListVC") as! FriendListVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.guestUserLogin()
        }
    }
    
    func dummyAction() {
        
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "ShopReviewAdd Screen", style: .default , handler:{ (UIAlertAction)in
            let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopReviewAdd") as! ShopReviewAdd
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "RideDetails Screen", style: .default , handler:{ (UIAlertAction)in
            let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RideDetails") as! RideDetails
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "RiderReview Screen", style: .default , handler:{ (UIAlertAction)in
            let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RiderReview") as! RiderReview
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "CustomerToRiderReviewVC Screen", style: .default , handler:{ (UIAlertAction)in
            let controller = GlobalData.ratingStoryBoard().instantiateViewController(withIdentifier: "CustomerToRiderReviewVC") as! CustomerToRiderReviewVC
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "RiderToCustomerReviewVC Screen", style: .default , handler:{ (UIAlertAction)in
            let controller = GlobalData.ratingStoryBoard().instantiateViewController(withIdentifier: "RiderToCustomerReviewVC") as! RiderToCustomerReviewVC
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "CustomerToShopReviewVC Screen", style: .default , handler:{ (UIAlertAction)in
            let controller = GlobalData.ratingStoryBoard().instantiateViewController(withIdentifier: "CustomerToShopReviewVC") as! CustomerToShopReviewVC
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "CustomerToProductReviewVC Screen", style: .default , handler:{ (UIAlertAction)in
            let controller = GlobalData.ratingStoryBoard().instantiateViewController(withIdentifier: "CustomerToProductReviewVC") as! CustomerToProductReviewVC
            self.navigationController?.pushViewController(controller, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "AddComment Screen", style: .default , handler:{ (UIAlertAction)in
            let controller = GlobalData.ratingStoryBoard().instantiateViewController(withIdentifier: "AddComment") as! AddComment
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler:{ (UIAlertAction)in
            self.dismiss()
        }))
        
        
        //uncomment for iPad Support
        alert.popoverPresentationController?.sourceView = self.view
        
        present(alert, animated: true, completion: nil)
        
//        self.present(alert, animated: true, completion: {
//            print("completion block")
//        })
    }
    
    
    //MARK: - API CALL

    
    
}

//MARK: - UICOLLECTIONVIEW DATASOURSE & DELEGATES METHOD

extension ShopListInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrShopList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopListCollectionCell", for: indexPath as IndexPath) as! ShopListCollectionCell
        cell.cellModel = arrShopList[indexPath.row]
        cell.buttonRemoveShop.addTarget(self, action: #selector(handleRegister(_:)), for: .touchUpInside)
        cell.buttonRemoveShop.tag = indexPath.row
        return cell
    }

    @IBAction func handleRegister(_ sender: UIButton){
        print(sender.tag)
        let viewcontroller = DeleteShopVC.getObject()
        viewcontroller.modalPresentationStyle = .overCurrentContext
        viewcontroller.modalTransitionStyle = .crossDissolve
        present(viewcontroller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 1.8
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let view = ShopProductListVC.getObject()
        view.myShop = arrShopList[indexPath.row]
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}

// MARK: - API CAll
extension ShopListInfoViewController {
    
    func callGetShopListAPI(){
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.GET_VENDER_SHOP_LIST, parameters: [:]) { responce in
            GlobalData.shared.hideProgress()
            switch responce {
            case .success(let jsondata):
                print(jsondata)
                if let payloadData = jsondata["data"] as? [Dictionary<String, Any>]{
                    var arrTemp = [ShopObject]()
                    for i in 0..<payloadData.count {
                        let objVehicle = ShopObject.init(payloadData[i])
                        arrTemp.append(objVehicle)
                    }
                    self.arrShopList = arrTemp
                    self.registrationType = arrTemp[0].shopType ?? ""
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
 

