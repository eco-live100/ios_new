//
//  CardObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 14/09/21.
//

import Foundation

class CardObject: NSObject, Codable {
    var id: String = ""
    var card_type: String = ""
    var card_hodername: String = ""
    var card_no: String = ""
    var card_expiry: String = ""
    var createdAt: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.card_type = dictionary["card_type"] as? String ?? ""
        self.card_hodername = dictionary["card_hodername"] as? String ?? ""
        self.card_no = dictionary["card_no"] as? String ?? ""
        self.card_expiry = dictionary["card_expiry"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
    }
}
