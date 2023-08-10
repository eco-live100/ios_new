//
//  HomeVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 08/06/21.
//

import UIKit
import SideMenuSwift
import DropDown
import CoreLocation
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import SDWebImage
import PushKit
import QRCodeReader

struct MarkerStruct {
    let name: String
    let lat: CLLocationDegrees
    let long: CLLocationDegrees
}

class HomeVC: BaseVC, GMSMapViewDelegate {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewLoginSignUP: UIView!
    @IBOutlet weak var btnLoginSignup: UIButton!
    @IBOutlet weak var btnMenuTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblSelectedLocation: UILabel!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var txtCategory: UITextField!
    
    @IBOutlet weak var lblShopLiveTitle: UILabel!
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var clViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblNoNearProduct: UILabel!
    @IBOutlet weak var viewMoreProduct: UIView!
    @IBOutlet weak var clViewCategory: UICollectionView!
    @IBOutlet weak var clViewCategoryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewDeliveryJob: UIView!
    @IBOutlet weak var lblDeliveryJob: UILabel!
    
    @IBOutlet weak var viewSearchLocationBG: UIView!
    @IBOutlet weak var viewSearchLocation: UIView!
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblNearbyName1: UILabel!
    @IBOutlet weak var lblNearbyAddress1: UILabel!
    @IBOutlet weak var lblNearbyName2: UILabel!
    @IBOutlet weak var lblNearbyAddress2: UILabel!
    @IBOutlet weak var lblRecentName1: UILabel!
    @IBOutlet weak var lblRecentAddress1: UILabel!
    @IBOutlet weak var lblRecentName2: UILabel!
    @IBOutlet weak var lblRecentAddress2: UILabel!
    @IBOutlet weak var btnDoneLocation: UIButton!
    
    
    @IBOutlet weak var viewRider: UIView!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewShop: UIView!
    
    var categoryDropDown = DropDown()
    var selectedShopCategory = ""
    
    var userLocation: CLLocationCoordinate2D!
    var zoomLevel: Float = 14.5
    
    var arrShopCategory: [ShopCategoryObject] = []
    var arrNearProduct: [NearByProductObject] = []
    var arrProductCategory: [ProductCategoryObject] = []
    var arrVehicleList: [VehicleObject] = []
    var arrNearRider: [NearRiderObject] = []
    var arrayofCategory: [String] = []

    //APi
    var arrSubProductCategory: [NSDictionary] = []


    // Map
    let markers = [
        MarkerStruct(name: "Food Hut 1", lat: 28.4747789, long: 77.0419619),
        MarkerStruct(name: "Foot Hut 2", lat: 28.4747789, long: 77.0419619),
        MarkerStruct(name: "Foot Hut 3", lat: 28.47278, long: 77.0393223),
        MarkerStruct(name: "Foot Hut 4", lat: 28.4726242, long: 77.0392608),
    ]
    var mapMarkers : [GMSMarker] = []
    var timer : Timer? = nil


    
    var isDisplayAlert:Bool = false
    
    lazy var readerVC: QRCodeReaderViewController = {
      let builder = QRCodeReaderViewControllerBuilder {
          $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
          // Configure the view controller (optional) [.qr, .ean8, .ean13, .pdf417]
          $0.showTorchButton         = true
          $0.showSwitchCameraButton  = true
          $0.showCancelButton        = true
          $0.showOverlayView         = true
          $0.preferredStatusBarStyle = .lightContent
          $0.rectOfInterest          = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
          
          $0.reader.stopScanningWhenCodeIsFound = false
      }
      
      return QRCodeReaderViewController(builder: builder)
    }()
    
    var tempSelectedLocString:String = ""
    var tempLocation: CLLocationCoordinate2D!
    var selectedLocation: CLLocationCoordinate2D!
    
    var isFromGoolePlace:Bool = false
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
        arrayofCategory.append("Get a ride")
        arrayofCategory.append("Food")
        arrayofCategory.append("Grocery")
        arrayofCategory.append("Pharmacy")
        arrayofCategory.append("Retail")
      
        if defaults.object(forKey: kAuthToken) != nil {
            self.getProfileDetails()
        }

//        let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "PHOrderVC") as! PHOrderVC
//        self.navigationController?.pushViewController(controller, animated: true)


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        
        if defaults.object(forKey: kAuthToken) != nil {
            self.viewLoginSignUP.isHidden = true
        } else {
            self.viewLoginSignUP.isHidden = false
        }
        
        
        self.callGetShopCategoryAPI()
//        self.callCartListAPI()
        
        if objUserDetail.userType == "rider" {
            if GlobalData.shared.checkLocationStatus() == true {
                if self.userLocation != nil {
                    self.callGetVehicleInfoAPI()
                }
            }
        }
        
        if GlobalData.shared.checkLocationStatus() == true {
            if self.isFromGoolePlace == false {
                if self.userLocation != nil {
                    self.callGetNearByProductAPI()
                    self.callGetNearRiderAPI()
                }
            }
            self.isFromGoolePlace = false
        }
        self.callProductCategoryListAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            if self.arrNearProduct.count < 6 {
               // self.clViewHeightConstraint.constant = 500
            } else {
//                self.clViewHeightConstraint.constant = 500
            }
            
            if self.arrProductCategory.count < 6 {
                self.clViewCategoryHeightConstraint.constant = 160
            } else {
                self.clViewCategoryHeightConstraint.constant = 400
            }
        }
    }
    
    //MARK: - SETUP VIEW -

    func setMapLocation(){

        for marker in markers {
            let position = CLLocationCoordinate2D(latitude: marker.lat, longitude: marker.long)
            let locationmarker = GMSMarker(position: position)
            locationmarker.map = mapView
            let markerImage = UIImage(named: "carRed")
            let markerView = UIImageView(image: markerImage)
//            markerView.tintColor = UIColor.red
            locationmarker.iconView = markerView
            mapMarkers.append(locationmarker)
        }

        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector:  #selector(self.selectRandomMarker), userInfo: nil, repeats: true)

    }

    //Selecting random marker
    @objc func selectRandomMarker(){
        let randomIndex = arc4random_uniform(UInt32(self.mapMarkers.count))
        //        self.mapView?.selectedMarker = self.mapMarkers[Int(randomIndex)]

        let camera = GMSCameraPosition.camera(withLatitude: self.mapMarkers[Int(randomIndex)].position.latitude, longitude: self.mapMarkers[Int(randomIndex)].position.longitude, zoom: zoomLevel)

        self.mapView.camera = camera
        self.mapView?.animate(to: camera)

//        self.mapView?.animate(toLocation: (self.mapMarkers[Int(randomIndex)].position))
    }
    
    func setUpUserRoleButton() {
        
//        if !objUserDetail.isEmailVerified {
//            showAlert(message: "Please verify your mail address") { (action) in
//                let viewController = OTPViewController.getObject()
//                viewController.isFromEmailVerify = true
//                self.push(controller: viewController)
//            } cancelAction: { (cancel) in
//                
//            }
//        }
        
        if objUserDetail.isRiderVerified{
            viewRider.isHidden = true
            viewShop.isHidden = false
            viewUser.isHidden = false
        } else if objUserDetail.isVendorVerified {
            viewRider.isHidden = false
            viewShop.isHidden = true
            viewUser.isHidden = false
        } else {
            viewRider.isHidden = false
            viewShop.isHidden = false
            viewUser.isHidden = true
        }
    }
    
    func setupViewDetail() {
        GlobalData.shared.isPresentedChatView = false
        
        if UIDevice.current.hasNotch {
            self.btnMenuTopConstraint.constant = 35
        } else {
            self.btnMenuTopConstraint.constant = 20
        }
        
        self.viewSearchLocation.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        self.viewSearchLocationBG.isHidden = true
        
        DispatchQueue.main.async {
            self.viewSearch.layer.cornerRadius = self.viewSearch.frame.height / 2.0
            self.viewSearchBar.layer.borderColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewSearchBar.layer.borderWidth = 0.3
            self.viewSearchBar.layer.masksToBounds = false
            self.viewSearchBar.layer.shadowRadius = 1
            self.viewSearchBar.layer.shadowOpacity = 0.6
            self.viewSearchBar.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewSearchBar.layer.shadowOffset = CGSize(width: 0, height: 2)
            
            self.btnDoneLocation.layer.cornerRadius = self.btnDoneLocation.frame.height / 2.0
            self.btnDoneLocation.createButtonShadow()
            
            self.searchBar.setupSearchBar(background: .clear, inputText: Constants.Color.THEME_BLACK, placeholderText: Constants.Color.SEARCHBAR_PLACEHOLDER, image: Constants.Color.SEARCHBAR_IMAGE)
            
            let textField = self.searchBar.value(forKey: "searchField") as? UITextField
            textField?.clearButtonMode = .never
//            if #available(iOS 13.0, *) {
//                self.searchBar.searchTextField.clearButtonMode = .never
//            } else {
//                // Fallback on earlier versions
//            }
            self.searchBar.isUserInteractionEnabled = false
            self.viewMoreProduct.createButtonShadow()
        }
        
//        self.viewDeliveryJob.isHidden = true

        mapView?.delegate = self

        self.initializeTheLocationManager()
        self.mapView.settings.compassButton = true
        self.mapView.isMyLocationEnabled = true
        
        self.mapView.settings.myLocationButton = true
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: (self.vwBottom.frame.origin.y - 30), right: 5)
        
//        self.clView.isHidden = true
        self.lblNoNearProduct.isHidden = true
        
        self.lblShopLiveTitle.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Shop ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: 17)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "Live ", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: 17)!, strSecondColor: UIColor.red, strThree: ": 1 hour deliverable",strThreeFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!,strThreeColor: Constants.Color.THEME_BLACK)

        self.lblNearbyName1.text = "ISCKON ELEGANCE"
        self.lblNearbyAddress1.text = "piazza del duamo, 80777 Firenze fi, italy"
        self.lblNearbyName2.text = "OLIVO - Bhatia"
        self.lblNearbyAddress2.text = "Dalmial, kuwait"
        self.lblRecentName1.text = "RIVERA"
        self.lblRecentAddress1.text = "al warda tower, Kuwait city"
        self.lblRecentName2.text = "ARBORIO"
        self.lblRecentAddress2.text = "al warda tower, Kuwait city"
        
        self.callProductCategoryAPI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCartList), name: NSNotification.Name(rawValue: kUpdateCartList), object: nil)

        setMapLocation()
    }
    
    //MARK: - HELPER -
    
    @objc func updateCartList() {
//        self.callCartListAPI()
    }
    
    func initializeTheLocationManager() {
        appDelegate.locationManager.delegate = self
        appDelegate.locationManager.requestWhenInUseAuthorization()
        appDelegate.locationManager.startUpdatingLocation()
    }
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                }))
                   alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    //THIS FUNCTION IS USED TO REDIRECT USER TO CHANGE LOCATION SETTINGS
    func showGotoSettingDialog(actionBlock: @escaping (_ isCancelTapped:Bool)->Void) {
        let alert = UIAlertController(title: "Allow Location Access", message: "Location Services Disabled\nTo re-enable, please go to Settings and turn on Location Service for this app.", preferredStyle: UIAlertController.Style.alert)
        
        // Button to Open Settings
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    debugPrint("Settings opened: \(success)")
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in
            actionBlock(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupCategoryDropDown() {
        self.categoryDropDown = DropDown()
        let arrCategory = self.arrShopCategory.map { $0.name }
        
        self.categoryDropDown.backgroundColor = .white
        self.categoryDropDown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.categoryDropDown.textColor = Constants.Color.THEME_BLACK
        self.categoryDropDown.selectedTextColor = .white
        
        self.categoryDropDown.anchorView = self.viewCategory
        self.categoryDropDown.bottomOffset = CGPoint(x: 0, y:((self.categoryDropDown.anchorView?.plainView.bounds.height)! + 10))
        self.categoryDropDown.dataSource = arrCategory
        self.categoryDropDown.direction = .bottom
        self.categoryDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.categoryDropDown.cellHeight = 42
        
        if self.txtCategory.text != "" {
            guard let index = arrCategory.firstIndex(of: self.txtCategory.text!) else { return }
            self.categoryDropDown.selectRow(index, scrollPosition: .top)
        }

        self.categoryDropDown.selectionAction = { (index: Int, item: String) in
            debugPrint(item)
            self.txtCategory.text = item
            self.selectedShopCategory = self.arrShopCategory[index]._id
            
            self.callGetNearByProductAPI()
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func btnScanClick(_ sender: UIButton) {
        guard checkScanPermissions() else { return }
        readerVC.modalPresentationStyle = .overFullScreen//.formSheet
        readerVC.delegate = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                debugPrint("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        present(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func btnLoginSignupClick(_ sender: UIButton) {
        let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.window?.rootViewController = navController
    }
    
    @IBAction func btnDeliveryJobClick(_ sender: UIButton) {
//        let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RiderCurrentOrderVC") as! RiderCurrentOrderVC
//        controller.isFromSideMenu = false
//        self.navigationController?.pushViewController(controller, animated: true)
        gotoRiderDetailsFill()
    }

    @IBAction func btnMapInfoColorTypeClick(_ sender: UIButton) {
        let controller = VehiclesPollutionColorPoupVC.getObject()
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
//        controller.buttonSubmitCallBack = { [weak self] (vehicleType) in
//            //                    let controller = RiderHomeViewController.getObject()
//            //                    self!.push(controller: controller)
//            let controller = VehicleInformationVC.getObject()
//            self!.push(controller: controller)
//        }
        self.present(controller, animated: true)
    }


    
    @IBAction func btnMoreProductClick(_ sender: UIButton) {
        //TEMPORARY
//        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "ProductHomeVC") as! ProductHomeVC
//        self.navigationController?.pushViewController(controller, animated: true)
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "NearByProductListVC") as! NearByProductListVC
        controller.userLocation = self.userLocation
        controller.selectedLocation = self.selectedLocation
        controller.selectedShopCategory = self.selectedShopCategory
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnSelectCategoryClick(_ sender: UIButton) {
//        self.categoryDropDown.show()
        if let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "CategoryList") as? CategoryList {
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            controller.applyFilter = { (data) in
                print(data.name)
                self.txtCategory.text = data.name
            }
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnSelectLocationClick(_ sender: UIButton) {
        UIView.transition(with: self.viewSearchLocationBG, duration: 0.4,
                          options: .transitionFlipFromBottom,
                          animations: {
            self.viewSearchLocationBG.isHidden = false
        })
    }
    
    @IBAction func btnCloseLocationPopupClick(_ sender: UIButton) {
        UIView.transition(with: self.viewSearchLocationBG, duration: 0.4,
                          options: .transitionFlipFromTop,
                          animations: {
            self.searchBar.text = self.tempSelectedLocString
            self.selectedLocation = self.tempLocation
            self.viewSearchLocationBG.isHidden = true
        })
    }
    
    @IBAction func btnSearchLocationClick(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue) |
            GMSPlaceField.addressComponents.rawValue |
            GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        //        filter.type = .geocode
        //        filter.type = .city
        //        filter.country = "my"
        autocompleteController.autocompleteFilter = filter
        
        autocompleteController.modalPresentationStyle = .fullScreen
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func btnCurrentLocationClick(_ sender: UIButton) {
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "SelectLocationMapVC") as! SelectLocationMapVC
        controller.completionBlock = {[weak self] (strAddress, selectedCoordinate) in
            guard let strongSelf = self else { return }
            if strAddress.trim() != "" {
                strongSelf.searchBar.text = strAddress
            } else {
                strongSelf.searchBar.text = ""
            }
            
            strongSelf.isFromGoolePlace = true
            strongSelf.selectedLocation = selectedCoordinate
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnClearLocationClick(_ sender: UIButton) {
        if self.selectedLocation != nil {
            self.lblSelectedLocation.text = "Enter Location"
            self.tempSelectedLocString = ""
            self.searchBar.text = ""
            self.tempLocation = nil
            self.selectedLocation = nil
            self.callGetNearByProductAPI()
        }
    }
    
    @IBAction func btnDoneLocationClick(_ sender: UIButton) {
        if self.searchBar.text == "" {
            GlobalData.shared.showDarkStyleToastMesage(message: "Location selection is required")
        } else {
            UIView.transition(with: self.viewSearchLocationBG, duration: 0.4,
                              options: .transitionFlipFromTop,
                              animations: {
                self.lblSelectedLocation.text = self.searchBar.text ?? ""
                self.tempSelectedLocString = self.searchBar.text ?? ""
                self.tempLocation = self.selectedLocation
                   self.viewSearchLocationBG.isHidden = true
                   self.callGetNearByProductAPI()
            })
        }
    }
    
    //BOTTOM BAR
    @IBAction func btnSendMoneyClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "SendMoneyFirstStepVC") as! SendMoneyFirstStepVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
            self.guestUserLogin()
        }
    }
    
    @IBAction func btnAddMoneyClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.addMoneyStoryBoard().instantiateViewController(withIdentifier: "AddMoneyVC") as! AddMoneyVC
            controller.isFromCartPayment = false
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
            self.guestUserLogin()
        }
    }
    
    @IBAction func btnMakepaymentClick(_ sender: UIButton) {

        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "SelectMoneyTypes") as! SelectMoneyTypes
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            //            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
            self.guestUserLogin()
        }

//        if defaults.object(forKey: kAuthToken) != nil {
//            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "SendMoneyToBankVC") as! SendMoneyToBankVC
//            self.navigationController?.pushViewController(controller, animated: true)
//        } else {
////            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
//            self.guestUserLogin()
//        }
    }
    
    @IBAction func btnMessagesClick(_ sender: UIButton) {
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
            self.guestUserLogin()
        }
    }

    @IBAction func btnTaxiTabAction(_ sender: UIButton) {
        self.switchTaxiStorybord()
    }

    func guestUserLogin() {
        let controller = LoginVC.getObject()
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
    }
    
    @IBAction func btnCallFriendsClick(_ sender: UIButton) {


        debugPrint("Call Friends")

        let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "ContactsVC") as! ContactsVC
        self.navigationController?.pushViewController(controller, animated: true)
        
        //TEMPORARY
        //dummyAction()
        return
        
        if defaults.object(forKey: kAuthToken) != nil {
            let controller = GlobalData.friendStoryBoard().instantiateViewController(withIdentifier: "FriendListVC") as! FriendListVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Login is required to access this feature")
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
    
    @IBAction func btnLoginClick(_ sender: UIButton) {
        if sender.tag == 0 {
            gotoLoginPage(type: 1)
        }else if sender.tag == 1 {
            gotoRiderDetailsFill()
        }else if sender.tag == 2 {
            gotoVendorDetailsFill()
        }
    }
}

// MARK: - QRCodeReader Delegate Methods

extension HomeVC: QRCodeReaderViewControllerDelegate {
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
            if !result.value.isValidEmailString() {
                GlobalData.shared.showDarkStyleToastMesage(message: "Please scan valid QR code")
            } else {
                self?.callQRCodeUserDetail(QRCodeValue: result.value)
            }
        }
    }
    
//    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
//        debugPrint("Switching capture to: \(newCaptureDevice.device.localizedName)")
//    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - CLLOCATION MANAGER DELEGATE -

extension HomeVC: CLLocationManagerDelegate {
    
    func showCurrentLocationOnMap() {
        let camera = GMSCameraPosition.camera(withLatitude: (self.userLocation.latitude), longitude: (self.userLocation.longitude), zoom: zoomLevel)
        
        self.mapView.camera = camera
        self.mapView?.animate(to: camera)
        self.mapView.clear()
        
        let marker = GMSMarker()
        marker.position = self.userLocation
        marker.icon = UIImage.init(named: "default_marker")
//        marker.icon = GMSMarker.markerImage(with:.black)
        marker.title = "Current Location"
        marker.snippet = "Hey, this is You"
//        marker.map = self.mapView
        marker.map = nil
        
        for objRider in self.arrNearRider {
            let latt = (objRider.latitude as NSString).doubleValue
            let long = (objRider.longitude as NSString).doubleValue
            
            let location = CLLocationCoordinate2D(latitude: latt, longitude: long)
            let user_marker = GMSMarker()
            user_marker.position = location
            if objRider.category == "61010f9a56bb10a09fcf1abb" { //Pedestrian - Dark green
                user_marker.icon = UIImage.init(named: "ic_location_dark_green")
            }
            else if objRider.category == "61010fb056bb10a09fcf1abe" { //Bikes and E.V - Light green
                user_marker.icon = UIImage.init(named: "ic_location_light_green")
            }
            else if objRider.category == "61010fbb56bb10a09fcf1ac1" { //Motorcycles - Red
                user_marker.icon = UIImage.init(named: "ic_location_red")
            }
            else if objRider.category == "61010fc456bb10a09fcf1ac4" { //Gas powered - Yellow
                user_marker.icon = UIImage.init(named: "ic_location_yellow")
            }
            user_marker.map = mapView
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            GlobalUserCurrent.location = location
            self.userLocation = location.coordinate
            
            //self.showCurrentLocationOnMap()
            
            appDelegate.locationManager.stopUpdatingHeading()
            appDelegate.locationManager.delegate = nil
            
            if objUserDetail.userType == "rider" {
                self.callGetVehicleInfoAPI()
            }
            
            self.callGetNearByProductAPI()
            self.callGetNearRiderAPI()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            appDelegate.locationManager.startUpdatingLocation()
        }
        else if status == .denied || status == .notDetermined || status == .restricted {
            debugPrint("Not Authorized")
            
            if GlobalData.shared.checkLocationStatus() == false {
                if self.isDisplayAlert == false {
                    self.isDisplayAlert = true
                    self.showGotoSettingDialog { (isCancelTapped) in
                        if isCancelTapped {
                            debugPrint("Permission denied")
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        if GlobalData.shared.checkLocationStatus() == false {
//            if self.isDisplayAlert == false {
//                self.isDisplayAlert = true
//                self.showGotoSettingDialog { (isCancelTapped) in
//                    if isCancelTapped {
//                        debugPrint("Permission denied")
//                    }
//                }
//            }
//        }
    }
    
    func gotoLoginPage(type : Int? = 0){
        let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        controller.loginType = type ?? 0
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
    }
    
    func gotoRiderDetailsFill(type : Int? = 0) {
        if defaults.object(forKey: kAuthToken) != nil {
            if (objUserDetail.isRider) {

                let controller = VehicleCategoryViewController.getObject()
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .crossDissolve
                controller.buttonSubmitCallBack = { [weak self] (vehicleType) in
                    //                    let controller = RiderHomeViewController.getObject()
                    //                    self!.push(controller: controller)
                    let controller = VehicleInformationVC.getObject()
                    self!.push(controller: controller)
                }
                self.present(controller, animated: true)

                
//                let controller = RiderHomeViewController.getObject()
//                self.push(controller: controller)
//                let controller = VehicleCategoryViewController.getObject()
//                controller.modalPresentationStyle = .overCurrentContext
//                controller.modalTransitionStyle = .crossDissolve
//                controller.buttonSubmitCallBack = { [weak self] (vehicleType) in
//                    if objUserDetail.isRiderVerified == true{
//                        self!.gotoRiderCurrentOrder()
//                    } else {
//                        self!.showAlert(message: "Your rider profile is not verified yet") { (action) in
//                            let controller = RiderHomeViewController.getObject()
//                            self!.push(controller: controller)
//                        }
//                    }
//                }
//                self.present(controller, animated: true)

            } else {
//                let controller = VehicleInformationVC.getObject()
//                self.push(controller: controller)
                
                let controller = VehicleCategoryViewController.getObject()
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .crossDissolve
                controller.buttonSubmitCallBack = { [weak self] (vehicleType) in
//                    let controller = RiderHomeViewController.getObject()
//                    self!.push(controller: controller)
                    let controller = VehicleInformationVC.getObject()
                    self!.push(controller: controller)
                }
                self.present(controller, animated: true)
            }
        } else {
                let controller = LoginVC.getObject()
                controller.loginType = type ?? 0
                let navController = UINavigationController.init(rootViewController: controller)
                appDelegate.drawerController.contentViewController = navController
        }
    }
    
    func gotoRiderCurrentOrder()  {
        let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RiderCurrentOrderVC") as! RiderCurrentOrderVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func gotoVendorDetailsFill(type : Int? = 0){
        if defaults.object(forKey: kAuthToken) != nil {
            if (objUserDetail.isVendor) {
                if objUserDetail.isVendorVerified == true{
                    let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopDetailVC") as! ShopDetailVC
                    self.push(controller: controller)
                } else {
//                    self.showAlert(message: "Your Shop profile is not verified yet") { (action) in
                        let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopListInfoViewController") as! ShopListInfoViewController
                        self.push(controller: controller)
//                    }
                }
            } else {
                let controller = SoleProprietorsCorporationsSelectionVC.getObject()
                self.push(controller: controller)
            }
            
            
        } else {
//            self.showAlert(message: "Please login/register first to switch roles") { (action) in
                let controller = LoginVC.getObject()
                controller.loginType = type ?? 0
                let navController = UINavigationController.init(rootViewController: controller)
                appDelegate.drawerController.contentViewController = navController
//            } cancelAction: { (cancelAction) in
//                print("cancel")
//            }
        }
    }

    func switchTaxiStorybord(){
        let controller = GlobalData.taxiTabbarStoryBoard().instantiateViewController(withIdentifier: "TaxiTabbarVC") as! TaxiTabbarVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension HomeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



//MARK: - GOOGLE AUTOCOMPLETE DELEGATE METHOD -

extension HomeVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        debugPrint(place.coordinate)
        debugPrint(place.name ?? "")
        debugPrint(place.plusCode ?? "")
        
        let placeName = place.name ?? ""
        let placeAddress = place.formattedAddress ?? ""
        
        if placeAddress.contains(placeName) {
            self.searchBar.text = place.formattedAddress
        } else {
            self.searchBar.text = (place.name ?? "") + ", " + (place.formattedAddress ?? "")
        }
        debugPrint(self.searchBar.text ?? "")
        
        self.isFromGoolePlace = true
        self.selectedLocation = place.coordinate
        
//        self.siteLocation = CLLocation.init(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        let camera = GMSCameraPosition.camera(withLatitude: (self.siteLocation.coordinate.latitude), longitude: (self.siteLocation.coordinate.longitude), zoom: zoomLevel)
//        cirlce = GMSCircle(position: camera.target, radius: CLLocationDistance(self.fenceRadius))
//        cirlce.fillColor = UIColor.init(HexCode: 0x919CC8)
//
//        self.mapView.clear()
//        cirlce.map = mapView
//
//        let marker = GMSMarker(position: self.siteLocation.coordinate)
//        marker.icon = UIImage.init(named: "default_marker")
//        marker.map = self.mapView
//
//        self.mapView?.animate(to: camera)
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        debugPrint("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}


