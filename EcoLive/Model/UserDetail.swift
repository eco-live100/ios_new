//
//  UserDetail.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 19/07/21.
//

import UIKit

class UserDetail: NSObject, Codable {
    
    var _id: String = ""
    var userName: String = ""
    var email: String = ""
    var userType: String = ""
    var profileImage: String = ""
    var profileBGImage: String = ""
    var countryCode: String = ""
    var fullContact: String = ""
    var googleId: String = ""
    var facebookId: String = ""
    var instagramId: String = ""
    var createdAt: String = ""
    var accessToken: String = ""
    var emailVerified : String = ""
    var mobileVerified : String = ""
    var notificationFound : String = ""
    var refereshToken: String = ""
    var getNotification: String = ""
    var mobileNumber: String = ""
    var isRider: Bool = false
    var isRiderVerified: Bool = false
    var isVendor: Bool = false
    var isVendorVerified: Bool = false
    var firstName:String = ""
    var lastName: String = ""
    var contactNo: String = ""
    var isEmailVerified: Bool = false
    
    class func initWith(dict: Dictionary<String, Any>) -> UserDetail {
        
        let object = UserDetail()
        
        if let id = dict["_id"] as? String {
            object._id = id
        }
        if let userName = dict["fullName"] as? String {
            object.userName = userName
        }
        if let email = dict["email"] as? String {
            object.email = email
        }
        if let userType = dict["role"] as? String {
            object.userType = userType
        }
        if let profileImage = dict["profilePicture"] as? String {
            object.profileImage = profileImage
        }
        if let profileImage = dict["backgroundPicture"] as? String {
            object.profileBGImage = profileImage
        }
        if let countryCode = dict["countryCode"] as? String {
            object.countryCode = countryCode
        }
        if let mobileNumber = dict["mobileNumber"] as? String {
            object.mobileNumber = mobileNumber
        }
        if let fullContact = dict["fullContact"] as? String {
            object.fullContact = fullContact
        }
        if let googleId = dict["googleId"] as? String {
            object.googleId = googleId
        }
        if let facebookId = dict["facebookId"] as? String {
            object.facebookId = facebookId
        }
        if let instagramId = dict["instagramId"] as? String {
            object.instagramId = instagramId
        }
        if let createdAt = dict["createdAt"] as? String {
            object.createdAt = createdAt
        }
        if let accessToken = dict["accessToken"] as? String {
            object.accessToken = accessToken
        }
        if let emailVerified = dict["emailVerified"] as? String {
            object.emailVerified = emailVerified
        }
        if let mobileVerified = dict["mobileVerified"] as? String {
            object.mobileVerified = mobileVerified
        }
        if let notificationFound = dict["notificationFound"] as? String {
            object.mobileVerified = notificationFound
        }
        if let getNotification = dict["getNotification"] as? String {
            object.getNotification = getNotification
        }
        if let refereshToken = dict["refereshToken"] as? String {
            object.refereshToken = refereshToken
        }
        
        if let isRider = dict["isRider"] as? Bool {
            object.isRider = isRider
        }
        if let isRiderVerified = dict["isRiderVerified"] as? Bool{
            object.isRiderVerified = isRiderVerified
        }
        if let isVendor = dict["isVendor"] as? Bool {
            object.isVendor = isVendor
        }
        if let isVendorVerified = dict["isVendorVerified"] as? Bool{
            object.isVendorVerified = isVendorVerified
        }
        if let firstName = dict["firstName"] as? String {
            object.firstName = firstName
        }
        if let lastName = dict["lastName"] as? String {
            object.lastName = lastName
        }
        let checkEmailVerified = dict["checkEmailVerified"] as? NSDictionary
        if let emailVerified = checkEmailVerified!["emailVerified"] as? Bool {
            object.isEmailVerified = emailVerified
        }

        return object
    }
}

 
// MARK: - GetCurrentRole
class GetCurrentRole: Codable {
    let currentRole: String

    init(currentRole: String) {
        self.currentRole = currentRole
    }
}


