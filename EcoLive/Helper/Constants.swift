// 
//  Constants.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 02/06/21.
//

import UIKit
import CoreLocation

let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
let defaults = UserDefaults.standard

let stripePublishableKey = "pk_test_51JDSCaICa4fFFXRVSIO3i98o36VOzpcGYjWnoMYnmdrHUEmUfYU0BjCzNkBm6kxi6m22rO2026aGPwGOuPab9bxH00S4EitXbr"

let googleMapAPIKey = "AIzaSyBLbppC7WO6c-WOD0V_YIocVKoA4NKcE50"//"AIzaSyDfBFnLvP9n_BL9scTVB5op6V-x13T7oeQ"
let twilio_pushKey = "CR12cce1eafb9245814a8031e0bb1315b2"
let twilio_sId = "AP0494ec71bce6faeb3e8ce69129f1e2c8"

var objUserDetail = UserDetail()

var isAnyCallActive:Bool = false

let ALPHA_NUMERIC: String = " ,-.ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
let NUMERIC: String = ".1234567890"
let fakeUDID = "8a84f85d87b06b1dae1b47d448f85e6e"

let kWebViewSource: String = "var meta = document.createElement('meta');" +
"meta.name = 'viewport';" +
"meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
"var head = document.getElementsByTagName('head')[0];" +
"head.appendChild(meta);"

let DATE_FORMAT: String = "dd/MM/yyyy"

let DEBUG: Bool = true

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

let successCode = 1
let successCodeNew = 200
let invalidTokenCode = 500

struct Constants {
    static let APP_NAME = "Eco Live"
    struct URLS {
        //DEV URL
        static let BASE_URL = NetworkManager.API_URL//"https://ecolive.ezxdemo.com/server/api1/" //https://www.ecolive.global:3001/api/"
        //LIVE URL
//        static let BASE_URL = ""
    
        static let GET_UTILITY = "utility"
        static let INTRODUCTION_PAGE_LIST = "introduction-page-list"
        static let LOGIN = "user-login" //"auth/login"
        static let SOCIAL_LOGIN = "social-login" 
        static let SIGNUP = "user-signup" //auth/register"
        static let SENDMOBILEOTP = "send-mobile-otp"
        static let SENDEMAILOTP = "send-email-otp"
        static let VERIFYMOBILEOTP = "verify-mobile-otp"
        static let VERIFYEMAILOTP = "verify-email-otp"
        static let VEHICLECATEGORIESLIST = "vehicle-categories-list"
        static let RIDER_VEHICLE_DETAILS_SUBMIT = "rider-vehicle-details"
        static let VENDER_SHOP_DETAILS =  "vendor-shop-details"
        static let GET_PROFILE_DETAILS = "get-user-profile"
        static let UPDATE_USER_PROFILE = "update-user-profile"
        static let UPDATE_USER_BGIMAGE = "update-background-picture"
        static let USER_RESET_PASSWORD = "reset-password"
        static let GET_RIDER_VEHCLE_DETAILS = "get-rider-vehicle-details"
        
        static let GET_VENDER_SHOP_LIST = "vendor-shop-list"
        static let PRODUCT_ATTRIBUTE_FORM = "product-attribute-form"
        static let ADD_PRODUCT = "add-product"
        //Shop
        static let GET_SHOP_CATEGORIES_LIST = "shop-categories-list"
        static let ADD_VENDOR_SHOP_DETAILS = "vendor-shop-details"
        static let VENDOR_SHOP_ADDED_LIST = "vendor-shop-product-list"
        static let GETSTOREATTRIBUTE = "getStoresAttribute"

        //[9:48 PM, 12/3/2022] Nikhil Emizen: vendorShopId
//        [9:48 PM, 12/3/2022] Nikhil Emizen: categoryId
//        [9:48 PM, 12/3/2022] Nikhil Emizen: location
//        [9:48 PM, 12/3/2022] Nikhil Emizen: productId
//        [9:49 PM, 12/3/2022] Nikhil Emizen: location ka object aaega location = { lat : 34344.3443, long : 34.4343}

        static let SHOP_CATEGORY = "shopCategory"
        static let GET_SHOP = "shop"
        static let GET_PRODUCT_LIST = "product/list"
        static let GET_PRODUCT_CATEGORY = "category"
        static let GET_SUBPRODUCT_CATEGORY = "subCategory"
//        static let ADD_PRODUCT = "addProduct"
        static let UPDATE_PRODUCT = "product/editProduct"
        static let DELETE_PRODUCT = "product"
        static let SEARCH_PRODUCT = "product/search"
        static let PRODUCT_DETAIL = "product"
     //   static let FAVOURITE_PRODUCT_LIST = "favorite/getFavoriteList" // old
        static let FAVOURITE_PRODUCT_LIST = "wishlist" // new
        static let SIMILAR_PRODUCT = "similar-product" // new



      //  static let FAVOURITE_PRODUCT = "favorite" // old
        static let FAVOURITE_PRODUCT = "like-dislike-product" // new

        static let GET_PROFILE = "auth/getProfile"
        static let UPDATE_PROFILE = "auth/updateProfile"
        static let VEHICLE_INFORMATION = "vehical"
        static let GET_ADDRESS = "auth/getShippingAddress"
        static let ADD_UPDATE_ADDRESS = "auth/addUpdateShippingAddress"
        static let CART = "cart"
        static let ORDER = "order"
        static let BUYNOW = "order/buyNow"
        static let CHECK_SECURITY = "auth/checkSecurity"
        static let WALLET_BALANCE = "auth/wallet"
        static let ADD_MONEY_WALLET = "transaction/addAmountInWallet"
        static let CARD = "card"
        static let CONTACT_SYNC = "auth/syncContact"
        static let TRANSFER_TO_WALLET = "transaction/walletToWallet"
        static let TRANSFER_TO_BANK = "transaction/transferToBank"
        static let TRANSACTION_HISTORY = "transaction/transactionHistory"
        static let PROFILE_BY_EMAIL = "auth/profileByEmail"
        static let PROFILE_BY_ID = "auth/profileByUserId"
        static let GET_TWILIO_VOICE_TOKEN = "audioVideoCall/audioToken"
        static let GET_TWILIO_VIDEO_TOKEN = "audioVideoCall/videoToken"
        static let UPDATE_RIDER_LOCATION = "vehical"
        static let SHOP_ORDER = "order/orderForShop"
        static let RIDER_ORDER = "delivery/getList"
        static let ACCEPT_DECLINE_ORDER = "delivery/acceptDecline"
        static let GET_MESSAGES = "chat/getMessages"
        static let STORE_MESSAGE = "chat"
        static let NEARBY_PRODUCT = "shop/near_shop"
        static let NEAR_RIDER = "vehical/near_rider"
        static let CALL_NOTIFICATION = "audioVideoCall/callNotification"
        static let GET_THREAD_LIST = "chat/getAllMessageThreads"

        static let GET_ADDRESS_New = "address"
        static let DELETE_ADDRESS = "address-delete"

 
    }
    
    struct Color {
        
        static let NAV_BG_COLOR = UIColor.init(hex: 0x050D4C) //Constants.Color.THEME_YELLOW
        static let NAV_TEXT_COLOR = UIColor.white
        static let NAV_BORDER_COLOR = UIColor.white
        
        static let TAB_BARTINT = UIColor.init(hexString: "F9F9F9")!
        static let TAB_NORMAL = UIColor.init(hexString: "333333")!
        static let TAB_SELECTED = UIColor.init(hexString: "3663f5")!
        
        static let THEME_BLUE = UIColor.init(hex: 0x050D4C)
        static let THEME_BLACK = UIColor.init(hex: 0x333333)
        static let THEME_YELLOW = UIColor.init(hex: 0x3663F5)
        static let GrayColor = UIColor.init(hex: 0x9F9F9F)
        static let blackColor = UIColor.init(hex: 0x000000)

    

        
        static let SEARCHBAR_PLACEHOLDER = UIColor.init(hex: 0x9F9F9F)
        static let SEARCHBAR_IMAGE = UIColor.init(hex: 0x9F9F9F)
        
    }
    
    struct Font {
        static let ROBOTO_REGULAR = "Roboto-Regular"
        static let ROBOTO_MEDIUM = "Roboto-Medium"
        static let ROBOTO_BOLD = "Roboto-Bold"
        
//        static let SEGOE_UI_REGULAR = "SegoeUI"
//        static let SEGOE_UI_BOLD = "SegoeUI-Bold"
    }
    
    struct ScreenSize {
        static let SCREEN_RECT = UIScreen.main.bounds
        static let SCREEN_WIDTH = SCREEN_RECT.size.width
        static let SCREEN_HEIGHT = SCREEN_RECT.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType {
        static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
        static let IS_IPHONE_11_PRO_MAX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
        static let IS_IPHONE_12_PRO = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 844.0
        static let IS_IPHONE_12_PRO_MAX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 926.0
        
        //IPAD
        static let IS_IPAD_PRO = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 768.0
        static let IS_IPAD_PRO_2ndGEN = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 834.0
        static let IS_IPAD_PRO_4thGEN = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 810.0
        static let IS_IPAD_AIR_3rdGEN = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 834.0
        static let IS_IPAD_AIR_4thGEN = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 820.0
        //WIDTH
        //1024
        //1194
        //1366
        //1080
        //1112
        //1180
    }
    
    struct CometChat {
        static let appId = "209820bf9decd0b5"//"19919008322d1df7" OLD
        static let authKey = "5252b94b18901eae3697ca3e4317b2e8a440d9bd"//"e1fa403b96f068f70cfe329fa766cd2d5a75efe4" //OLD
        static let region = "us"
    }
}

struct Document {
    let uploadParameterKey: String
    let data: Data
    let name: String
    let fileName: String
    let mimeType: String
    var image: UIImage?
}

struct ReversedGeoLocation {
    let name: String            // eg. Apple Inc.
    let streetName: String      // eg. Infinite Loop
    let streetNumber: String    // eg. 1
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US

    var formattedAddress: String {
        return """
        \(name),
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
    }

    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}

struct CoordinateObject {
    var name: String
    var lat: Double
    var long: Double
    var image: String
}

struct ColorDataObject: Codable {
    var hexcode: String
    var color_name: String
}

struct FetchedContact: Codable {
//    var firstName: String
//    var lastName: String
    var name: String
    var contact: String
//    var image: String
}

//MARK: - ENUM -

enum JPEGQualityType: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}

enum MyError: Error {
    case FoundNil(String)
}

enum TextFieldImageSide {
    case left
    case right
}

//DEVICE
enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone
    case pad
}

//API REQUEST
enum REQUEST : Int {
    case notStarted = 0
    case started
    case failedORNoMoreData
}

//MARK: - KEYS -

let kAppName = "Eco-Live"
let kDeviceType = "ios"
var kInternetUnavailable = "Please check your internet connection and try again."
var kNetworkError = "Sorry we are unable to connect with the server, please try again later"
let kPleaseWait = "Please Wait"
let kAlert = "Alert"

let kDeviceId = UIDevice.current.identifierForVendor?.uuidString
var kDeviceFCMTokan = ""

//USERDEFAULTS KEYS
let kAuthToken = "_token"
let configurationData = "configData"
let isOnBoradingScreenDisplayed = "isOnBoradingScreenDisplayed"
let kRememberMe = "rememberMe"
let kRememberEmail = "rememberEmail"
let kRememberPassword = "rememberPassword"
let kLoggedInUserData = "loggedInUserData"

//NOTIFICATIONCENTER KEYS
let kUpdateShopList = "UpdateShopList"
let kUpdateShopInformation = "UpdateShopInformation"
let kUpdateProductList = "UpdateProductList"
let kUpdateAddressList = "UpdateAddressList"
let kUpdateCartList = "UpdateCartList"
let kUpdateWishList = "UpdateWishList"
let kUpdateCardDetail = "UpdateCardDetail"
let kUpdateWalletBalance = "UpdateWalletBalance"
let kAddNewMessage = "AddNewMessage"
