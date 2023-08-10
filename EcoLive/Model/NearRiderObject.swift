//
//  NearRiderObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 03/12/21.
//

import Foundation

class NearRiderObject: NSObject, Codable {
    var _id: String = ""
    var category: String = ""
    var p_description: String = ""
    var address: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var distance: Double = 0.0
    
    //LOCATION ORDER OBJECT
    var objLocationOrder: LocationOrderObject = LocationOrderObject.init([:])
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
        self.p_description = dictionary["description"] as? String ?? ""
        self.address = dictionary["address"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? String ?? ""
        self.distance = dictionary["distance"] as? Double ?? 0.0
        
        if let get_location = dictionary["location"] as? Dictionary<String, Any> {
            self.objLocationOrder = LocationOrderObject.init(get_location)
        }
    }
}
