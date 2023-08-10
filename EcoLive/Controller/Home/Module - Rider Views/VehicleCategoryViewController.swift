//
//  VehicleCategoryViewController.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 04/07/22.
//

import UIKit

class VehicleCategoryViewController: UIViewController {

    static func getObject()-> VehicleCategoryViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VehicleCategoryViewController") as? VehicleCategoryViewController
        if let vc = vc {
            return vc
        }
        return VehicleCategoryViewController()
    }
    
    @IBOutlet weak var labelPedestrian, labelBioDieselEthanolHybridmotor, labelElectricVehicle, labelPatrolGasolineDiesel, labelCycle :UILabel!
    
    var arrayOFVehicleCategory : [UILabel] = [UILabel]()
    var strVehicleFuelType : String = ""
    var buttonSubmitCallBack: ((String) -> ())!
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOFVehicleCategory.append(labelPedestrian)
        arrayOFVehicleCategory.append(labelBioDieselEthanolHybridmotor)
        arrayOFVehicleCategory.append(labelElectricVehicle)
        arrayOFVehicleCategory.append(labelPatrolGasolineDiesel)
        arrayOFVehicleCategory.append(labelCycle)
        labelPedestrian.font = UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: 13)!
        strVehicleFuelType = "Pedestrian"
    }
    
    //MARK: - ACTIONS
    @IBAction func actionSelectCategory(_ sender: UIButton) {
        
        for item in arrayOFVehicleCategory{
            item.font = UIFont.systemFont(ofSize: 13.0)
        }
        
        if sender.tag == 0{
            strVehicleFuelType = "Pedestrian"
            labelPedestrian.font = UIFont.boldSystemFont(ofSize: 13.0)
        } else if sender.tag == 1{
            strVehicleFuelType = "Cycle"
            labelCycle.font = UIFont.boldSystemFont(ofSize: 13.0)
        }else if sender.tag == 2{
            strVehicleFuelType = "Electric Vehicle"
            labelElectricVehicle.font = UIFont.boldSystemFont(ofSize: 13.0)
        }else if sender.tag == 3{
            strVehicleFuelType = "Patrol, Gasoline, Diesel"
            labelPatrolGasolineDiesel.font = UIFont.boldSystemFont(ofSize: 13.0)
        }else if sender.tag == 4{
            strVehicleFuelType = "Bio Diesel, Ethanol, Hybrid motor"
            labelBioDieselEthanolHybridmotor.font = UIFont.boldSystemFont(ofSize: 13.0)
        }
    }
    
    @IBAction func actionCloseButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func actionSubmitButton(_ sender: UIButton) {
        buttonSubmitCallBack?(strVehicleFuelType)
        self.dismiss(animated: false)
    }
}
