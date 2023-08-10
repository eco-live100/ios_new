//
//  AppDelegate.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 01/06/21.
//

import UIKit
import IQKeyboardManagerSwift
import SideMenuSwift
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Stripe
import UserNotifications
import PushKit
import CometChatPro
import FacebookCore
import Firebase
//import Swifter
import TwitterKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let drawerController = SideMenuController()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    class func shared() -> (AppDelegate) {
        let sharedinstance = UIApplication.shared.delegate as! AppDelegate
        return sharedinstance
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GlobalData.shared.isPresentedChatView = false
        self.setApperance()
        GMSServices.provideAPIKey(googleMapAPIKey)
        GMSPlacesClient.provideAPIKey(googleMapAPIKey) // Places API Key
        
        STPAPIClient.shared.publishableKey = stripePublishableKey
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.toolbarTintColor = UIColor.black
        IQKeyboardManager.shared.placeholderColor = UIColor.init(hex: 0x000000, a: 0.7)
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIView.self)

//        IQKeyboardManager.shared.disabledToolbarClasses.append(ChatVC.self)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatVC.self)

        
        SideMenuController.preferences.basic.menuWidth = (UIScreen.main.bounds.width * 0.8)
        SideMenuController.preferences.basic.statusBarBehavior = .none
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.supportedOrientations = .portrait
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
        SideMenuController.preferences.animation.shadowAlpha = 0.8
        SideMenuController.preferences.animation.shadowColor = UIColor.init(hex: 0x333333, a: 1.0)
        
        self.initializeCometChat()
        CometChatCallManager().registerForCalls(application: self)
       
        GlobalData.shared.customizationSVProgressHUD()
        self.registerForPushNotifications()
        FirebaseApp.configure()
        
        TWTRTwitter.sharedInstance().start(withConsumerKey:TwitterConstants.CONSUMER_KEY, consumerSecret:TwitterConstants.CONSUMER_SECRET_KEY)
        
//        let address = "1 Infinite Loop, CA, USA"
//        let geocoder = CLGeocoder()
//
//        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
//            if((error) != nil){
//                print("Error", error)
//            }
//            if let placemark = placemarks?.first {
//                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
//                coordinates.latitude
//                coordinates.longitude
//                print("lat", coordinates.latitude)
//                print("long", coordinates.longitude)
//
//
//            }
//        })
        
//        sleep(5)

//        let vc = MyGroceryHome.getObject()
//        self.window?.rootViewController = vc
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        CometChat.configureServices(.willResignActive)
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if TWTRTwitter.sharedInstance().application(app, open: url, options: options) {
            return true
        }
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
//        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
//        Swifter.handleOpenURL(url, callbackURL: URL(string: TwitterConstants.CALLBACK_URL)!)
//        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        CometChat.configureServices(.didEnterBackground)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
       
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if (extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard) {
            return false
        }
        return true
    }

    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var handle: Bool = true
        
        let options: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject, UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
        
        handle = TWTRTwitter.sharedInstance().application(application, open: url, options: options)
        return handle
    }

   
    
    func initializeCometChat() {
        if(Constants.CometChat.appId.contains("Enter") || Constants.CometChat.appId.contains("ENTER") || Constants.CometChat.appId.contains("NULL") || Constants.CometChat.appId.contains("null") || Constants.CometChat.appId.count == 0) {
        } else {
            let appSettings = AppSettings.AppSettingsBuilder().subscribePresenceForAllUsers().setRegion(region: Constants.CometChat.region).build()
            
            let _ =  CometChat.init(appId:Constants.CometChat.appId, appSettings: appSettings, onSuccess: { (Success) in
                print( "Initialization onSuccess \(Success)")
                CometChat.setSource(resource: "ui-kit", platform: "ios", language: "swift")
            }) { (error) in
                print( "Initialization Error Code:  \(error.errorCode)")
                print( "Initialization Error Description:  \(error.errorDescription)")
            }
        }
    }
    
    func endBackgroundTask() {
        debugPrint("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    func setApperance() {
        UITabBar.appearance().itemWidth = (window?.frame.size.width)! / 5
        UITabBar.appearance().barTintColor = Constants.Color.TAB_BARTINT
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: Constants.Font.ROBOTO_REGULAR, size: 9)!, NSAttributedString.Key.foregroundColor: Constants.Color.TAB_NORMAL], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: Constants.Font.ROBOTO_REGULAR, size: 9)!, NSAttributedString.Key.foregroundColor: Constants.Color.TAB_SELECTED], for: .selected)
    }
    
    func logoutUser() {
        DispatchQueue.main.async {
            objUserDetail = UserDetail()
            
            let db:DBHelper = DBHelper()
            db.deleteAllPhoneContact()
            db.deleteAllEcoliveContact()
            
            GlobalData.shared.arrCartList = []
            GlobalData.shared.arrPhoneContactDB = []
            GlobalData.shared.arrEcoliveContact = []
            
            defaults.set(nil, forKey: kAuthToken)
            defaults.removeObject(forKey: kAuthToken)
            defaults.removeObject(forKey: kLoggedInUserData)
            defaults.synchronize()
//            self.goToHomePage()
            self.pushRootLoginView()
            CometChat.logout(onSuccess: { (success) in
                DispatchQueue.main.async {
                    //self.pushRootLoginView()
                }
            }) { (error) in
                DispatchQueue.main.async {
                    CometChatSnackBoard.display(message:  error.errorDescription, mode: .error, duration: .short)
                    //self.pushRootLoginView()
                }
            }
        }
    }
        
    func pushRootLoginView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let navController = UINavigationController.init(rootViewController: controller)
            appDelegate.window?.rootViewController = navController
        }
    }
    
    func goToHomePage(){
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.hideMenu(animated: true, completion:nil)
    }
}

// MARK: - PUSH NOTIFICATION CODE -

extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            debugPrint("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        defaults.set(token, forKey: "deviceToken")
        defaults.synchronize()
        debugPrint("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        debugPrint("Failed to register for remote notifications with error: \(error)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint("The Push Notification: \(userInfo)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        debugPrint("The Push Notification: \(response.notification.request.content.userInfo)")
        debugPrint("When app is in background and tapped notification")
        
        if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
            debugPrint("The userinfo is : ==> \(userInfo)")
            
            if let aps = userInfo["aps"] as? [String: Any] {
                if let alert = aps["alert"] as? [String: Any] {
                    let type = "\(alert["push_type"] ?? "")"
                    if type == "chat" {
                        if GlobalData.shared.isPresentedChatView == true {
                            if let data = alert["data"] as? Dictionary<String,Any> {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAddNewMessage), object: nil, userInfo: data)
                            }
                        } else {
                            if let data = alert["data"] as? Dictionary<String,Any> {
                                let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                                controller.notificationUserID = "\(data["sender_id"] ?? "")"
                                controller.notificationUserContact = "\(data["sender_contact"] ?? "")"
                                controller.isComeFromPushNotification = true
                                controller.isFromFriendList = false
    //                            controller.backgroundColor = self.viewBG.backgroundColor!
                                let navController = UINavigationController(rootViewController: controller)
                                appDelegate.window?.rootViewController = navController
                            }
                        }
                    }
                    else if type == "calling" {
//                        if self.isFromPushLaunch == false {
                            if isAnyCallActive == false {
                                debugPrint("calling action")
                            }
//                        }
                    }
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let userInfo = notification.request.content.userInfo as? [String: Any] {
            debugPrint("The userinfo is : ==> \(userInfo)")
            debugPrint("When app is in foreground")
            debugPrint("Pushnotification count is -----")
            
            let state = UIApplication.shared.applicationState
            
            if state == .active {
                if let aps = userInfo["aps"] as? [String: Any] {
                    if let alert = aps["alert"] as? [String: Any] {
                        let type = "\(alert["push_type"] ?? "")"
                        if type == "chat" {
                            if GlobalData.shared.isPresentedChatView == true {
                                if let data = alert["data"] as? Dictionary<String,Any> {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAddNewMessage), object: nil, userInfo: data)
                                }
                            } else {
                                completionHandler(.alert)
                            }
                        }
                        else if type == "calling" {
                            if isAnyCallActive == false {
                                debugPrint("calling action")
                            }
                        }
                        else {
                            completionHandler(.alert)
                        }
                    }
                }
            } else {
                completionHandler(.alert)
            }
        } else {
            completionHandler(.alert)
        }
    }
}

//MARK: - API CALL -

extension AppDelegate {
    
}
