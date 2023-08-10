//
//  SaveLocationVC.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit

class SaveLocationVC: UIViewController {
    
    @IBOutlet var tblView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "SaveLocationTVCell", bundle: nil), forCellReuseIdentifier: "SaveLocationTVCell")
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

     @IBAction func backbtnAction(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }

    @IBAction func btnallAction(_ sender: UIButton) {

        if sender.tag == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseDestinationVC") as! ChooseDestinationVC
            self.navigationController?.pushViewController(vc, animated: true)

        }

        if sender.tag == 3 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddStopVC") as! AddStopVC
            self.navigationController?.pushViewController(vc, animated: true)

        }



    }
}
extension SaveLocationVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        let cell = tblView.dequeueReusableCell(withIdentifier: "SaveLocationTVCell") as! SaveLocationTVCell

        cell.savedbtn.addTarget(self, action: #selector(savedbtnTapped(_:)), for: .touchUpInside)
        cell.btnDestination.addTarget(self, action: #selector(destinationdbtnTapped(_:)), for: .touchUpInside)
      
        return cell
    }


    @objc func savedbtnTapped(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseDestinationVC") as! ChooseDestinationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func destinationdbtnTapped(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetDestinationVC") as! SetDestinationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
    
