//
//  RiderOrderAddressVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 17/06/21.
//

import UIKit
import MapKit
import CoreLocation

class RiderOrderAddressVC: BaseVC, MKMapViewDelegate {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var objOrderDetail: RiderOrderObject!
    
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
            
            self.viewAddress.createButtonShadow()
        }
        
        self.lblAddress.text = self.objOrderDetail.location_address
        
        guard let shopLattitude = Double(self.objOrderDetail.latitude) else { return }
        guard let shopLongitude = Double(self.objOrderDetail.longitude) else { return }

        guard let orderLattitude = Double(self.objOrderDetail.objLocationOrder.coordinates[0]) else { return }
        guard let orderLongitude = Double(self.objOrderDetail.objLocationOrder.coordinates[1]) else { return }
        
        let shopLocation = CLLocation(latitude: shopLattitude, longitude: shopLongitude)
        let orderLocation = CLLocation(latitude: orderLattitude, longitude: orderLongitude)
        
        let distance = shopLocation.distance(from: orderLocation)
        self.getDistance(departureDate: Date(), arrivalDate: Date(), startLocation: shopLocation, endLocation: orderLocation) { (distanceInMeters) in
            
            debugPrint("fake distance: \(distance)")
            let fakedistanceInMeter = Measurement(value: distance, unit: UnitLength.meters)
            let fakedistanceInKM = fakedistanceInMeter.converted(to: UnitLength.kilometers).value
            let fakedistanceInMiles = fakedistanceInMeter.converted(to: UnitLength.miles).value
            debugPrint("fakedistanceInKM :\(fakedistanceInKM)")
            debugPrint("fakedistanceInMiles :\(fakedistanceInMiles)")
            
            debugPrint("actualDistance : \(distanceInMeters)")
            
            let distanceInMeter = Measurement(value: distanceInMeters, unit: UnitLength.meters)
            let distanceInKM = distanceInMeter.converted(to: UnitLength.kilometers).value
            let distanceInMiles = distanceInMeter.converted(to: UnitLength.miles).value
            debugPrint("distanceInKM :\(distanceInKM)")
            debugPrint(String(format: "The distance to order location is %.01fkm", distanceInKM))
            debugPrint("distanceInMiles :\(distanceInMiles)")
            
            self.lblDistance.text = String(format: "%.01f km", distanceInKM)
        }
        
        self.mapView.showRouteOnMap(pickupCoordinate: shopLocation.coordinate, destinationCoordinate: orderLocation.coordinate)
        
        let center = CLLocationCoordinate2D(latitude: shopLocation.coordinate.latitude, longitude: shopLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
        self.mapView.setRegion(region, animated: true)
        
//        self.showRouteOnMap(pickupCoordinate: shopLocation.coordinate, destinationCoordinate: orderLocation.coordinate)
    }
    
    //MARK: - HELPER -
    
    func getDistance(departureDate: Date, arrivalDate: Date, startLocation : CLLocation, endLocation : CLLocation, completionHandler: @escaping (_ distance: CLLocationDistance) -> Void) {
        
        let destinationItem =  MKMapItem(placemark: MKPlacemark(coordinate: startLocation.coordinate))
        let sourceItem      =  MKMapItem(placemark: MKPlacemark(coordinate: endLocation.coordinate))
        self.calculateDistancefrom(departureDate: departureDate, arrivalDate: arrivalDate, sourceLocation: sourceItem, destinationLocation: destinationItem, doneSearching: { distance in
            completionHandler(distance)
        })
    }
    
    func calculateDistancefrom(departureDate: Date, arrivalDate: Date, sourceLocation: MKMapItem, destinationLocation: MKMapItem, doneSearching: @escaping (_ distance: CLLocationDistance) -> Void) {
        
        let request: MKDirections.Request = MKDirections.Request()
        
        request.departureDate = departureDate
        request.arrivalDate = arrivalDate
        
        request.source = sourceLocation
        request.destination = destinationLocation
        
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (directions, error) in
            if var routeResponse = directions?.routes {
                routeResponse.sort(by: {$0.expectedTravelTime <
                                    $1.expectedTravelTime})
                let quickestRouteForSegment: MKRoute = routeResponse[0]
                
                doneSearching(quickestRouteForSegment.distance)
            }
        }
    }
    
//    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
//        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
//        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
//
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//
//        let sourceAnnotation = MKPointAnnotation()
//
//        if let location = sourcePlacemark.location {
//            sourceAnnotation.coordinate = location.coordinate
//        }
//
//        let destinationAnnotation = MKPointAnnotation()
//
//        if let location = destinationPlacemark.location {
//            destinationAnnotation.coordinate = location.coordinate
//        }
//
//        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
//
//        let directionRequest = MKDirections.Request()
//        directionRequest.source = sourceMapItem
//        directionRequest.destination = destinationMapItem
//        directionRequest.transportType = .automobile
//
//        // Calculate the direction
//        let directions = MKDirections(request: directionRequest)
//
//        directions.calculate {
//            (response, error) -> Void in
//
//            guard let response = response else {
//                if let error = error {
//                    debugPrint("Error: \(error)")
//                }
//
//                return
//            }
//
//            let route = response.routes[0]
//
//            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
//
//            let rect = route.polyline.boundingMapRect
//            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
//        }
//    }
    
    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
