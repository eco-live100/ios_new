//
//  MessagesVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 18/06/21.
//

import UIKit
import SDWebImage
import SwiftyJSON
import IQKeyboardManagerSwift

class MessagesVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var viewDeliveryJob: UIView!
    @IBOutlet weak var lblAvailableJob: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var viewMore: UIView!
    
    @IBOutlet weak var viewChangeBackgroundBG: UIView!
    @IBOutlet weak var viewColorContent: UIView!
    @IBOutlet weak var tblColor: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var arrThreadList: [ThreadObject] = []
    var arrColor: [ColorDataObject] = []
        
    var dateFormatt = DateFormatter()
    var dateComponentsFormatter = DateComponentsFormatter()
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
//        IQKeyboardManager.shared.disabledToolbarClasses = [MessagesVC]

    }


    override func viewDidDisappear(_ animated: Bool) {
//        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {

//        IQKeyboardManager.shared.enable = false

        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
//        self.lblAvailableJob.text = "\(GlobalData.shared.deliveryJob)"
        self.lblAvailableJob.text = "25"

        if objUserDetail.userType == "rider" {
//            if GlobalData.shared.deliveryJob > 0 {
                self.viewDeliveryJob.isHidden = false
//            } else {
//                self.viewDeliveryJob.isHidden = true
//            }
        } else {
            self.viewDeliveryJob.isHidden = true
        }

        self.viewDeliveryJob.isHidden = false

        GlobalData.shared.JoinedRoomID = "chatScreen"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        self.viewColorContent.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        
        if #available(iOS 13.0, *) {
            self.searchBar.searchTextField.backgroundColor = .clear
        } else {
           
        }
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.white


        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
            
            self.viewDeliveryJob.drawShadow()
        }
        
        self.tblView.showsVerticalScrollIndicator = false
        self.tblView.tableFooterView = UIView()
        
        self.tblView.isHidden = true
        self.lblNoRecord.isHidden = true
        
        self.viewMore.isHidden = true
        self.viewChangeBackgroundBG.isHidden = true
        
        self.arrColor = [
            ColorDataObject(hexcode: "F5F5F5", color_name: "Off White"),
            ColorDataObject(hexcode: "A9A9A9", color_name: "Dark grey"),
            ColorDataObject(hexcode: "C0C0C0", color_name: "Silver"),
            ColorDataObject(hexcode: "FAF0E6", color_name: "Linen"),
            ColorDataObject(hexcode: "FFDAB9", color_name: "Peach puff"),
            ColorDataObject(hexcode: "F5DEB3", color_name: "Wheat"),
            ColorDataObject(hexcode: "AFEEEE", color_name: "Pale turquoise"),
            ColorDataObject(hexcode: "7FFFD4", color_name: "Aqua marine"),
        ]
                
        self.dateFormatt.dateFormat = "yyyy-MM-dd hh:mm a"
        
        self.dateComponentsFormatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        self.dateComponentsFormatter.maximumUnitCount = 1
        self.dateComponentsFormatter.unitsStyle = .full
//        self.dateComponentsFormatter.string(from: Date(), to: Date(timeIntervalSinceNow: 4000000))  // "1 month"
        
        self.callGetThreadListAPI()
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        GlobalData.shared.JoinedRoomID = ""
        self.navigationController?.popViewController(animated: true)
    }

    
    
    @IBAction func btnSearchClick(_ sender: UIButton) {
        debugPrint("Search Click")
        
        let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "CreatChatGroup") as! CreatChatGroup
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func btnDeliveryJobClick(_ sender: UIButton) {
        let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RiderCurrentOrderVC") as! RiderCurrentOrderVC
        controller.isFromSideMenu = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnMoreClick(_ sender: UIButton) {
        if self.btnMore.accessibilityViewIsModal {
            self.viewMore.isHidden = true
            self.btnMore.accessibilityViewIsModal = false
        } else {
            self.viewMore.isHidden = false
            self.btnMore.accessibilityViewIsModal = true
        }
    }
    
    @IBAction func btnCloseBackgroundBGPopupClick(_ sender: UIButton) {
        UIView.transition(with: self.viewChangeBackgroundBG, duration: 0.4,
                          options: .transitionFlipFromTop,
                          animations: {
            self.viewChangeBackgroundBG.isHidden = true
        })
    }
    
    @IBAction func btnChangeBackgroundClick(_ sender: UIButton) {
        
        if let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "ColorChatBGVC") as? ColorChatBGVC {
            self.push(controller: controller)
        }
        
        return
        
        self.viewMore.isHidden = true
        self.btnMore.accessibilityViewIsModal = false
        
        UIView.transition(with: self.viewChangeBackgroundBG, duration: 0.4,
                          options: .transitionFlipFromBottom,
                          animations: {
            self.viewChangeBackgroundBG.isHidden = false
            self.tblColor.reloadData()
        })
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension MessagesVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tblView {
            return 10//self.arrThreadList.count
        } else {
            return self.arrColor.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell

            let tapOnProfile = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnProfilePressed(tapGestureRecognizer:)))
            cell.imgUser.isUserInteractionEnabled = true
            cell.imgUser.addGestureRecognizer(tapOnProfile)
//            let objDict = self.arrThreadList[indexPath.section]
//
//            cell.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
//            cell.imgUser.sd_setImage(with: URL(string: objDict.oposite_profileImage), placeholderImage: UIImage.init(named: "user_placeholder"))
//
//            cell.lblName.text = objDict.oposite_name
//            cell.lblTime.text = ""
//
//            cell.lblTime.isHidden = false
//            cell.lblSeprate.isHidden = false
            
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorCell
            
            let hexCode = self.arrColor[indexPath.section].hexcode
            cell.viewColor.backgroundColor = GlobalData.shared.hexStringToUIColor(hex: hexCode)
            cell.lblColorName.text = self.arrColor[indexPath.section].color_name
            
            if self.viewBG.backgroundColor == cell.viewColor.backgroundColor {
                cell.btnRadio.isSelected = true
            } else {
                cell.btnRadio.isSelected = false
            }
            
            cell.btnRadio.tag = indexPath.section
            cell.btnRadio.addTarget(self, action: #selector(btnRadioClick), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblView {
            
            //if indexPath.row == 0 {
                            
//                let objDict = self.arrThreadList[indexPath.section]
                
                let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                controller.isComeFromPushNotification = false
                controller.isFromFriendList = false
//                controller.objThreadDetail = objDict
                controller.backgroundColor = self.viewBG.backgroundColor!
                self.navigationController?.pushViewController(controller, animated: true)
                
                
         /*   }else{
                let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "imageProfileVC") as! imageProfileVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
*/
            
            
            

        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblView {
            return 70
        } else {
            return 60.0
        }
    }
    
    //CELL ACTION
    @objc func btnRadioClick(_ sender: UIButton) {
        UIView.transition(with: self.viewChangeBackgroundBG, duration: 0.4,
                          options: .transitionFlipFromTop,
                          animations: {
            self.viewChangeBackgroundBG.isHidden = true
            
            let hexCode = self.arrColor[sender.tag].hexcode
            self.viewBG.backgroundColor = GlobalData.shared.hexStringToUIColor(hex: hexCode)
        })
    }

    @objc func didTapOnProfilePressed(tapGestureRecognizer: UITapGestureRecognizer)
    {


        let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RideDetails") as! RideDetails

//        let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "imageProfileVC") as! imageProfileVC
        self.navigationController?.pushViewController(controller, animated: true)

    }
}

//MARK: - API CALL -

extension MessagesVC {
    //GET THREAD LIST
    func callGetThreadListAPI() {
        
        self.tblView.isHidden = false
        
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let params: [String:Any] = [:]
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.GET_THREAD_LIST, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let data = response["data"] as? Dictionary<String, Any> {
                            if let payloadData = data["payload"] as? [Dictionary<String, Any>] {
                                strongSelf.arrThreadList.removeAll()
                                for i in 0..<payloadData.count {
                                    let objProduct = ThreadObject.init(payloadData[i])
                                    strongSelf.arrThreadList.append(objProduct)
                                }
                                
                                if strongSelf.arrThreadList.count > 0 {
                                    strongSelf.lblNoRecord.isHidden = true
                                } else {
                                    strongSelf.lblNoRecord.isHidden = false
                                }
                                strongSelf.tblView.isHidden = false
                                
                                GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)
                            }
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
