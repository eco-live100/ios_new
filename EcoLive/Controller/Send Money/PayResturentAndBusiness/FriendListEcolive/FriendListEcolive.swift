//
//  FriendListEcolive.swift
//  EcoLive
//
//  Created by  on 26/10/22.
//

import UIKit

class FriendListEcolive: UIViewController {

    //MARK: - PROPERTIES & OUTLETS -

    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!

    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var btnPayOutlet: UIButton!
    var arrSearchContact: [EcoliveContact] = []
    var searchActive : Bool = false
    var titleVC = ""

    var isFrome = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        setUIdata()

        if isFrome == "pharmacy"{
            btnPayOutlet.setTitle("Send a request", for: .normal)
        }

    }

    func setUIdata(){

        if titleVC.count > 0 {
            lblTitle.text = titleVC
        }

        tblView.delegate = self
        tblView.dataSource = self

        DispatchQueue.main.async {
            //            self.viewSearch.drawShadow()

            self.viewSearch.layer.masksToBounds = false
            self.viewSearch.layer.shadowRadius = 1
            self.viewSearch.layer.shadowOpacity = 0.6
            self.viewSearch.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewSearch.layer.shadowOffset = CGSize(width: 0, height: 2)

            self.searchBar.setupSearchBar(background: .clear, inputText: Constants.Color.THEME_BLACK, placeholderText: Constants.Color.SEARCHBAR_PLACEHOLDER, image: Constants.Color.SEARCHBAR_IMAGE)
        }

//        self.viewSearch.layer.masksToBounds = false
//        self.viewSearch.layer.shadowRadius = 1
//        self.viewSearch.layer.shadowOpacity = 0.6
//        self.viewSearch.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
//        self.viewSearch.layer.shadowOffset = CGSize(width: 0, height: 2)
//
//        self.searchBar.showsCancelButton = false
//        self.searchBar.delegate = self
//
//        self.searchBar.setupSearchBar(background: .clear, inputText: Constants.Color.THEME_BLACK, placeholderText: Constants.Color.SEARCHBAR_PLACEHOLDER, image: Constants.Color.SEARCHBAR_IMAGE)
//

    }

    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }


    @IBAction func btnPayNow(_ sender: UIButton) {
        
        if isFrome == "pharmacy"{
            
            let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "RequestFormVC") as! RequestFormVC
            self.navigationController?.pushViewController(controller, animated: true)
            
            return
        }
        
        let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "SelectedRecipientsVC") as! SelectedRecipientsVC
        self.navigationController?.pushViewController(controller, animated: true)


    }



}

//MARK: - UISEARCHBAR DELEGATE METHOD -

extension FriendListEcolive: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if(searchBar.text != "") {
            self.searchActive = true
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.tblView.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        self.tblView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar.showsCancelButton = true
        if(searchText != "") {
            self.searchActive = true
            if (GlobalData.shared.arrEcoliveContact.count) > 0 {
                //                self.arrSearchContact = self.arrEcoliveContact.filter() {
                //                    return (($0 as EcoliveContact).userName.contains(searchText))
                //                }

                self.arrSearchContact = GlobalData.shared.arrEcoliveContact.filter() {
                    let nameNumber = ("\(($0 as EcoliveContact).userName.lowercased()) \(($0 as EcoliveContact).contactNo.lowercased())")
                    return nameNumber.contains(searchText.lowercased())
                }
            }
        } else {
            self.searchActive = false
        }

        if self.searchActive {

        } else {

        }

        self.tblView.reloadData()
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension FriendListEcolive: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension FriendListEcolive: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.searchActive {
            return self.arrSearchContact.count
        } else {
            return 10 //GlobalData.shared.arrEcoliveContact.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendSelectCell", for: indexPath) as! FriendSelectCell
        cell.selectionStyle = .none
        return cell

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//
//        let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "SendMoneyToContactVC") as! SendMoneyToContactVC
//        controller.isFromQRScan = false
//        //        controller.objContactDetail = objDict
//        self.navigationController?.pushViewController(controller, animated: true)

    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
