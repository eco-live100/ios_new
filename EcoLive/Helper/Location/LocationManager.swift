

import Foundation
import CoreLocation
import UIKit


protocol LocationManagerDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
    func ChangeLocationStatus(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
}

class LocationManager: NSObject,CLLocationManagerDelegate {
    
    typealias CompletionHandlerAddress = (_ address :String) -> Void

    var locationManager: CLLocationManager?
    var delegate: LocationManagerDelegate?
    
    var status : CLAuthorizationStatus?

        
    static let sharedInstance:LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        guard let locationManagers=self.locationManager else {
            return
        }
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManagers.requestAlwaysAuthorization()
            locationManagers.requestWhenInUseAuthorization()
            
        }

        if #available(iOS 9.0, *) {
            //            locationManagers.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        locationManagers.desiredAccuracy = kCLLocationAccuracyBest
        locationManagers.pausesLocationUpdatesAutomatically = false
      //  locationManagers.distanceFilter = 0.1
        locationManagers.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
       
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
                switch status {
                case .notDetermined:
                    delegate?.ChangeLocationStatus(manager, didChangeAuthorization: .notDetermined)
                    locationManager?.requestAlwaysAuthorization()
                    break
                case .authorizedWhenInUse:
                    delegate?.ChangeLocationStatus(manager, didChangeAuthorization: .authorizedWhenInUse)
                    locationManager?.startUpdatingLocation()
                    break
                case .authorizedAlways:
                    delegate?.ChangeLocationStatus(manager, didChangeAuthorization: .authorizedAlways)
                    locationManager?.startUpdatingLocation()
                    break
                case .restricted:
                    delegate?.ChangeLocationStatus(manager, didChangeAuthorization: .restricted)
                    // restricted by e.g. parental controls. User can't enable Location Services
                    break
                case .denied:
                    delegate?.ChangeLocationStatus(manager, didChangeAuthorization: .denied)
                    // user denied your app access to Location Services, but can grant access from Settings.app
                    break
                default:
                    break
                }
        
        
        self.status = status
    }
 
//    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined:
//            locationManager?.requestAlwaysAuthorization()
//            break
//        case .authorizedWhenInUse:
//            locationManager?.startUpdatingLocation()
//            break
//        case .authorizedAlways:
//            locationManager?.startUpdatingLocation()
//            break
//        case .restricted:
//            // restricted by e.g. parental controls. User can't enable Location Services
//            break
//        case .denied:
//            // user denied your app access to Location Services, but can grant access from Settings.app
//            break
//        default:
//            break
//        }
//    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.startUpdatingLocation()
       // get_nearby_company()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
       
    }
    
    func startMonitoringSignificantLocationChanges() {
        self.locationManager?.startMonitoringSignificantLocationChanges()
        
        
    }
    
    func StartUpdaingLocationBackground(){
        self.locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    
    func inputDictLogin() -> [String:AnyObject] {
        var dict : [String:AnyObject] = [:]
        if let lat = locationManager?.location?.coordinate.latitude {
             dict["lat"]               = "22.7027857" as AnyObject
        }
        if let lon = locationManager?.location?.coordinate.longitude {
            dict["lon"]               = "75.8716059" as AnyObject
        }
        if let user_id = UserDefaults.standard.value(forKey: "user_id") {
            dict["user_id"]         =   user_id as AnyObject
        }
       
        // dict["register_id"]     =   "" as AnyObject
      
        return dict
    }
    //["email": cm50@gmail.com, "password": 123456, "type": USER, "ios_register_id": c20Fq_k3wjs:APA91bEP0mo8SDoKrb4P8eGBd4AumqN-B4j_OyBT8Kd9NANEdDiNx2ItV4aLyXT9sCjr8sLqTm9oVc8_ybD0_dmr98luy8qQ_i0a-u0vW_CTi-_VbrFXoGLyG0YEojQpBOl65vtbf5k5]
    
    
    func get_nearby_company() {

//         let user_id = UserDefaults.standard.value(forKey: "user_id") as? String
//        if user_id == nil || user_id == ""{
//            return
//        }
//        let lat = locationManager?.location?.coordinate.latitude
//        if lat == nil{
//            return
//        }
//        let long = locationManager?.location?.coordinate.longitude
//        if long == nil{
//            return
//        }
//
//        let paramsDict = self.inputDictLogin()
//        print(paramsDict)
//        let story = UIStoryboard(name: "Main", bundle: nil)
//        let vc = story.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        DispatchQueue.global(qos: .background).async {
//            CommunicationManeger.callPostService(apiUrl: BASE_URL + get_nearBy_com_URL, parameters: paramsDict, Method: .get, parentViewController: vc,
//                                                 successBlock: { (response : AnyObject,message : String) in
//                                                    print("success")
//
//            },
//                                                 failureBlock: { (error : Error) in
//                                                    print("error")
//
//            })
//        }
        
        
     
    }
    
//    func getAddressTolatLong(selectedLat : Double,selectedLon : Double,_ completion: (String) -> Void) {
//
//        var address: String = ""
//
//            let geoCoder = CLGeocoder()
//            let location = CLLocation(latitude: selectedLat, longitude: selectedLon)
//            //selectedLat and selectedLon are double values set by the app in a previous process
//
//
//        var isGetAddress = false
//
//            geoCoder.reverseGeocodeLocation(location, completionHandler:  {(placemarks, error) in
//
//                isGetAddress = true
//                if (error != nil)
//                {
//                    print("reverse geodcode fail: \(error!.localizedDescription)")
//                }
//                let pm = placemarks! as [CLPlacemark]
//
//                if pm.count > 0 {
//                    let pm = placemarks![0]
//                    print(pm.country)
//                    print(pm.locality)
//                    print(pm.subLocality)
//                    print(pm.thoroughfare)
//                    print(pm.postalCode)
//                    print(pm.subThoroughfare)
//                    var addressString : String = ""
//                    if pm.subLocality != nil {
//                        addressString = addressString + pm.subLocality! + ", "
//                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
//                    if pm.locality != nil {
//                        addressString = addressString + pm.locality! + ", "
//                    }
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }
//
//                    print(addressString)
//                    address = addressString
//              }
//
//            })
//
//        if isGetAddress {
//            completion(address)
//        }
//    }
    
    

    
}

class location {
    
    
    // MARK:   /** Degrees to Radian **/

    private class func degreeToRadian(angle:CLLocationDegrees) -> CGFloat{

        return (  (CGFloat(angle)) / 180.0 * CGFloat.pi  )

    }

    private class func radianToDegree(radian:CGFloat) -> CLLocationDegrees{

        return CLLocationDegrees(  radian * CGFloat(180.0 / CGFloat.pi)  )

    }

    
    class func middlePointOfListMarkers(listCoords: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D{

        var x = 0.0 as CGFloat
        var y = 0.0 as CGFloat
        var z = 0.0 as CGFloat

        for coordinate in listCoords{

            let lat = degreeToRadian(angle: coordinate.latitude)
            let lon = degreeToRadian(angle: coordinate.longitude)

            x = x + cos(lat) * cos(lon)
            y = y + cos(lat) * sin(lon);
            z = z + sin(lat * 1)

        }

        x = x/CGFloat(listCoords.count)
        y = y/CGFloat(listCoords.count)
        z = z/CGFloat(listCoords.count)

        let resultLon: CGFloat = atan2(y, x)
        let resultHyp: CGFloat = sqrt(x*x+y*y)
        let resultLat:CGFloat = atan2(z, resultHyp)

        let newLat = radianToDegree(radian: resultLat)
        let newLon = radianToDegree(radian: resultLon)
        let result:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: newLat, longitude: newLon)

        return result

    }
}
