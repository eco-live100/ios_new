//
//  FavouriteProductObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 12/08/21.
//

import Foundation

class FavouriteProductObject: NSObject {
    var _id: String = ""
    var userId: String = ""
    var productId: String = ""
    var name: String = ""
    var shop: String = ""
    var productDescription: String = ""
    var category: String = ""
    var subcategory: String = ""
    var qty: Int = 0
    var live_price: Double = 0.0
    var online_price: Double = 0.0
    var live_delvery: Bool = false
    var online_delvery: Bool = false
    var createdAt: String = ""
    var updatedAt: String = ""
    var colors: String = ""
    
    var arrProductImages: [ProductImageObject] = []
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.userId = dictionary["userId"] as? String ?? ""
        self.productId = dictionary["productId"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.shop = dictionary["shop"] as? String ?? ""
        self.productDescription = dictionary["description"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
        self.subcategory = dictionary["subcategory"] as? String ?? ""
        self.qty = dictionary["qty"] as? Int ?? 0
        self.live_price = dictionary["live_price"] as? Double ?? 0.0
        self.online_price = dictionary["online_price"] as? Double ?? 0.0
        self.live_delvery = dictionary["live_delvery"] as? Bool ?? false
        self.online_delvery = dictionary["online_delvery"] as? Bool ?? false
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
        self.colors = dictionary["colors"] as? String ?? ""

        if let product = dictionary["products"] as? NSDictionary {
            if let productData = product["productData"] as? NSDictionary {
                self.live_price = Double(productData["priceLive"] as? String ?? "") ?? 0.0
                self.online_price = Double(productData["price"] as? String ?? "") ?? 0.0
                self.name = productData["productName"] as? String ?? ""

//                self.product_image = ((product["imageUrl"] as? NSArray)?[0] as? NSDictionary)?["name"] as? String ?? ""

            }

            //PRODUCT IMAGE LIST
            if let images = product["file"] as? [Dictionary<String, Any>] {
                for i in 0..<images.count {
                    let objImage = ProductImageObject.init(images[i])
                    self.arrProductImages.append(objImage)
                }
            }


        }


    }
}
