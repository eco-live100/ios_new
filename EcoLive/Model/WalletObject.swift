//
//  WalletObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 14/09/21.
//

import Foundation

class WalletObject: NSObject, Codable {
    var _id: String = ""
    var userName: String = ""
    var email: String = ""
    var userType: String = ""
    var wallet: Double = 0.0
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.userType = dictionary["userType"] as? String ?? ""
        self.wallet = dictionary["wallet"] as? Double ?? 0.0
    }
}
