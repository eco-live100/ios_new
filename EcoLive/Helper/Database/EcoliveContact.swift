//
//  EcoliveContact.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 20/09/21.
//

import Foundation

class EcoliveContact {
    var id: Int = 0
    var userId: String = ""
    var userName: String = ""
    var profileImage: String = ""
    var contactEmail: String = ""
    var countryCode: String = ""
    var contactNo: String = ""
    var contactNoWithCode: String = ""
    
    init(id:Int, userId:String, userName:String, profileImage:String, contactEmail:String, countryCode:String, contactNo:String, contactNoWithCode:String) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.profileImage = profileImage
        self.contactEmail = contactEmail
        self.countryCode = countryCode
        self.contactNo = contactNo
        self.contactNoWithCode = contactNoWithCode
    }
}
