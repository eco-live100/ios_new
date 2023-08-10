//
//  SoleProprietorsCorporationsSelectionVC.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 23/06/22.
//

import UIKit

class SoleProprietorsCorporationsSelectionVC: UIViewController {

    static func getObject()-> SoleProprietorsCorporationsSelectionVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SoleProprietorsCorporationsSelectionVC") as? SoleProprietorsCorporationsSelectionVC
        if let vc = vc {
            return vc
        }
        return SoleProprietorsCorporationsSelectionVC()
    }
    //MARK: - PROPERTIES & OUTLETS
    @IBOutlet weak var proprietorTableView: UITableView!
    @IBOutlet weak var soleProprietorsView: UIView!
    @IBOutlet weak var corporationsView: UIView!
    @IBOutlet weak var buttonsoleProprietor: UIButton!
    @IBOutlet weak var buttoncorporation: UIButton!
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsoleProprietor.borderWidth = 1.0
        
    }
    //MARK: - SETUP VIEW
    
    //MARK: - ACTIONS
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSoleProprietorsButton(_ sender: UIButton) {
        soleProprietorsView.isHidden = false
        corporationsView.isHidden = true
        proprietorTableView.reloadData()
        
        buttoncorporation.borderWidth = 0.0
        buttonsoleProprietor.borderWidth = 1.0
       
    }
    
    @IBAction func actionCorporationsButton(_ sender: UIButton) {
        soleProprietorsView.isHidden = true
        corporationsView.isHidden = false
        proprietorTableView.reloadData()
        
        buttonsoleProprietor.borderWidth = 0.0
        buttoncorporation.borderWidth = 1.0
    }
    
    @IBAction func actionSoleProprietors(_ sender: UIButton) { 
        let view = SoleProprietorsRegistrationVC.getObject()
        view.typeofRegistration = "Sole Proprietors"
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func actionCorporations(_ sender: UIButton) {
        let view = SoleProprietorsRegistrationVC.getObject()
        view.typeofRegistration = "Corporation"
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}

