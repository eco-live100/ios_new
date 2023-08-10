//
//  OrderObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 13/09/21.
//

import Foundation

class OrderObject: NSObject, Codable {
    var _id: String = ""
    var user: String = ""
    var shop_id: String = ""
    var orderStatus: String = ""
    var order_id: String = ""
    var purchase_price: String = ""
    var product_id: String = ""
    var qty: String = ""
    var product_name: String = ""
    var product_image: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var createdAt: String = ""
    var orderDate: String = ""

    //LOCATION ORDER OBJECT
    var objLocationOrder: LocationOrderObject = LocationOrderObject.init([:])

//    "_id": "637a3f4ddf3a3f2b49583883",
//    "shop_id": "6374c3f49e8d0f27d4d7a141",
//    "user": "6377a769df3a3f2b495835f4",
//    "userType": "Registered",
//    "total_amount": "250",
//    "discount_amount": "58",
//    "description": "First Order",
//    "address": "6374c3f49e8d0f27d4d7a141",
//    "orderStatus": "Pending",
//    "paymentType": "Online",
//    "paymentStatus": "Pending",
//    "product": "62d7fa81b44ebae7274bd02f",
//    "createdAt": "2022-11-20T14:53:01.252Z",
//    "updatedAt": "2022-11-20T14:53:01.252Z",
//    "__v": 0
    init(_ dictionary: [String: Any]) {
        let date = dictionary["createdAt"] as? String ?? ""

        self._id = dictionary["_id"] as? String ?? ""
        self.user = dictionary["user"] as? String ?? ""
        self.shop_id = dictionary["shop_id"] as? String ?? ""
        self.orderStatus = dictionary["orderStatus"] as? String ?? ""
        self.order_id = dictionary["order_id"] as? String ?? ""
        self.purchase_price = dictionary["total_amount"] as? String ?? ""
        self.product_id = dictionary["product_id"] as? String ?? ""
        self.qty = dictionary["qty"] as? String ?? ""
        self.product_name = dictionary["product_name"] as? String ?? ""
        self.product_image = dictionary["product_image"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.orderDate = date.fromUTCToLocalDateTime(OutputFormat: "yyyy/MM/dd")//"E, MMM d, yyyy"
        
        if let get_location = dictionary["location_order"] as? Dictionary<String, Any> {
            self.objLocationOrder = LocationOrderObject.init(get_location)
        }
    }
}

//MARK: - LOCATION ORDER OBJECT
class LocationOrderObject: NSObject, Codable {
    var type: String = ""
    var coordinates: [String] = []
    
    init(_ dictionary: [String: Any]) {
        self.type = dictionary["type"] as? String ?? ""
//        self.coordinates = dictionary["coordinates"] as? [String] ?? []
        
//        if let coord = dictionary["coordinates"] as? [Double] {
//            let arrOfStrings = coord.map { (value) -> String? in
//                return String(value)
//            }
//            self.coordinates = arrOfStrings as? [String] ?? []
//        } else {
//            self.coordinates = dictionary["coordinates"] as? [String] ?? []
//        }
        
        if let coord = dictionary["coordinates"] as? [Double] {
            let String_Array = coord.convertToString
            self.coordinates = String_Array
        } else {
            self.coordinates = dictionary["coordinates"] as? [String] ?? []
        }
    }
}
