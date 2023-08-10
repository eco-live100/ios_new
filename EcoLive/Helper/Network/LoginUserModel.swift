//
//  LoginUserModel.swift
//  Kidsid
//
//  Created by Shubham Sharma on 05/06/19.
//  Copyright © 2019 Shubham. All rights reserved.
//

import Foundation
import UIKit


//class LoginUserModel {
//    
//    //	var gender:String = ""
//
//    //	var date_of_birth:String = ""
//
//    fileprivate var _access_token: String = ""
//
//    //fileprivate var user = UserModel()
//
//
////    var userData: UserModel {
////        get{
////            return user
////        }
////    }
//
////    var id: String {
////        get{
////            return obj.prefs.object(forKey: App_User_Id) as? String ?? ""
////        }
////    }
//
//    var email: String {
//        get{
//            return user.email
//        }
//    }
//
//
//    var name: String {
//        get{
//            return user.name
//        }
//    }
//
//    var gender: String {
//        get{
//            return user.gender
//        }
//    }
//
//    var fitness_level: String {
//        get{
//            return user.fitness_level
//        }
//    }
//
//
//
//
//    var isPro: Bool {
//        get {
//            return user.ispro == "yes"
//        }
//    }
//
//    var age: String {
//        get {
//            return user.age
//        }
//    }
//
//    var fitness_goal: String {
//        get {
//            return user.fitness_goal
//        }
//    }
//
//    var image: String {
//        get {
//            return user.image
//        }
//    }
//
//    var token: String {
//        get {
//            //            return "as\(_token)"
//            return _access_token
//        }
//    }
//
//    var allowNotification: Bool {
//        get {
//            return user.allowNotification
//        }
//    }
//
//
//
//
//
//    var fCMToken: String {
//        get {
//            guard let token = UserDefaults.standard.value(forKey: UserDefaultKey.USER_FCM_TOKEN) as? String else {
//                return ""
//            }
//            return  token
//
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.USER_FCM_TOKEN) //Bool
//        }
//    }
//
//    public static let shared = LoginUserModel()
//
//    init(){
//        refresh()
//    }
//
//    func refresh() {
//        if let userData = UserDefaults.standard.value(forKey: UserDefaultKey.USER_INFO) as? [String: Any],
//            let userInfo = userData["user_info"] as? [String: Any] {
//            if let id = userInfo["id"] as? NSString {
//                user.id = id
//            } else if let id = userInfo["id"] as? NSNumber {
//                user.id = id.stringValue as NSString
//            }
//
//            user.name = userInfo["name"] as? String ?? ""
//            user.email  = userInfo["email"] as? String ?? ""
//            user.gender = userInfo["gender"] as? String ?? ""
//            user.height_metric = userInfo["height_metric"] as? String ?? ""
//
//            user.height_imperial  = userInfo["height_imperial"] as? String ?? ""
//            user.weight_kg  = userInfo["weight_kg"] as? String ?? ""
//            user.weight_lbs = userInfo["weight_lbs"] as? String ?? ""
//            user.fitness_level  = userInfo["fitness_level"] as? String ?? ""
//            user.fitness_goal  = userInfo["fitness_goal"] as? String ?? ""
//
//            user.age  = userInfo["age"] as? String ?? ""
//
//            user.ispro = userInfo["ispro"] as? String ?? "no"
//            user.image = userInfo["image"] as? String ?? ""
//            user.allowNotification = userInfo["allowNotification"] as? String ?? "true" == "true"
//
//            self._access_token = userData["access_token"] as? String ?? ""
//
//
//
//        }else{
//            user.id = "0"
//            self._access_token = ""
//        }
//    }
//    func login(userData: [String: Any])  {
//        var newUserData = userData//.removeValue(forKey: "image")
//        var userInfo: [String: Any] = userData["user_info"] as! [String : Any]
//        userInfo["image"] = ""
//        newUserData["user_info"] = userInfo
//
//        UserDefaults.standard.set(newUserData, forKey: UserDefaultKey.USER_INFO)
//        refresh()
//    }
//
//    func update(userData: [String: Any])  {
//        var newUserData = userData//.removeValue(forKey: "image")
//        //        var userInfo: [String: Any] = userData["user_info"] as! [String : Any]
//        //        userInfo["image"] = ""
//        //        newUserData["user_info"] = userInfo
//
//        if var oldData = UserDefaults.standard.value(forKey: UserDefaultKey.USER_INFO) as? [String: Any] {
//            //oldData.merge(dictionaries: newUserData)
//            print(oldData)
//
//
//
//            UserDefaults.standard.set(oldData, forKey: UserDefaultKey.USER_INFO)
//            refresh()
//        }
//    }
//
//    func onBoardingFinished()  {
//        if var userID = UserDefaults.standard.value(forKey: UserDefaultKey.USER_INFO) as? [String: Any] {
//            userID["proceed"] = "1"
//            login(userData: userID)
//        }
//    }
//    var isTmpLogin: Bool {
//        get {
//            return user.id.integerValue != 0
//        }
//    }
//    var isLogin:Bool {
//        get {
//            return user.id.integerValue != 0
//
//        }
//    }
//
//
//
//    var profileImage: String? {
//        get {
//            return UserDefaults.standard.value(forKey: UserDefaultKey.PROFILE_IMAGE) as? String
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.PROFILE_IMAGE)
//        }
//    }
//
//
//    var isSynced:Bool {
//        get {
//            guard let token = UserDefaults.standard.value(forKey: UserDefaultKey.FIRST_SYNC) as? Bool else {
//                return false
//            }
//            return token
//
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.FIRST_SYNC) //Bool
//        }
//    }
//
//
//    func logout()  {
//        UserDefaults.standard.removeObject(forKey: UserDefaultKey.USER_INFO)
//        UserDefaults.standard.synchronize()
//        refresh()
//    }
//}

class UserDefaultKey {
    static let USER_INFO = "com.emizentech.NightOut.data"
    static let USER_FCM_TOKEN = "com.emizentech.NightOut.FCMToken"
    
    static let FIRST_SYNC = "com.emizentech.NightOut.FIRST_SYNC"
    //	static let TOP_SCORER = "com.emizentech.NightOut.TOP_SCORER"
    static let ALL_PLACES = "com.emizentech.NightOut.ALL_PLACES"
    static let TRAIN_IMAGE = "com.emizentech.NightOut.TRAIN_IMAGE"
    static let EXERCISES_IMAGE = "com.emizentech.NightOut.EXERCISES_IMAGE"
    static let PROFILE_IMAGE = "com.emizentech.NightOut.PROFILE_IMAGE"
    static let STATISTICS_IMAGE = "com.emizentech.NightOut.STATISTICS_IMAGE"
    static let AGENDA_IMAGE = "com.emizentech.NightOut.AGENDA_IMAGE"
    static let FITNESS_SHOP_IMAGE = "com.emizentech.NightOut.FITNESS_SHOP_IMAGE"
    static let CONTACT_US_IMAGE = "com.emizentech.NightOut.CONTACT_US_IMAGE"
    static let TIMER_INDICATOR = "com.emizentech.NightOut.TIMER_INDICATOR"
}

