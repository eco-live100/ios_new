//
//  ProductObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 29/07/21.
//

import Foundation

class ProductObject: NSObject {
    var _id: String = ""
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
    var isfavourite: Bool = false
    var isfavouriteId: String = ""
    var colors: String = ""
//    var arrProductColor: [ColorDataObject] = []
    
    var arrProductImages: [ProductImageObject] = []
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
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
        self.isfavourite = dictionary["isfavourite"] as? Bool ?? false
        self.isfavouriteId = dictionary["isfavouriteId"] as? String ?? ""
        self.colors = dictionary["colors"] as? String ?? ""

        //PRODUCT COLOR LIST
//        if let colors = dictionary["colors"] as? [Dictionary<String, Any>] {
//            for i in 0..<colors.count {
//                let dictDetail = colors[i]
//                let hexcode = dictDetail["hexcode"] as? String ?? ""
//                let colorname = dictDetail["color_name"] as? String ?? ""
//
//                self.arrProductColor.append(ColorDataObject(hexcode: hexcode, color_name: colorname))
//            }
//        }
        
        //PRODUCT IMAGE LIST
        if let images = dictionary["images"] as? [Dictionary<String, Any>] {
            for i in 0..<images.count {
                let objImage = ProductImageObject.init(images[i])
                self.arrProductImages.append(objImage)
            }
        }
    }
}

//MARK: - PRODUCT IMAGE OBJECT
class ProductImageObject: NSObject {
    var _id: String = ""
    var name: String = ""
    var image: String = ""
    var product: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""
        self.product = dictionary["product"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
    }
}
