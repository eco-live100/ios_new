//
//  AddressObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 24/08/21.
//

import Foundation

class AddressObject: NSObject, Codable {
    var _id: String = ""
    var user: String = ""
    var userName: String = ""
    var userContact: String = ""
    var userAddresssLine1: String = ""
    var userPincode: String = ""
    var city: String = ""
    var state: String = ""
    var country: String = ""
    var addressType: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var isDefaultAddress: Bool = false
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.user = dictionary["user"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.userContact = dictionary["userContact"] as? String ?? ""
        self.userAddresssLine1 = dictionary["userAddresssLine1"] as? String ?? ""
        self.userPincode = dictionary["userPincode"] as? String ?? ""
        self.city = dictionary["city"] as? String ?? ""
        self.state = dictionary["state"] as? String ?? ""
        self.country = dictionary["country"] as? String ?? ""
        self.addressType = dictionary["addressType"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
        self.isDefaultAddress = dictionary["isDefaultAddress"] as? Bool ?? false
    }
}
