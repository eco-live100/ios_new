//
//  SubProductCategoryObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 30/07/21.
//

import Foundation

class SubProductCategoryObject: NSObject, Codable {
    var _id: String = ""
    var name: String = ""
    var category: String = ""
    var descriptionn: String = ""
    var createdAt: String = ""
    var image: String = ""
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
        self.descriptionn = dictionary["description"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""
    }
}

class StoreProductObject: NSObject, Codable {



    var _id: String = ""
    var name: String = ""
    var category: String = ""
    var descriptionn: String = ""
    var createdAt: String = ""
    var image: String = ""

    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.name = (dictionary["productData"] as? NSDictionary)?["name"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
        self.descriptionn = dictionary["description"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""
    }
}

