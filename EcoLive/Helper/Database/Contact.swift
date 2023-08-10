//
//  Contact.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 10/09/21.
//

import Foundation

class Contact {
    var id: Int = 0
    var username: String = ""
    var phonenumber: String = ""
    var profileImage: String = ""
    
    init(id:Int, username:String, phonenumber:String, profileImage:String) {
        self.id = id
        self.username = username
        self.phonenumber = phonenumber
        self.profileImage = profileImage
    }
}
