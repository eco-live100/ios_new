//
//  ContactsVC.swift
//  EcoLive
//
//  Created by  on 30/10/22.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSeprate: UILabel!
    @IBOutlet weak var viewSelected: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        DispatchQueue.main.async {
            self.viewSelected.layer.cornerRadius = self.viewSelected.frame.height / 2.0

            self.imgUser.layer.cornerRadius = self.imgUser.layer.frame.size.width / 2
            self.imgUser.layer.borderColor = Constants.Color.GrayColor.cgColor
            self.imgUser.layer.borderWidth = 1.0
            self.imgUser.clipsToBounds = true
        }
    }

}

class ContactsVC: UIViewController {


    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewTop: UIView!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!



    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)


        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)

        }

        if #available(iOS 13.0, *) {
            self.searchBar.searchTextField.backgroundColor = .clear
        } else {

        }
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.white
    }

    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDialPaidClick(_ sender: UIButton) {

        let controller = GlobalData.friendStoryBoard().instantiateViewController(withIdentifier: "DialPadVC") as! DialPadVC
        self.navigationController?.pushViewController(controller, animated: true)
    }

}


extension ContactsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.lblSeprate.isHidden = true
        return cell
    }





}
