//
//  ddViewController.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 23/06/22.
//

import UIKit

class ddViewController: UIViewController {
    
    static func getObject()-> ddViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ddViewController") as? ddViewController
        if let vc = vc {
            return vc
        }
        return ddViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
