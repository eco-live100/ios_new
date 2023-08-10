//
//  PaymentRequestVC.swift
//  DemoApp
//
//  Created by Ishan Jha on 11/11/22.
//

import UIKit

class PaymentRequestVC: UIViewController {
    
    @IBOutlet var tblView : UITableView!
    @IBOutlet var SearchView : UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        SearchView.dropShadowToCollC()
        tblView.dropShadowToCollC()
        tblView.register(UINib(nibName: "PaymentRequestTVCell", bundle: nil), forCellReuseIdentifier: "PaymentRequestTVCell")
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
    @IBAction func backbtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}
//MARK: - TableView Delegate
 
extension PaymentRequestVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tblView.dequeueReusableCell(withIdentifier: "PaymentRequestTVCell") as! PaymentRequestTVCell
            
//            if indexPath.row == 0{
//                cell.searchStackView.isHidden = false
//            }else{
//                cell.searchStackView.isHidden = true
//            }
//
            return cell
    
            
        
        default:
            print("No section found for this row")
            return UITableViewCell()
        }
        
        
    }
   
}
