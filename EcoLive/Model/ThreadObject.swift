//
//  ThreadObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 28/02/22.
//

import Foundation

class ThreadObject: NSObject, Codable {
    var _id: String = ""
    var sender_id: String = ""
    var sender_contact: String = ""
    var oposite_id: String = ""
    var oposite_contact: String = ""
    var oposite_name: String = ""
    var oposite_profileImage: String = ""
    
    //LOCATION ORDER OBJECT
    var objLocationOrder: LocationOrderObject = LocationOrderObject.init([:])
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.sender_id = dictionary["sender_id"] as? String ?? ""
        self.sender_contact = dictionary["sender_contact"] as? String ?? ""
        self.oposite_id = dictionary["oposite_id"] as? String ?? ""
        self.oposite_contact = dictionary["oposite_contact"] as? String ?? ""
        self.oposite_name = dictionary["oposite_name"] as? String ?? ""
        self.oposite_profileImage = dictionary["oposite_profileImage"] as? String ?? ""
    }
}
