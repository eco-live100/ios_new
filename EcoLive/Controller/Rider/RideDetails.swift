//
//  RideDetails.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 30/05/22.
//

import UIKit

class RideDetails: BaseVC {

    @IBOutlet weak var imgRider: UIImageView!

    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet var viewBG: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12 : print(NSLocalizedString("Morning", comment: "Morning"))

            self.viewBG.backgroundColor = Constants.Color.NAV_TEXT_COLOR
            self.viewHeader.backgroundColor = Constants.Color.NAV_TEXT_COLOR


        case 12 : print(NSLocalizedString("Noon", comment: "Noon"))
            self.viewBG.backgroundColor = Constants.Color.NAV_TEXT_COLOR
            self.viewHeader.backgroundColor = Constants.Color.NAV_TEXT_COLOR
        case 13..<17 : print(NSLocalizedString("Afternoon", comment: "Afternoon"))

            self.viewBG.backgroundColor = Constants.Color.NAV_TEXT_COLOR
            self.viewHeader.backgroundColor = Constants.Color.NAV_TEXT_COLOR

        case 17..<22 : print(NSLocalizedString("Evening", comment: "Evening"))
            self.viewBG.backgroundColor = Constants.Color.THEME_BLACK
            self.viewHeader.backgroundColor = Constants.Color.THEME_BLACK

        default: print(NSLocalizedString("Night", comment: "Night"))

            self.viewBG.backgroundColor = Constants.Color.THEME_BLACK
            self.viewHeader.backgroundColor = Constants.Color.THEME_BLACK

            

        }
    }

    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnViewRiderRatting(_ sender: UIButton) {
        
    }
}
