//
//  TrackOrderVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 15/06/21.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

class TrackOrderVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblArrivalTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblOrderAmount: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewOrderDetail: UIView!
    @IBOutlet weak var btnViewMap: UIButton!
    
    var orderID:String = ""
    var objOrderDetail = OrderDetail.init([:])
    
    // 1.Placed 2.Prepared 3. Booking Arranged 4.In Transit 5.Arrived at Destination 6.Out of delivery  7.Delivered
    var trackStatus:Int = 0
    var arrStatus = ["Placed", "Prepared", "Booking Arranged", "In Transit", "Arrived at Destination", "Out of delivery", "Delivered"]
    
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
            
            self.viewOrderDetail.createButtonShadow()

            self.btnViewMap.layer.cornerRadius = self.btnViewMap.frame.height / 2.0
            self.btnViewMap.createButtonShadow()
        }
        
        self.tblView.showsVerticalScrollIndicator = false
        self.tblView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: 1))
        
        self.callOrderDetailAPI()
    }
    
    func setupData() {
        guard let myLattitude = Double(self.objOrderDetail.latitude) else { return }
        guard let myLongitude = Double(self.objOrderDetail.longitude) else { return }

        guard let orderLattitude = Double(self.objOrderDetail.objLocationOrder.coordinates[0]) else { return }
        guard let orderLongitude = Double(self.objOrderDetail.objLocationOrder.coordinates[1]) else { return }
        
        let myLocation = CLLocation(latitude: myLattitude, longitude: myLongitude)
        let orderLocation = CLLocation(latitude: orderLattitude, longitude: orderLongitude)
        
//        let distance = myLocation.distance(from: orderLocation) / 1000
//        debugPrint(String(format: "The distance to order location is %.01fkm", distance))
//
//        *****//
//        let myLocation = CLLocation(latitude: 23.0733121, longitude: 72.5134436)
//        let myBuddysLocation = CLLocation(latitude: 23.1165114, longitude: 72.5826427)
//        let distance1 = myLocation.distance(from: myBuddysLocation) / 1000
//        debugPrint(String(format: "The distance to my buddy is %.01fkm", distance1))
//        let distanceInMeters = myLocation.distance(from: myBuddysLocation)
//        debugPrint(distanceInMeters)
//
//        let distanceInMeter = Measurement(value: distanceInMeters, unit: UnitLength.meters)
//        let distanceInKM = distanceInMeter.converted(to: UnitLength.kilometers).value
//        let distanceInMiles = distanceInMeter.converted(to: UnitLength.miles).value
//        debugPrint("distanceInKM :\(distanceInKM)")
//        debugPrint("distanceInMiles :\(distanceInMiles)")
//        *****//
//
//        let myLocation : CLLocation = CLLocation.init(latitude: 23.0733121, longitude: 72.5134436)
//        let orderLocation : CLLocation = CLLocation.init(latitude: 23.1165114, longitude: 72.5826427)
        
        let distance = myLocation.distance(from: orderLocation)
        self.getDistance(departureDate: Date(), arrivalDate: Date(), startLocation: myLocation, endLocation: orderLocation) { (distanceInMeters) in
            
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
        
        self.lblOrderNo.text = "Order number" + " - " + self.objOrderDetail._id
        self.lblOrderAmount.text = "$\(self.objOrderDetail.purchase_price)"
        self.lblArrivalTime.text = "6:10am"
//        self.lblDistance.text = String(format: "%.01fkm", distance)
        
        if self.objOrderDetail.orderStatus == "Placed" {
            self.trackStatus = 1
        } else if self.objOrderDetail.orderStatus == "Prepared" {
            self.trackStatus = 2
        } else if self.objOrderDetail.orderStatus == "Booking Arranged" {
            self.trackStatus = 3
        } else if self.objOrderDetail.orderStatus == "In Transit" {
            self.trackStatus = 4
        } else if self.objOrderDetail.orderStatus == "Arrived at Destination" {
            self.trackStatus = 5
        } else if self.objOrderDetail.orderStatus == "Out of delivery" {
            self.trackStatus = 6
        } else if self.objOrderDetail.orderStatus == "Delivered" {
            self.trackStatus = 7
        }
        
        GlobalData.shared.reloadTableView(tableView: self.tblView)
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
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnViewMapClick(_ sender: UIButton) {
        let controller = GlobalData.trackOrderStoryBoard().instantiateViewController(withIdentifier: "TrackOrderMapVC") as! TrackOrderMapVC
        controller.objOrderDetail = self.objOrderDetail
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension TrackOrderVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrStatus.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackOrderCell", for: indexPath) as! TrackOrderCell
        
        cell.lblStatus.text = self.arrStatus[indexPath.section]
        
        if indexPath.section < self.trackStatus {
            cell.viewLine.backgroundColor =  Constants.Color.THEME_YELLOW
            cell.viewCircle.backgroundColor = Constants.Color.THEME_YELLOW
            
            cell.viewCircle.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            cell.viewCircle.layer.borderWidth = 3
        } else {
            if indexPath.section == self.trackStatus {
                cell.viewLine.backgroundColor =  Constants.Color.THEME_YELLOW
                cell.viewCircle.backgroundColor = UIColor.white
                
                cell.viewCircle.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
                cell.viewCircle.layer.borderWidth = 3
            } else {
                cell.viewLine.backgroundColor =  UIColor.init(hex: 0x9F9F9F)
                cell.viewCircle.backgroundColor = UIColor.init(hex: 0xC5C5C5)
                
                cell.viewCircle.layer.borderColor = UIColor.init(hex: 0x59F9F9F).cgColor
                cell.viewCircle.layer.borderWidth = 3
            }
        }
        
        if indexPath.section == 0 {
            if self.objOrderDetail.createdAt != "" {
                let date = self.objOrderDetail.createdAt.fromUTCToLocalDateTime(OutputFormat: "MMM d, h:mm a")
                let dateArr = date.components(separatedBy: ",")
                
                cell.lblDateTime.text = "\(dateArr[0])\n\(dateArr[1])"
            }
        } else if indexPath.section == 1 {
            cell.lblDateTime.text = ""
        } else if indexPath.section == 2 {
            cell.lblDateTime.text = ""
        } else if indexPath.section == 3 {
            cell.lblDateTime.text = ""
        } else if indexPath.section == 4 {
            cell.lblDateTime.text = ""
        } else if indexPath.section == 5 {
            cell.lblDateTime.text = ""
        } else {
            cell.lblDateTime.text = ""
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - API CALL -

extension TrackOrderVC {
    //ORDER DETAIL API
    func callOrderDetailAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let strURL = Constants.URLS.ORDER + "/" + "\(self.orderID)"
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestGETURL(strURL) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payloadData = response["data"] as? Dictionary<String, Any> {
                            strongSelf.objOrderDetail = OrderDetail.init(payloadData)
                            
                            strongSelf.setupData()
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
        } failure: { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
}
