//
//  VehicleObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 23/08/21.
//

import Foundation

class VehicleObject: NSObject, Codable {
    var _id: String = ""
    var user: String = ""
    var vehicalName: String = ""
    var category: String = ""
    var image: String = ""
    var createdAt: String = ""
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.user = dictionary["user"] as? String ?? ""
        self.vehicalName = dictionary["vehicalName"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
    }
}
