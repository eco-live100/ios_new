//
//  SelectLocationMapVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 25/06/21.
//

import UIKit
import GoogleMaps

typealias value2Pass = (_ locationAddress :String, _ selectedCoordinate: CLLocationCoordinate2D) ->()

class SelectLocationMapVC: UIViewController {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblAddress: UILabel!
    
    let userMarker = GMSMarker()
    var userLocation: CLLocationCoordinate2D!
//    var userLocation: CLLocation!
    var zoomLevel: Float = 14.0
//    var cirlce: GMSCircle!
//    var fenceRadius: Int = 100
    
    var completionBlock: value2Pass?
    
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
        DispatchQueue.main.async {
            self.initializeTheLocationManager()
            self.mapView.settings.compassButton = true
            self.mapView.isMyLocationEnabled = true
            //        self.mapView.settings.myLocationButton = true
            //        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: (self.vwBottom.frame.origin.y - 30), right: 5)
        }
    }
    
    //MARK: - HELPER -
    
    func initializeTheLocationManager() {
        appDelegate.locationManager.delegate = self
        appDelegate.locationManager.requestWhenInUseAuthorization()
        appDelegate.locationManager.startUpdatingLocation()
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
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        guard let cb = completionBlock else {return}
        cb(self.lblAddress.text ?? "", self.userLocation)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - CLLOCATION MANAGER DELEGATE -

extension SelectLocationMapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.userLocation = location.coordinate

            let camera = GMSCameraPosition.camera(withLatitude: (self.userLocation.latitude), longitude: (self.userLocation.longitude), zoom: zoomLevel)
            
            self.mapView.camera = camera
            self.mapView?.animate(to: camera)
            
//            cirlce = GMSCircle(position: camera.target, radius: CLLocationDistance(self.fenceRadius))
//            cirlce.fillColor = UIColor.init(hex: 0x919CC8)
            
            self.mapView.clear()
//            cirlce.map = mapView
            
            //********//
//            let userMarker = GMSMarker()
            userMarker.position = self.userLocation //self.userLocation.coordinate
            userMarker.icon = UIImage.init(named: "default_marker")
            self.mapView.delegate = self
            userMarker.isDraggable = true
            self.reverseGeocoding(marker: userMarker)
            userMarker.map = self.mapView
            //********//
            
            appDelegate.locationManager.stopUpdatingHeading()
            appDelegate.locationManager.delegate = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            appDelegate.locationManager.startUpdatingLocation()
        }
        else if status == .denied || status == .notDetermined || status == .restricted {
            debugPrint("Not Authorized")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //        if AppFunctions.sharedInstance.checkLocationStatus() == false {
        //            self.showGotoSettingDialog { (isCancelTapped) in
        //                if isCancelTapped {
        //                    debugPrint("Permission denied")
        //                }
        //            }
        //        }
    }
}

extension SelectLocationMapVC: GMSMapViewDelegate {
    
//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        let marker = GMSMarker()
//        marker.position = position.target
//        debugPrint(marker.position)
//    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        debugPrint("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
        self.reverseGeocoding(marker: marker)
        debugPrint("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        debugPrint("didBeginDragging")
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        debugPrint("didDrag")
    }
    
    //Mark: Reverse GeoCoding
    
    func reverseGeocoding(marker: GMSMarker) {
        let geocoder = GMSGeocoder()
        self.userLocation = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(self.userLocation) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                debugPrint("Response is = \(address)")
                debugPrint("Response is = \(lines)")
                debugPrint(address.coordinate.latitude)
                debugPrint(address.coordinate.longitude)
                
                currentAddress = lines.joined(separator: "\n")
            }
//            marker.title = currentAddress
//            marker.map = self.mapView
            
            self.lblAddress.text = currentAddress
            
            self.mapView.clear()
            self.userMarker.title = currentAddress
            self.userMarker.map = self.mapView
        }
    }
}
