//
//  TexiSaveAddressVC.swift
//  EcoLive
//
//  Created by  on 10/11/22.
//

import UIKit

class TexiSaveAddressVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

}

class AddressTableViewCell: UITableViewCell {

}

extension TexiSaveAddressVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath as IndexPath) as! AddressTableViewCell
        return cell
    }


}
