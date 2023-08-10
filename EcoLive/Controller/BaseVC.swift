//
//  BaseVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 02/06/21.
//

import UIKit

class BaseVC: UIViewController {

    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = Constants.Color.NAV_BG_COLOR
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = Constants.Color.NAV_TEXT_COLOR
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white, .font : UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 18)!]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }



    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func push(controller : UIViewController){
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIViewController {
    func handleDefaultResponse(errorMessage: ErrorResponseType) {
        switch errorMessage {
        case .logout(let message):
            //TODO-Show error message
            print(message)
//            showAlertWithMessageLogout(message: message)
            GlobalData.shared.showDarkStyleToastMesage(message: message)
            
        case .serverError(let message):
            //TODO-Show error message
            print(message)
//            showAlertWithMessage(message: message)
            GlobalData.shared.showDarkStyleToastMesage(message: message)

        case .noContant(let message):
            print(message)
            GlobalData.shared.showDarkStyleToastMesage(message: message)

        case .noInternet(let message):
//            showAlertWithMessage(message: message)
            GlobalData.shared.showDarkStyleToastMesage(message: message)

        }
        
        
    }
}

