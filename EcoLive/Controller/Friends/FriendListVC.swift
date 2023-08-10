//
//  FriendListVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 30/08/21.
//

import UIKit
import Contacts
import ContactsUI
import SwiftyJSON
import SDWebImage

class FriendListVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
//    var contacts = [CNContact]()
    var contacts: [FetchedContact] = []
    var contactJsonString: String!
    
    var arrSearchContact: [EcoliveContact] = []
    var searchActive : Bool = false
    
    var arrNewContactDB:[Contact] = []
    
    var db:DBHelper = DBHelper()
        
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        GlobalData.shared.JoinedRoomID = "chatScreen"
        
        //ADDED NOTIFICATION OBSERVER TO NOTIFY ON KEYBOARD SHOW/HIDE
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        self.searchBar.showsCancelButton = false
        self.searchBar.delegate = self
        
        self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
            
//            self.viewSearch.drawShadow()
            
            self.viewSearch.layer.masksToBounds = false
            self.viewSearch.layer.shadowRadius = 1
            self.viewSearch.layer.shadowOpacity = 0.6
            self.viewSearch.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewSearch.layer.shadowOffset = CGSize(width: 0, height: 2)

            self.searchBar.setupSearchBar(background: .clear, inputText: Constants.Color.THEME_BLACK, placeholderText: Constants.Color.SEARCHBAR_PLACEHOLDER, image: Constants.Color.SEARCHBAR_IMAGE)
        }
        
        self.tblView.showsVerticalScrollIndicator = false
        self.tblView.tableFooterView = UIView()
        
        GlobalData.shared.arrPhoneContactDB = db.readPhoneContact()
        GlobalData.shared.arrEcoliveContact = db.readEcoliveContact()
        
        if GlobalData.shared.arrEcoliveContact.count > 0 {
            self.lblNoRecord.isHidden = true
        } else {
            self.lblNoRecord.isHidden = false
        }
        
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            getContacts()
        } else{
            self.requestAccess()
        }
        
        self.lblNoRecord.isHidden = true
    }
    
    //MARK: - HELPER -
    
    //TO AVOIDE DATA GOES BEHIND TABLEVIEW WE SET TABLEVIEW BOTTOM OFFSET TO KEYBOARD HEIGHT SO THAT TABLEVIEW LAST RECORD DISPLAY ABOVE KEYBOARD
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            self.tblView.setBottomInset(to: keyboardHeight)
        }
    }

    //RESET TABLEVIEW BOTTOM OFFSET TO 0 ON KEYBOARD HIDES
    @objc func keyboardWillHide(notification: Notification) {
        self.tblView.setBottomInset(to: 0.0)
    }
    
    func requestAccess() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    self.presentSettingsActionSheet()
                }
                return
            }
            self.getContacts()
        }
    }
    
    func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Permission to Contacts", message: "Eco-live needs access to contacts in order to fetch contact list", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func getContacts() {
//        let keys = [
//            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
//            CNContactPhoneNumbersKey,
//            CNContactEmailAddressesKey] as [Any]
        
        var result = [CNContact]()
        
        let contactStore = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey, CNContactThumbnailImageDataKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        request.sortOrder = CNContactSortOrder.givenName
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
//                self.contacts.append(contact)
//                self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                /*self.contacts.append(FetchedContact(fullName: contact.givenName + contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                */
                
                result.append(contact)
            }
            
            var arrLatest:[Contact] = []
            
            for objContact in result {
                if (!objContact.givenName.isEmpty || !objContact.familyName.isEmpty) && (!objContact.phoneNumbers.isEmpty) {
                    for phoneNumber in objContact.phoneNumbers {
                        var strBase64 = ""
                        if let imageData = objContact.thumbnailImageData {
                            debugPrint("image \(String(describing: UIImage(data: imageData)))")
                            strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                        } else {
                            debugPrint("No image available")
                            let contactImage = UIImage.init(named: "user_placeholder")!
                            let imgData = contactImage.jpegData(compressionQuality: 0.5)!
                            strBase64 = imgData.base64EncodedString(options: .lineLength64Characters)
                        }
                        
                        var finalNumber = phoneNumber.value.stringValue
                        finalNumber = finalNumber.replacingOccurrences(of: "-", with: "")
                        finalNumber = finalNumber.replacingOccurrences(of: " ", with: "")
                        finalNumber = finalNumber.replacingOccurrences(of: "(", with: "")
                        finalNumber = finalNumber.replacingOccurrences(of: ")", with: "")
                        
                        if finalNumber == objUserDetail.contactNo {
                            debugPrint("User's own number")
                        } else {
                            arrLatest.append(Contact(id: 0, username: objContact.givenName + " " + objContact.familyName, phonenumber: finalNumber, profileImage: strBase64))
                        }
                    }
                }
            }
            
            debugPrint("Latest Contact Count is:- \(arrLatest.count)")

            //DIFFERENCE BETWEEN TWO ARRAY
            self.arrNewContactDB = arrLatest
                .filter({ currentObject in
                    !(GlobalData.shared.arrPhoneContactDB
                        .contains(where: { $0.username == currentObject.username && $0.phonenumber == currentObject.phonenumber/* && $0.profileImage == currentObject.profileImage*/}))
                })
            debugPrint("New Contact Count is:- \(self.arrNewContactDB.count)")
            
            for objContact in self.arrNewContactDB {
                self.contacts.append(FetchedContact(name: objContact.username, contact: objContact.phonenumber/*, image: objContact.profileImage*/))
//                db.insertPhoneContact(id: 0, username: objContact.username, phonenumber: objContact.phonenumber)
            }
            
            debugPrint(self.contacts.count)
            debugPrint(self.contacts)
            
            if self.arrNewContactDB.count > 0 {
                db.deleteAllPhoneContact()
                
                for objData in arrLatest {
                    db.insertPhoneContact(id: 0, username: objData.username, phonenumber: objData.phonenumber, profileImage: objData.profileImage)
                }
            }
            
            debugPrint(GlobalData.shared.arrPhoneContactDB.count)
            
            if self.contacts.count > 0 {
                //ENCODE CONTACT DATA
                do {
                    let jsonData = try JSONEncoder().encode(self.contacts)
                    self.contactJsonString = String(data: jsonData, encoding: .utf8)!
                    
                    self.callContactSyncAPI()
                } catch {
                    debugPrint(error)
                }
            }
            
//            for objContact in result {
//                if (!objContact.givenName.isEmpty || !objContact.familyName.isEmpty) && (!objContact.phoneNumbers.isEmpty) {
//                    for phoneNumber in objContact.phoneNumbers {
//                        self.contacts.append(FetchedContact(userName: objContact.givenName + objContact.familyName, telephone: phoneNumber.value.stringValue))
//                    }
//                }
//            }
//            debugPrint(self.contacts.count)
//            debugPrint(self.contacts)
        }
        catch {
            debugPrint("unable to fetch contacts")
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        GlobalData.shared.JoinedRoomID = ""
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension FriendListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.searchActive {
            return self.arrSearchContact.count
        } else {
            return 4//GlobalData.shared.arrEcoliveContact.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        
//        var objDict: EcoliveContact!
//
//        if self.searchActive {
//            objDict = self.arrSearchContact[indexPath.section]
//        } else {
//            objDict = GlobalData.shared.arrEcoliveContact[indexPath.section]
//        }
//
//        if objDict.profileImage == "" {
//            cell.imgDP.isHidden = true
//            cell.viewDP.isHidden = false
//
//            let userName = objDict.userName
//            if userName.contains(" ") {
//                let userNameArr = userName.components(separatedBy: " ")
//                let firstName = userNameArr[0]
//                let lastName = userNameArr[1]
//                let dpName = firstName.prefix(1) + lastName.prefix(1)
//
//                cell.lblDP.text = "\(dpName)".uppercased()
//            } else {
//                let dpName = userName.prefix(1)
//
//                cell.lblDP.text = "\(dpName)".uppercased()
//            }
//
//            cell.lblFullName.text = userName
//            cell.lblMobile.text = objDict.contactNoWithCode
//        } else {
//            cell.imgDP.isHidden = false
//            cell.viewDP.isHidden = true
//
//            cell.imgDP.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
//            cell.imgDP.sd_setImage(with: URL(string: objDict.profileImage), placeholderImage: UIImage.init(named: "user_placeholder"))
//
//            cell.lblFullName.text = objDict.userName
//            cell.lblMobile.text = objDict.contactNoWithCode
//        }
//
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        var objDict: EcoliveContact!
//
//        if self.searchActive {
//            objDict = self.arrSearchContact[indexPath.section]
//        }
//        else {
//            if self.searchBar.text?.count ?? "".count <= 0 {
//                self.searchActive = false
//                objDict = GlobalData.shared.arrEcoliveContact[indexPath.section]
//            }
//            else {
//                self.searchActive = true
//                objDict = self.arrSearchContact[indexPath.section]
//            }
//        }
//
//        self.searchBar.resignFirstResponder()
//        self.searchBar.showsCancelButton = false
//
//        let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
//        controller.isComeFromPushNotification = false
//        controller.isFromFriendList = true
//        controller.objContactDetail = objDict
//        controller.backgroundColor = self.viewBG.backgroundColor!
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - UISEARCHBAR DELEGATE METHOD -

extension FriendListVC: UISearchBarDelegate {
    
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
            if self.arrSearchContact.count > 0 {
                self.lblNoRecord.isHidden = true
            } else {
                self.lblNoRecord.isHidden = false
            }
        } else {
            if GlobalData.shared.arrEcoliveContact.count > 0 {
                self.lblNoRecord.isHidden = true
            } else {
                self.lblNoRecord.isHidden = false
            }
        }
        
        self.lblNoRecord.isHidden = true

        
        self.tblView.reloadData()
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension FriendListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - API CALL -

extension FriendListVC {
    //CONTACT SYNCRONISE
    func callContactSyncAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["user_country_code"] = objUserDetail.countryCode
        params["contact_no"] = self.contactJsonString ?? ""
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.CONTACT_SYNC, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            for i in 0..<payloadData.count {
                                let userId = "\(payloadData[i]["userId"] ?? "")"
                                let userName = "\(payloadData[i]["userName"] ?? "")"
                                let profileImage = "\(payloadData[i]["profileImage"] ?? "")"
                                let contactEmail = "\(payloadData[i]["contactEmail"] ?? "")"
                                let countryCode = "\(payloadData[i]["countryCode"] ?? "")"
                                let contactNo = "\(payloadData[i]["contactNo"] ?? "")"
                                let contactNoWithCode = "\(payloadData[i]["contactNoWithCode"] ?? "")"
                                
                                let objData = EcoliveContact.init(id: 0, userId: userId, userName: userName, profileImage: profileImage, contactEmail: contactEmail, countryCode: countryCode, contactNo: contactNo, contactNoWithCode: contactNoWithCode)
                                
                                if let row = GlobalData.shared.arrEcoliveContact.firstIndex(where: {$0.userId == objData.userId}) {
                                    GlobalData.shared.arrEcoliveContact[row] = objData
                                    
                                    strongSelf.db.updateEcoliveContact(id: GlobalData.shared.arrEcoliveContact[row].id, userId: GlobalData.shared.arrEcoliveContact[row].userId, userName: GlobalData.shared.arrEcoliveContact[row].userName, profileImage: GlobalData.shared.arrEcoliveContact[row].profileImage, contactEmail: GlobalData.shared.arrEcoliveContact[row].contactEmail, countryCode: GlobalData.shared.arrEcoliveContact[row].countryCode, contactNo: GlobalData.shared.arrEcoliveContact[row].contactNo, contactNoWithCode: GlobalData.shared.arrEcoliveContact[row].contactNoWithCode)
                                } else {
                                    GlobalData.shared.arrEcoliveContact.append(objData)
                                    
                                    strongSelf.db.insertEcoliveContact(id: 0, userId: objData.userId, userName: objData.userName, profileImage: objData.profileImage, contactEmail: objData.contactEmail, countryCode: objData.countryCode, contactNo: objData.contactNo, contactNoWithCode: objData.contactNoWithCode)
                                }
                            }
                            debugPrint(GlobalData.shared.arrEcoliveContact.count)
                            
                            if GlobalData.shared.arrEcoliveContact.count > 0 {
                                strongSelf.lblNoRecord.isHidden = true
                            } else {
                                strongSelf.lblNoRecord.isHidden = false
                            }
                            
                            GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
}
