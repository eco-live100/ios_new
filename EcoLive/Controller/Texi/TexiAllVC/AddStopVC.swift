//
//  AddStopVC.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit

class AddStopVC: UIViewController {
    
    @IBOutlet var mainView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.dropShadowToCollC()
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

     @IBAction func backbtnAction(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }
    @IBAction func menuTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaveLocationVC") as! SaveLocationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
}
