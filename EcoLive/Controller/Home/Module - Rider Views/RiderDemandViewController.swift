//
//  RiderDemandViewController.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 22/06/22.
//

import UIKit
import GoogleMaps
import GooglePlaces

class RiderDemandViewController: UIViewController {

    static func getObject()-> RiderDemandViewController {
        let storyboard = UIStoryboard(name: "Rider", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RiderDemandViewController") as? RiderDemandViewController
        if let vc = vc {
            return vc
        }
        return RiderDemandViewController()
    }
    //MARK: - PROPERTIES & OUTLETS
    @IBOutlet weak var mapView: GMSMapView!
    
    var userLocation: CLLocationCoordinate2D!
    var zoomLevel: Float = 17.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeTheLocationManager()
        self.mapView.settings.compassButton = true
        self.mapView.isMyLocationEnabled = false//true
        self.mapView.settings.myLocationButton = false
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func initializeTheLocationManager() {
        appDelegate.locationManager.delegate = self
        appDelegate.locationManager.requestWhenInUseAuthorization()
        appDelegate.locationManager.startUpdatingLocation()
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension RiderDemandViewController: CLLocationManagerDelegate {
    
    
    func showCurrentLocationOnMap() {
        
        
        let camera = GMSCameraPosition.camera(withLatitude: (self.userLocation.latitude), longitude: (self.userLocation.longitude), zoom: zoomLevel)
        
        self.mapView.camera = camera
        self.mapView?.animate(to: camera)
        self.mapView.clear()
        
        let marker = GMSMarker()
        marker.position = self.userLocation
        marker.icon = UIImage.init(named: "default_marker")
        marker.title = "Current Location"
        marker.snippet = "Hey, this is You"
        marker.map = mapView
        

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.userLocation = location.coordinate
            self.showCurrentLocationOnMap()
            appDelegate.locationManager.stopUpdatingHeading()
            appDelegate.locationManager.delegate = nil

        }
    }
}
