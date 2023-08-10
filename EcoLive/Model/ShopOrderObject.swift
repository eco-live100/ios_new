//
//  ShopOrderObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 08/10/21.
//

import Foundation

class ShopOrderObject: NSObject, Codable {
    var _id: String = ""
    var shop_id: String = ""
    var qty: String = ""
    var purchase_price: String = ""
    var order_id: String = ""
    var product_id: String = ""
    var createdAt: String = ""
    var user: String = ""
    var orderStatus: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var product_name: String = ""
    var product_image: String = ""
    
    //LOCATION ORDER OBJECT
    var objLocationOrder: LocationOrderObject = LocationOrderObject.init([:])
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.shop_id = dictionary["shop_id"] as? String ?? ""
        self.qty = dictionary["qty"] as? String ?? ""
        self.purchase_price = dictionary["purchase_price"] as? String ?? ""
        self.order_id = dictionary["order_id"] as? String ?? ""
        self.product_id = dictionary["product_id"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.user = dictionary["user"] as? String ?? ""
        self.orderStatus = dictionary["orderStatus"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? String ?? ""
        self.product_name = dictionary["product_name"] as? String ?? ""
        self.product_image = dictionary["product_image"] as? String ?? ""
        
        if let get_location = dictionary["location_order"] as? Dictionary<String, Any> {
            self.objLocationOrder = LocationOrderObject.init(get_location)
        }
    }
}
