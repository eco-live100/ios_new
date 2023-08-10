//
//  SplashVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 19/07/21.
//

import UIKit
import SwiftyJSON


class SplashVC: UIViewController {
    
    //MARK: - PROPERTIES & OUTLETS -
    
    var isDataAvailable: Bool = false
    
    @IBOutlet weak var labelShowText: UILabel!
    var arrOnboarding: [OnboardingObject] = []
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelShowText.isHidden = false
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
//        self.getUtilityDataAPI()
        self.getIntroScreen()
    }
    
    //MARK: - HELPER -
    
    func setupRootController() {
        

//        //Test
//        let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
////        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        let navController = UINavigationController.init(rootViewController: controller)
//        appDelegate.window?.rootViewController = navController
//
//        return

        if self.isDataAvailable {
            if defaults.object(forKey: kAuthToken) != nil {
                if let data = defaults.value(forKey: kLoggedInUserData) as? Data,
                   let object = try? JSONDecoder().decode(UserDetail.self, from: data) {
                    objUserDetail = object
                    let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                    let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    let navController = UINavigationController.init(rootViewController: controller)
                    appDelegate.drawerController.contentViewController = navController
                    appDelegate.drawerController.menuViewController = leftMenuVC
                    appDelegate.window?.rootViewController = appDelegate.drawerController
                }
                else {
                    let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                    let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    let navController = UINavigationController.init(rootViewController: controller)
                    appDelegate.drawerController.contentViewController = navController
                    appDelegate.drawerController.menuViewController = leftMenuVC
                    appDelegate.window?.rootViewController = appDelegate.drawerController
                }
            }
            else {
                let isOnBoradingScreenDisplay: Bool = defaults.bool(forKey: isOnBoradingScreenDisplayed)
                if !isOnBoradingScreenDisplay {
                    let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
                    controller.arrOnboarding = self.arrOnboarding
                    let navController = UINavigationController.init(rootViewController: controller)
                    appDelegate.window?.rootViewController = navController
                }
                else {
                    let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                    let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    let navController = UINavigationController.init(rootViewController: controller)
                    appDelegate.drawerController.contentViewController = navController
                    appDelegate.drawerController.menuViewController = leftMenuVC
                    appDelegate.window?.rootViewController = appDelegate.drawerController
                    
                }
            }
        }else {
            defaults.set(true, forKey: isOnBoradingScreenDisplayed)
            defaults.synchronize()
            
            //:- Go to Login Page
            
            let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let navController = UINavigationController.init(rootViewController: controller)
            appDelegate.window?.rootViewController = navController
        }
    }
}

//MARK: - API CALL -

extension SplashVC {
    
    func getIntroScreen(){
        
        //self.setupRootController()

//        return
//
//        if GlobalData.shared.checkInternet() == false {
//            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
//            return
//        }
        
        let params: [String:Any] = [:]
        DispatchQueue.main.async {
            NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.INTRODUCTION_PAGE_LIST, parameters: params) { responce in
                switch responce {
                case .success(let jsondata):
                    if let payloadData = jsondata["data"] as? [[String:String]] {
                        
                        for i in 0..<payloadData.count  {
                            let objData = OnboardingObject.init(payloadData[i])
                            self.arrOnboarding.append(objData)
                        }
                        if let data = try? JSONEncoder().encode(GlobalData.shared.objConfiguration) {
                            defaults.set(data, forKey:configurationData)
                            defaults.synchronize()
                            
                            
                        }
                        self.isDataAvailable = true
                        self.setupRootController()
                        
                    }
                    
                case .failed(let errorMessage):
                    // :- Temp
                    self.isDataAvailable = true
                    self.setupRootController()
                    
                    switch errorMessage {
                    default:
                        self.handleDefaultResponse(errorMessage: errorMessage)
                        break
                    }
                }
            }
        }
    }

    func getUtilityDataAPI() {
        // Check Internet Available
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        NetworkManager.callServiceGetMethod(url: NetworkManager.API_URL + Constants.URLS.GET_UTILITY) { responce in
//            print(responce)
            switch responce {
            case .success(let jsondata):
                print(jsondata)
                if let payloadData = jsondata["data"] as? [String : Any] {
                    
                    GlobalData.shared.objConfiguration = UtilityObject.init(payloadData)
                    
                    if let data = try? JSONEncoder().encode(GlobalData.shared.objConfiguration) {
                        defaults.set(data, forKey:configurationData)
                        defaults.synchronize()
                    }
                    self.isDataAvailable = true
                    self.setupRootController()
                    
                }
                
            case .failed(let errorMessage):
                // :- Temp
                self.isDataAvailable = true
                self.setupRootController()
                
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
                
                
            }
        }
        
//        NetworkManager.callServiceGetMethod(url: NetworkManager.API_URL + Constants.URLS.GET_UTILITY, parameters: [:]) { responce in
//            print(responce)
//
//            switch responce {
//            case .success(let jsondata):
//                print(jsondata)
//                if let payloadData = jsondata["data"] as? [String : Any] {
//
//                    GlobalData.shared.objConfiguration = UtilityObject.init(payloadData)
//
//                    if let data = try? JSONEncoder().encode(GlobalData.shared.objConfiguration) {
//                        defaults.set(data, forKey:configurationData)
//                        defaults.synchronize()
//                    }
//
//                    self.isDataAvailable = true
//                    self.setupRootController()
//
//                }
//
//            case .failed(let errorMessage):
//
//                // :- Temp
//                self.isDataAvailable = true
//                self.setupRootController()
//
//                switch errorMessage {
//                default:
//                    self.handleDefaultResponse(errorMessage: errorMessage)
//                    break
//                }
//
//
//            }
//        }
    }
    
    //        AFWrapper.shared.requestGETURL(Constants.URLS.GET_UTILITY) { (JSONResponse) in
    //            if JSONResponse != JSON.null {
    //                if let response = JSONResponse.rawValue as? [String : Any] {
    //                    print(response)
    //                    if response["status"] as? Int ?? 0 == successCode {
    //                        let payloadData = response["data"] as! [String : Any]
    //
    //                        GlobalData.shared.objConfiguration = UtilityObject.init(payloadData)
    //
    //                        if let data = try? JSONEncoder().encode(GlobalData.shared.objConfiguration) {
    //                            defaults.set(data, forKey:configurationData)
    //                            defaults.synchronize()
    //                        }
    //
    //                        self.isDataAvailable = true
    //                        self.setupRootController()
    //                    }
    ////                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
    ////                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
    ////                    }
    //                    else {
    //                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
    //                    }
    //                }
    //            }
    //        } failure: { (error) in
    //            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
    //        }
}


