//
//  SelectedRecipientsVC.swift
//  EcoLive
//
//  Created by  on 03/11/22.
//

import UIKit

class SelectedRecipientsVC: UIViewController {
    @IBOutlet weak var addCollectionView: UICollectionView!{
        didSet {
            addCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var tblBank: UITableView!{
        didSet {
            tblBank.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnPayContinue(_ sender: UIButton) {

        let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
        self.navigationController?.pushViewController(controller, animated: true)

    }

}

extension SelectedRecipientsVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPersionCollectionCell", for: indexPath) as! AddPersionCollectionCell
        return cell
    }


}

extension SelectedRecipientsVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankTableCell", for: indexPath) as! BankTableCell
        return cell
    }


}


