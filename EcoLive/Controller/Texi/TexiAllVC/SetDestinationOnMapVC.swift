//
//  SetDestinationOnMapVC.swift
//  DemoApp
//
//  Created by  on 16/11/22.
//

import UIKit
import MapKit

class SetDestinationOnMapVC: UIViewController {

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var mapVIew: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnDone.clipsToBounds = true
        btnDone.layer.cornerRadius = 20

        mapVIew.clipsToBounds = true
        mapVIew.layer.cornerRadius = 30
        mapVIew.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

    }
    
    @IBAction func backbtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func backDoneAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
