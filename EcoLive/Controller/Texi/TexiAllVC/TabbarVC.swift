//
//  TabbarVC.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit

var TaxiTabbarObj : TaxiTabbarVC!

class TaxiTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaxiTabbarObj = self

        self.tabBar.tintColor = UIColor.black
        self.tabBar.backgroundColor = .white
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
