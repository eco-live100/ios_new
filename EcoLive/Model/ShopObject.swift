//
//  ShopObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 21/07/21.
//

import UIKit

class ShopObject: NSObject, Codable {
 
    var user: String = ""
    var category: String = ""
    var address: String = ""
    var zipCode: String = ""
    var image: String = ""
    var completeStatus: Bool = false
    
    
    var _id: String = ""
    var isVerified, status: Bool
    var userID, shopCategoryID, shopSubCategoryID, shopName: String
    var firstName, lastName, email, countryCode: String
    var mobileNumber, numberOfLocation: String
    var shopDescription: String
    var latitude, longitude, createdAt, updatedAt: String
    var storeLogo,storeAddress,shopType: String?
    var storeDocuments: [String]?
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.isVerified = dictionary["isVerified"] as? Bool ?? false
        self.status = dictionary["status"] as? Bool ?? false
        self.userID = dictionary["userID"] as? String ?? ""
        self.shopCategoryID = dictionary["shopCategoryId"] as? String ?? ""
        self.shopSubCategoryID = dictionary["shopSubCategoryId"] as? String ?? ""
        self.shopName = dictionary["shopName"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.countryCode = dictionary["countryCode"] as? String ?? ""
        self.mobileNumber = dictionary["mobileNumber"] as? String ?? ""
        self.numberOfLocation = dictionary["numberOfLocation"] as? String ?? ""
        self.shopDescription = dictionary["description"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
        self.storeLogo = dictionary["storeLogo"] as? String ?? ""
        self.storeAddress = dictionary["storeAddress"] as? String ?? ""
        self.shopType = dictionary["shopType"] as? String ?? ""
    }
}
