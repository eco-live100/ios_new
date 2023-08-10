//
//  TrackOrderMapVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 15/06/21.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import SDWebImage

class TrackOrderMapVC: BaseVC {
    
    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewRiderDetail: UIView!
    @IBOutlet weak var imgRider: UIImageView!
    @IBOutlet weak var lblRiderName: UILabel!
    @IBOutlet weak var lblArrivalTime: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var noticeLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var previousStepBtn: UIButton!
    @IBOutlet var nextStepBtn: UIButton!
    
    var objOrderDetail = OrderDetail.init([:])
    var orderLocation: CLLocation!
    
    var riderAnnotation = CustomPointAnnotation()
    var riderPinAnnotationView: MKPinAnnotationView!
    
    var currentRoute: MKRoute?
    var currentStepIndex = 0
    
    var routePolyline: MKPolyline?
    
    var locationManager: CLLocationManager!
    
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
        
        self.instructionsLabel.isHidden = true
        self.noticeLabel.isHidden = true
        
        self.previousStepBtn.clipsToBounds = true
        self.previousStepBtn.layer.cornerRadius = 15
        
        self.nextStepBtn.clipsToBounds = true
        self.nextStepBtn.layer.cornerRadius = 15
        
        self.distanceLabel.clipsToBounds = true
        self.distanceLabel.layer.cornerRadius = 25
        self.distanceLabel.layer.borderWidth = 2
        self.distanceLabel.layer.borderColor = UIColor.black.cgColor
        
        self.callUserDetailByEmail()
        
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
        
        //mapview setup to show user location
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType(rawValue: 0)!
//        self.mapView.showsUserLocation = true
//        self.mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        guard let orderLattitude = Double(self.objOrderDetail.objLocationOrder.coordinates[0]) else { return }
        guard let orderLongitude = Double(self.objOrderDetail.objLocationOrder.coordinates[1]) else { return }
        
        self.orderLocation = CLLocation(latitude: orderLattitude, longitude: orderLongitude)
        
        let DestinationAnnotation = CustomPointAnnotation()
        DestinationAnnotation.coordinate = CLLocationCoordinate2DMake(orderLattitude, orderLongitude)
        DestinationAnnotation.title = "Destination location"
        DestinationAnnotation.subtitle = "Destination is here"
        DestinationAnnotation.pinCustomImageName = "ic_pin_destination"
        
        let annotationView = MKPinAnnotationView(annotation: DestinationAnnotation, reuseIdentifier: "pin")
        self.mapView.addAnnotation(annotationView.annotation!)
    }
    
    //MARK: - HELPER -
    
    func getDirections(SourceCoordinates sourceCoordinates: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinates)
        request.source = MKMapItem(placemark: sourcePlaceMark)
        
        let destPlaceMark = MKPlacemark(coordinate: self.orderLocation.coordinate)
        request.destination = MKMapItem(placemark: destPlaceMark)
        
        request.transportType = [.automobile, .walking]
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response else {
                debugPrint("Error: \(error?.localizedDescription ?? "No error specified").")
                return
            }
            
            if self.routePolyline != nil {
                self.mapView.removeOverlay(self.routePolyline!)
                self.routePolyline = nil
            }
            
            let route = response.routes[0]
            self.routePolyline = route.polyline
            self.currentRoute = route
            self.displayCurrentStep()
            self.mapView.addOverlay(self.routePolyline!)
        }
    }
    
    func displayCurrentStep() {
        guard let currentRoute = self.currentRoute else { return }
        if self.currentStepIndex >= currentRoute.steps.count { return }
        let step = currentRoute.steps[self.currentStepIndex]
        
        self.instructionsLabel.text = step.instructions
        self.distanceLabel.text = "\(distanceConverter(distance: step.distance))"
        
        if self.instructionsLabel.text == "" {
            self.instructionsLabel.isHidden = true
        } else {
            self.instructionsLabel.isHidden = false
        }
        
        if step.notice != nil {
            self.noticeLabel.isHidden = false
            self.noticeLabel.text = step.notice
        } else {
            self.noticeLabel.isHidden = true
        }
        
        // Enable/Disable buttons according to the step they are
        self.previousStepBtn.isEnabled = self.currentStepIndex > 0
        self.nextStepBtn.isEnabled = self.currentStepIndex < (currentRoute.steps.count - 1)
        
        let padding = UIEdgeInsets(top: 40, left: 40, bottom: 100, right: 40)
        self.mapView.setVisibleMapRect(step.polyline.boundingMapRect, edgePadding: padding, animated: true)
    }
    
    func distanceConverter(distance: CLLocationDistance) -> String {
        let lengthFormatter = LengthFormatter()
        lengthFormatter.numberFormatter.maximumFractionDigits = 2
        if NSLocale.current.usesMetricSystem {
            return lengthFormatter.string(fromValue: distance / 1000, unit: .kilometer)
        } else {
            return lengthFormatter.string(fromValue: distance / 1609.34, unit: .mile)
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPreviousStepClick(_ sender: UIButton) {
        if self.currentRoute == nil { return }
        if self.currentStepIndex <= 0 { return }
        self.currentStepIndex -= 1
        self.displayCurrentStep()
    }
    
    @IBAction func btnNextStepClick(_ sender: UIButton) {
        guard let currentRoute = self.currentRoute else { return }
        if self.currentStepIndex >= (currentRoute.steps.count - 1) { return }
        self.currentStepIndex += 1
        self.displayCurrentStep()
    }
}

//MARK: - CLLOCATIONMANAGER DELEGATE -

extension TrackOrderMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let userLocation = location.coordinate
            
            if self.riderPinAnnotationView != nil {
                self.mapView.removeAnnotation(self.riderPinAnnotationView.annotation!)
            }
            
            let center = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
            self.riderAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude)
            self.riderAnnotation.title = "Current location"
            self.riderAnnotation.subtitle = "I am here"
            self.riderAnnotation.pinCustomImageName = "ic_pin_rider"
            
            self.riderPinAnnotationView = MKPinAnnotationView(annotation: self.riderAnnotation, reuseIdentifier: "pin")
            self.mapView.addAnnotation(self.riderPinAnnotationView.annotation!)
            
            self.getDirections(SourceCoordinates: userLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}

//MARK: - MAPVIEW DELEGATE -

extension TrackOrderMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let customPointAnnotation = annotation as! CustomPointAnnotation
        annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName ?? "")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 5
        return renderer
    }
}

//MARK: - API CALL -

extension TrackOrderMapVC {
    //USER DETAIL BY EMAIL
    func callUserDetailByEmail() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["email"] = self.objOrderDetail.rider_email
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.PROFILE_BY_EMAIL, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            let object: UserDetail = UserDetail.initWith(dict: payload.removeNull())
                            
                            if object._id == objUserDetail._id {
                                strongSelf.lblRiderName.text = "You"
                            } else {
                                strongSelf.lblRiderName.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Your rider" + "\n", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: strongSelf.lblRiderName.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x707070), strSecond: object.userName, strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: strongSelf.lblRiderName.font.pointSize + 3)!, strSecondColor: UIColor.black)
                            }
                            
                            strongSelf.imgRider.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                            strongSelf.imgRider.sd_setImage(with: URL(string: object.profileImage), placeholderImage: UIImage.init(named: "user_placeholder"))
                            
                            strongSelf.lblArrivalTime.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Arrival time" + "\n", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: strongSelf.lblArrivalTime.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "6:10 am", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: strongSelf.lblArrivalTime.font.pointSize + 3)!, strSecondColor: Constants.Color.THEME_YELLOW)
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
}
