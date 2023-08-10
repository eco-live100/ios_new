//
//  DoctorPharmacistRegisterVC.swift
//  DemoApp
//
//  Created by  on 12/01/23.
//

import UIKit

class DoctorPharmacistRegisterVC: UIViewController {

    @IBOutlet weak var imgDoctor: UIImageView!
    @IBOutlet var btnsDoctorTyps: [UIButton]!
    @IBOutlet weak var imgGallary: UIImageView!
    @IBOutlet weak var imgCamera: UIImageView!


    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtHospitalName: UITextField!

    @IBOutlet weak var txtIdNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func btnSaveTermAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }


    @IBAction func btnDoctorTypeActions(_ sender: UIButton) {

        for (index,item) in btnsDoctorTyps.enumerated() {
            if sender == item {
                sender.isSelected = true
            }else{
                btnsDoctorTyps[index].isSelected = false
            }
        }


    }



}
