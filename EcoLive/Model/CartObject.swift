//
//  CartObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 26/08/21.
//

import Foundation

class CartObject: NSObject, Codable {
    var _id: String = ""
    var user: String = ""
    var shop_id: String = ""
    var product_id: String = ""
    var qty: String = ""
    var purchase_type: String = ""
    var product_color: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var product_name: String = ""
//    var live_price: Double = 0.0
    var live_price : String = ""
    var online_price: Double = 0.0
    var price: String = ""

    var product_image: String = ""
    
    var quantity: Int = 0
    var total_price: Double = 0.0
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.user = dictionary["user"] as? String ?? ""
        self.shop_id = dictionary["shop_id"] as? String ?? ""
        self.product_id = dictionary["product_id"] as? String ?? ""
        self.qty = dictionary["qty"] as? String ?? ""
        self.purchase_type = dictionary["purchase_type"] as? String ?? ""
        self.product_color = dictionary["product_color"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
        self.product_name = dictionary["product_name"] as? String ?? ""
//        self.live_price = dictionary["live_price"] as? Double ?? 0.0
        self.online_price = dictionary["online_price"] as? Double ?? 0.0
        self.product_image = dictionary["product_image"] as? String ?? ""


        if let product = dictionary["products"] as? NSDictionary {
            if let productData = product["productData"] as? NSDictionary {
                self.live_price = productData["priceLive"] as? String ?? ""
                self.price = productData["price"] as? String ?? ""
                self.product_name = productData["productName"] as? String ?? ""
              
                self.product_image = ((product["imageUrl"] as? NSArray)?[0] as? NSDictionary)?["name"] as? String ?? ""

            }
        }
                
        self.quantity = (self.qty as NSString).integerValue
        if self.purchase_type == "online" {
//            self.total_price = self.online_price * Double(quantity)
            self.total_price = (Double(self.live_price) ?? 0.0) * Double(quantity)
        } else {
//            self.total_price = self.live_price * Double(quantity)
            self.total_price = (Double(self.live_price) ?? 0.0) * Double(quantity)
        }
    }
}
