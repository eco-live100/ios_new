//
//  TransactionHistoryObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 23/09/21.
//

import Foundation

class TransactionHistoryObject: NSObject, Codable {
    var _id: String = ""
    var transaction_id: String = ""
    var trnsaction_from: String = ""
    var trnsaction_to: String = ""
    var transaction_type: String = ""
    var paymentType: String = ""
    var paymentStatus: String = ""
    var createdAt: String = ""
    var user_to_name: String = ""
    var user_from_name: String = ""
    var amount: String = ""
    var amount_sign: String = ""
    var transaction_mode: String = ""
    var userName: String = ""
    var image: String = ""
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.transaction_id = dictionary["transaction_id"] as? String ?? ""
        self.trnsaction_from = dictionary["trnsaction_from"] as? String ?? ""
        self.trnsaction_to = dictionary["trnsaction_to"] as? String ?? ""
        self.transaction_type = dictionary["transaction_type"] as? String ?? ""
        self.paymentType = dictionary["paymentType"] as? String ?? ""
        self.paymentStatus = dictionary["paymentStatus"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.user_to_name = dictionary["user_to_name"] as? String ?? ""
        self.user_from_name = dictionary["user_from_name"] as? String ?? ""
        self.amount = dictionary["amount"] as? String ?? ""
        self.amount_sign = dictionary["amount_sign"] as? String ?? ""
        self.transaction_mode = dictionary["transaction_mode"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""
    }
}
