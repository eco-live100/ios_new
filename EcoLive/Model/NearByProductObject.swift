//
//  NearByProductObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 18/10/21.
//

import Foundation

class NearByProductObject: NSObject, Codable {
    var _id: String = ""
    var user: String = ""
    var category: String = ""
    var p_description: String = ""
    var address: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var distance: Double = 0.0
    var shop_image: String = ""
    var product_live_price: Double = 0.0
    var product_online_price: Double = 0.0
    var product_id: String = ""
    var product_name: String = ""
    var product_image: String = ""
    
    //LOCATION ORDER OBJECT
    var objLocationOrder: LocationOrderObject = LocationOrderObject.init([:])
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.user = dictionary["user"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
        self.p_description = dictionary["description"] as? String ?? ""
        self.address = dictionary["address"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? String ?? ""
        self.distance = dictionary["distance"] as? Double ?? 0.0
        self.shop_image = dictionary["shop_image"] as? String ?? ""
        self.product_live_price = dictionary["product_live_price"] as? Double ?? 0.0
        self.product_online_price = dictionary["product_online_price"] as? Double ?? 0.0
        self.product_id = dictionary["product_id"] as? String ?? ""
        self.product_name = dictionary["product_name"] as? String ?? ""
        self.product_image = dictionary["product_image"] as? String ?? ""
        
        if let get_location = dictionary["location"] as? Dictionary<String, Any> {
            self.objLocationOrder = LocationOrderObject.init(get_location)
        }
    }
}
