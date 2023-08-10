//
//  ChatVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 21/06/21.
//

import UIKit
import SwiftyJSON
import Photos
import MobileCoreServices
import SDWebImage
import WebKit
import SwiftValidators
import AVFoundation
import Security
import CometChatPro

class ChatVC: BaseVC, UIScrollViewDelegate {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblOnline: UILabel!
    
    @IBOutlet weak var tblMessages: UITableView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var txtMessage: DynamicTextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnMicrophone: UIButton!
    
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var viewWeb: UIView!
    @IBOutlet weak var scrollPreview: UIScrollView!
    @IBOutlet weak var imgPreview: UIImageView!
    
    var backgroundColor = UIColor.init(hex: 0xF5F5F5)
    var isFromFriendList:Bool = false
    var objContactDetail: EcoliveContact!
    var objThreadDetail: ThreadObject!
    var objNotiUserDetail: UserDetail!
    
    var notificationUserID: String = ""
    var notificationUserContact: String = ""
    var isComeFromPushNotification: Bool = false
    var isDirectlyCame : Bool = false
    
    var imagePicker = UIImagePickerController()
    var RoomID = String() // OPPONENT USER ID
    var chatMessages = [Dictionary<String,Any>]()
    var chatRoomData : [String:Any] = [:]
    
    //AUDIO RECORD
    var previousAudioSelectedIndexPath : IndexPath!
    var avPlayer : AVPlayer?
    var isPlayerOberverAdded : Bool = false
    
    var audioRecorder : AVAudioRecorder!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    
    var recordingTime = ""
    var uniqueID: String = ""
    
    var pageNo:Int = 1
    var totalMessages:Int = 0
    
    var isFirstApiCall:Bool = true
    var loadMore:Bool = true
//    var isShowLoader:Bool = true
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        GlobalData.shared.isPresentedChatView = true
        
        self.viewBG.backgroundColor = backgroundColor
        
        self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
                        
            self.viewMessage.layer.cornerRadius = self.viewMessage.frame.height / 2.0
            self.viewMessage.createButtonShadow()
            
            self.btnMicrophone.layer.cornerRadius = self.btnMicrophone.layer.frame.size.width / 2.0
            self.btnMicrophone.clipsToBounds = true
            self.btnMicrophone.createButtonShadow()
        }
                
        self.uniqueID = UUID().uuidString.replacingOccurrences(of: "-", with: "")

        // add gesture recognizer
        let longPressRecord = UILongPressGestureRecognizer(target: self, action: #selector(longPressAudioRecord))
        self.btnMicrophone.addGestureRecognizer(longPressRecord)
        
        self.checkRecordPermission()
                
//        self.tblMessages.isHidden = true
        self.tblMessages.tableFooterView = UIView()
        self.tblMessages.showsVerticalScrollIndicator = false
        
        self.scrollPreview.minimumZoomScale = 1.0
        self.scrollPreview.maximumZoomScale = 6.0
        self.scrollPreview.zoomScale = 1.0
        self.scrollPreview.delegate = self
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        self.scrollPreview.addGestureRecognizer(doubleTapGest)
        
        self.viewPopup.isHidden = true
                
        if self.isComeFromPushNotification == false {
            if self.isFromFriendList == true {
                if self.objContactDetail.profileImage == "" {
                    self.imgUser.image = UIImage.init(named: "user_placeholder")
                } else {
                    self.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                    self.imgUser.sd_setImage(with: URL(string: self.objContactDetail.profileImage), placeholderImage: UIImage.init(named: "user_placeholder"))
                }
                
                self.lblUsername.text = self.objContactDetail.userName
                
                self.RoomID = self.objContactDetail.userId
            } else {
//                if self.objThreadDetail.oposite_profileImage == "" {
//                    self.imgUser.image = UIImage.init(named: "user_placeholder")
//                } else {
//                    self.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
//                    self.imgUser.sd_setImage(with: URL(string: self.objThreadDetail.oposite_profileImage), placeholderImage: UIImage.init(named: "user_placeholder"))
//                }
//
//                self.lblUsername.text = self.objThreadDetail.oposite_name
//
                self.RoomID = "1"//self.objThreadDetail.oposite_id
            }
            
            GlobalData.shared.JoinedRoomID = self.RoomID
            
            self.callGetAllMessagesAPI()
        } else {
            self.callGetUserDetail()
        }
        
        //ADDED NOTIFICATION OBSERVER TO ADD NEW MESSAGE
        NotificationCenter.default.addObserver(self, selector: #selector(self.addNewMessageInList), name: NSNotification.Name(rawValue: kAddNewMessage), object: nil)
    }
    
    //MARK: - ADD NEW MESSAGE -
    
    @objc private func addNewMessageInList(_ notification: NSNotification) {
        if let objData = notification.userInfo as? Dictionary<String,Any> {
            
            if let roomID = objData["sender_id"] as? String {
                if roomID == GlobalData.shared.JoinedRoomID {
                    let messageType = "\(objData["message_type"] ?? "")"
                    let messageDate = "\(objData["createdAt"] ?? "")"

                    var messageObject = Dictionary<String,Any>()

                    if messageType == "text" {
                        if let messageText = objData["message_text"] as? String {
                            let mediaFile:String = ""
                            
                            let messageId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                                                        
                            var sendMessageDict = Dictionary<String,AnyObject>()
                            sendMessageDict["message_id"] = messageId as AnyObject
                            sendMessageDict["sender_id"] = roomID as AnyObject
                            sendMessageDict["room_id"] = roomID as AnyObject
                            sendMessageDict["room_key"] = roomID as AnyObject
                            sendMessageDict["message_text"] = messageText as AnyObject
                            sendMessageDict["media_file"] = mediaFile as AnyObject
                            sendMessageDict["message_type"] = messageType as AnyObject
                            sendMessageDict["createdAt"] = messageDate as AnyObject
                            sendMessageDict["isPlaying"] = false as AnyObject
                            sendMessageDict["duration"] = self.recordingTime as AnyObject
                                                
                            messageObject["message_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_id") as AnyObject
                            messageObject["sender_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "sender_id") as AnyObject
                            messageObject["room_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_id") as AnyObject
                            messageObject["room_key"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_key") as AnyObject
                            messageObject["message_text"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_text") as AnyObject
                            messageObject["media_file"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "media_file") as AnyObject
                            messageObject["message_type"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_type") as AnyObject
                            messageObject["createdAt"] = messageDate as AnyObject
                    //            messageObject["createdAt"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "createdAt") as AnyObject
                            messageObject["isPlaying"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "isPlaying") as AnyObject
                            messageObject["duration"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "duration") as AnyObject
                            
                            //CONVERT NORMAL MESSAGE TO UTF8 ENCODING TO LOAD IN LIST
            //                        let utf8Data = Data(textMessage?.utf8 ?? "".utf8)
            //                        let encodedMessage = String(data: utf8Data, encoding: .isoLatin1)!
            //                        messageObject["message"] = encodedMessage
                        }
                    }
                    else if messageType == "image" {
                        if let mediaFile = objData["media_file"] as? String {
                            let messageText:String = ""
                            
                            let messageId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                            
                            var sendMessageDict = Dictionary<String,AnyObject>()
                            sendMessageDict["message_id"] = messageId as AnyObject
                            sendMessageDict["sender_id"] = roomID as AnyObject
                            sendMessageDict["room_id"] = roomID as AnyObject
                            sendMessageDict["room_key"] = roomID as AnyObject
                            sendMessageDict["message_text"] = messageText as AnyObject
                            sendMessageDict["media_file"] = mediaFile as AnyObject
                            sendMessageDict["message_type"] = messageType as AnyObject
                            sendMessageDict["createdAt"] = messageDate as AnyObject
                            sendMessageDict["isPlaying"] = false as AnyObject
                            sendMessageDict["duration"] = self.recordingTime as AnyObject
                                                        
                            messageObject["message_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_id") as AnyObject
                            messageObject["sender_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "sender_id") as AnyObject
                            messageObject["room_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_id") as AnyObject
                            messageObject["room_key"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_key") as AnyObject
                            messageObject["message_text"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_text") as AnyObject
                            messageObject["media_file"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "media_file") as AnyObject
                            messageObject["message_type"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_type") as AnyObject
                            messageObject["createdAt"] = messageDate as AnyObject
                    //            messageObject["createdAt"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "createdAt") as AnyObject
                            messageObject["isPlaying"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "isPlaying") as AnyObject
                            messageObject["duration"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "duration") as AnyObject
                        }
                    }
                    else if messageType == "audio" {
                        if let mediaFile = objData["media_file"] as? String {
                            var audioDuration = ""
                            if let url = (objData["media_file"] as! String).url {
                                let totalSecond = self.getAudioDuration(url)
                                audioDuration = totalSecond.secondsToTime()
                            }
                            
                            let messageText:String = ""
                            
                            let messageId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                            
                            var sendMessageDict = Dictionary<String,AnyObject>()
                            sendMessageDict["message_id"] = messageId as AnyObject
                            sendMessageDict["sender_id"] = roomID as AnyObject
                            sendMessageDict["room_id"] = roomID as AnyObject
                            sendMessageDict["room_key"] = roomID as AnyObject
                            sendMessageDict["message_text"] = messageText as AnyObject
                            sendMessageDict["media_file"] = mediaFile as AnyObject
                            sendMessageDict["message_type"] = messageType as AnyObject
                            sendMessageDict["createdAt"] = messageDate as AnyObject
                            sendMessageDict["isPlaying"] = false as AnyObject
                            sendMessageDict["duration"] = audioDuration as AnyObject
                            
                            messageObject["message_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_id") as AnyObject
                            messageObject["sender_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "sender_id") as AnyObject
                            messageObject["room_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_id") as AnyObject
                            messageObject["room_key"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_key") as AnyObject
                            messageObject["message_text"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_text") as AnyObject
                            messageObject["media_file"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "media_file") as AnyObject
                            messageObject["message_type"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_type") as AnyObject
                            messageObject["createdAt"] = messageDate as AnyObject
                    //            messageObject["createdAt"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "createdAt") as AnyObject
                            messageObject["isPlaying"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "isPlaying") as AnyObject
                            messageObject["duration"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "duration") as AnyObject
                        }
                    }
                    
                    self.chatMessages.append(messageObject)
                    
                    DispatchQueue.main.async {
                        self.tblMessages.reloadData()
                        self.scrollToBottom()
                    }
                }
            }
        }
    }
    
    //MARK: - CHECK RECORD PERMISSION & AUDIO METHODS -
    func checkRecordPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            self.isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            self.isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getRecordedFileUrl(_ fileID: String) -> URL {
        let filename = "\(fileID).m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func setup_recorder() {
        if self.isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                try session.setActive(true)
            } catch {
                debugPrint("\(#function) AVAudioSession error: \(error.localizedDescription)")
                GlobalData.shared.displayAlertMessage(Title: "Error", Message: error.localizedDescription)
            }
            
            do {
                let settings : [String : Any] = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                self.uniqueID = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                let recordingPath = self.getRecordedFileUrl(uniqueID)
                self.audioRecorder = try AVAudioRecorder(url: recordingPath, settings: settings)
                self.audioRecorder.delegate = self
//                self.audioRecorder.isMeteringEnabled = true
//                self.audioRecorder.prepareToRecord()
            } catch {
                debugPrint("\(#function) AVAudioRecorder error: \(error.localizedDescription)")
                GlobalData.shared.displayAlertMessage(Title: "Error", Message: error.localizedDescription)
            }
        } else {
            GlobalData.shared.displayAlertMessage(Title: "Error", Message: "Don't have access to use your microphone.")
        }
    }
    
    @objc func updateAudioMeter(timer: Timer) {
        if self.isRecording {
//        if self.audioRecorder.isRecording {
            let hr = Int((self.audioRecorder.currentTime / 60) / 60)
            let min = Int(self.audioRecorder.currentTime / 60)
            let sec = Int(self.audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            self.recordingTime = totalTimeString
            debugPrint("Recording Time is:- \(self.recordingTime)")
            self.audioRecorder.updateMeters()
        }
    }
    
    func stopRecording() {
        debugPrint("\(#function)")

        self.audioRecorder.stop()
        self.audioRecorder = nil
        self.isRecording = false
    }
    
    func finishAudioRecording(success: Bool) {
        debugPrint("\(#function) success: \(success)")

        if success {
            self.meterTimer.invalidate()
            self.uploadRecordedAudio()
        } else {
            GlobalData.shared.displayAlertMessage(Title: "Error", Message: "Recording failed.")
        }
    }
    
    func uploadRecordedAudio() {
        debugPrint("\(#function)")
        
        let filePath = self.getRecordedFileUrl(uniqueID)
        let fileName = filePath.lastPathComponent
        let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))\(fileName)"
        guard let data = try? Data.init(contentsOf: filePath) else { return }
//        let uploadProofData = data.base64EncodedString()
        
        let document = Document(
            uploadParameterKey: "media",
            data: data,
            name: "media",
            fileName: filename,
            mimeType: "audio/m4a"
        )
        
        self.btnSend.isUserInteractionEnabled = false
        self.callSendAudioMessageAPI(MessageType: "audio", MessageDate: Date().timeIntervalSince1970 * 1000, files: [document])
    }
    
    @objc func longPressAudioRecord(_ sender: UIGestureRecognizer) {
        if self.isAudioRecordingGranted == true {
            if sender.state == .began {
                debugPrint("\(#function) record is starting")
                GlobalData.shared.showDarkStyleToastMesage(message: "Recording started")
                
                UIView.animate(withDuration: 0.25, delay: 0,
                               animations: {
                    self.btnMicrophone.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                }, completion:nil)
                
                if !self.isRecording {
                    setup_recorder()
                    
                    self.audioRecorder.record()
                    self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                    self.isRecording = true
                }
            }
            else if sender.state == .ended {
                debugPrint("\(#function) record is finished")
                GlobalData.shared.showDarkStyleToastMesage(message: "Recording completed")
                
                UIView.animate(withDuration: 0.25, delay: 0,
                               animations: {
                    self.btnMicrophone.transform = .identity
                }, completion:nil)
                
                self.stopRecording()
            }
        } else {
            if sender.state == .ended {
                let alert = UIAlertController(title: "Alert", message: "Please allow microphone usage from settings", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Open settings", style: .default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            debugPrint("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - HELPER -
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if self.scrollPreview.zoomScale == 1 {
            self.scrollPreview.zoom(to: zoomRectForScale(scale: self.scrollPreview.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        }
        else {
            self.scrollPreview.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgPreview.frame.size.height / scale
        zoomRect.size.width  = imgPreview.frame.size.width  / scale
        let newCenter = imgPreview.convert(center, from: self.scrollPreview)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    //CALLING METHOD
    fileprivate func initiateCall(to: String, type: CometChat.ReceiverType, callType: CometChat.CallType) {
        CometChat.getUser(UID: to, onSuccess: { (user) in
            if let user = user {
                DispatchQueue.main.async {
                    CometChatCallManager().makeCall(call: callType, to: user)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                if let errorMessage = error?.errorDescription {
                    CometChatSnackBoard.display(message:  errorMessage, mode: .error, duration: .short)
                }
            }
        }
    }
    
    //MARK: - SCROLLVIEW DELEGATE -
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgPreview
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        if self.isComeFromPushNotification == false {
            GlobalData.shared.isPresentedChatView = false
            
            self.navigationController?.popViewController(animated: true)
        } else {
            GlobalData.shared.isPresentedChatView = false
            GlobalData.shared.JoinedRoomID = ""
            
            let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
            let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            let navController = UINavigationController.init(rootViewController: controller)
            appDelegate.drawerController.contentViewController = navController
            appDelegate.drawerController.menuViewController = leftMenuVC
            appDelegate.window?.rootViewController = appDelegate.drawerController
        }
    }
   
    @IBAction func btnAudioCallClick(_ sender: UIButton) {
        self.callSendNotificationForCall(CallType: "audio")
    }
    
    @IBAction func btnVideoCallClick(_ sender: UIButton) {
        self.callSendNotificationForCall(CallType: "video")
    }
    
    @IBAction func btnCameraClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.pickerAction(sourceType: .camera)
    }
    
    @IBAction func btnClipClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.showMediaPickerOptions()
    }
    
    @IBAction func btnSendClick(_ sender: UIButton) {
        let textMessage = self.txtMessage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !Validator.required().apply(textMessage) {
            GlobalData.shared.showDarkStyleToastMesage(message: "Please enter message to send!")
        } else {
            self.btnSend.isUserInteractionEnabled = false
            self.callSendTextMessageAPI(MessageType: "text", Message: self.txtMessage.text ?? "", MessageDate: Date().timeIntervalSince1970 * 1000)
        }
    }
    
    @IBAction func btnMicrophoneTouchUpInside(sender: AnyObject) {
        GlobalData.shared.showDarkStyleToastMesage(message: "Hold to record, release to send")
//        self.stopRecording()
    }
    
//    @IBAction func btnMicrophoneTouchDownClick(sender: AnyObject) {
//        debugPrint("Start recording")
//
//        if !self.isRecording {
//            setup_recorder()
//
//            self.audioRecorder.record()
//            self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
//            self.isRecording = true
//        }
//    }
//
//    @IBAction func btnMicrophoneTouchDragExit(sender: AnyObject) {
//        debugPrint("Stop recording Drag out")
//        self.stopRecording()
//    }
        
    @IBAction func btnClosePopupClick(_ sender: UIButton) {
        self.viewWeb.viewWithTag(100)?.removeFromSuperview()
        self.imgPreview.image = nil
        self.viewPopup.isHidden = true
    }
    
    func scrollToBottom() {
        if self.chatMessages.count > 0 {
            self.updateTableContentInset()
            if self.isFirstApiCall == true {
                let lastRowIndexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
                self.tblMessages.scrollToRow(at: lastRowIndexPath, at: UITableView.ScrollPosition.bottom, animated: false)
            }
        }
    }
    
    func updateTableContentInset() {
        let numRows = tableView(self.tblMessages, numberOfRowsInSection: 0)
        var contentInsetTop = self.tblMessages.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tblMessages.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
            }
        }
        self.tblMessages.contentInset = UIEdgeInsets(top: contentInsetTop, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - AVPLAYER DELEGATE -

extension ChatVC {
    @objc func avPlayerDidFinishPlaying(_ notification: NSNotification) {
        debugPrint("\(#function)")
        if let indexPath = self.previousAudioSelectedIndexPath {
            self.updateAudioPlayerUI(indexPath)
            self.stopPlayer()
            self.previousAudioSelectedIndexPath = nil
        }
    }
}

// MARK: - AVAUDIORECORDER DELEGATE -

extension ChatVC: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        debugPrint("\(#function) flag: \(flag)")
        self.finishAudioRecording(success: flag)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        debugPrint("\(#function) error: \(error?.localizedDescription ?? "")")
    }
}

//MARK: - SHOW MEDIA PICKER DIALOG -

extension ChatVC {
    func showMediaPickerOptions() {
        let fromPhotoLibraryAction = UIAlertAction(title: "Select from photo library", style: .default) { (_) in
            self.pickerAction(sourceType: .photoLibrary)
        }
        
//        let documentPickerAction = UIAlertAction(title: "Select from Documents", style: .default) { (_) in
//            self.documentPickerAction()
//        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(fromPhotoLibraryAction)
        }
//        alert.addAction(documentPickerAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func pickerAction(sourceType : UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
//            let picker = UIImagePickerController()
            self.imagePicker.sourceType = sourceType
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            if sourceType == .camera {
                self.cameraAccessPermissionCheck(completion: { (success) in
                    if success {
                        self.present(self.imagePicker, animated: true, completion: nil)
                    } else {
                        self.alertForPermissionChange(forFeature: "Camera", library: "Camera", action: "take")
                    }
                })
            }
            if sourceType == .photoLibrary {
                self.photosAccessPermissionCheck(completion: { (success) in
                    if success {
                        self.present(self.imagePicker, animated: true, completion: nil)
                    } else {
                        self.alertForPermissionChange(forFeature: "Photos", library: "Photo Library", action: "select")
                    }
                })
            }
        }
    }
    
    func cameraAccessPermissionCheck(completion: @escaping (Bool) -> Void) {
        let cameraMediaType = AVMediaType.video
        let cameraAutherisationState = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAutherisationState {
        case .authorized:
            completion(true)
        case .denied, .notDetermined, .restricted:
            AVCaptureDevice.requestAccess(for: cameraMediaType, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        @unknown default:
            break
        }
    }
    
    func alertForPermissionChange(forFeature feature: String, library: String, action: String) {
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in
            UIApplication.shared.openSettings()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "App"
        let title = "\"\(appName)\" " + "Would Like to Access the" + " \(library)"
        let message = "Please enable" + " \(library) " + "access from Settings" + " > \(appName) > \(feature) " + "to" + " \(action) " + "photos"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func photosAccessPermissionCheck(completion: @escaping (Bool)->Void) {
        let photosStatus = PHPhotoLibrary.authorizationStatus()
        switch photosStatus {
        case .authorized:
            completion(true)
        case .denied, .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        completion(true)
                    default:
                        completion(false)
                    }
                }
            })
        @unknown default:
            break
        }
    }
    /*
    func documentPickerAction() {
//        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf", "com.microsoft.word.doc", "org.openxmlformats.wordprocessingml.document", String(kUTTypeImage)], in: .import)
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf", "com.microsoft.word.doc", "org.openxmlformats.wordprocessingml.document"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        self.present(documentPicker, animated: true, completion: nil)
    }
    */
}

//MARK: - UIDOCUMENTPICKER DELEGATE METHOD -
/*
extension ChatVC: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        debugPrint("Canceled")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let name = url.lastPathComponent
            debugPrint(url.pathExtension)
            
            var mimeType = ""
            
            if url.pathExtension == "pdf" {
                mimeType = "application/pdf"
            } else if url.pathExtension == "doc" {
                mimeType = "application/msword"
            } else if url.pathExtension == "docx" {
                mimeType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            } else {
                debugPrint("Alert")
            }
            
            let timeStamp = Int64(Date().timeIntervalSince1970 * 1000.0)
            let filename = "\(timeStamp)" + "_message" + "." + "\(url.pathExtension)"
                        
            let document = Document(
                uploadParameterKey: "message",
                data: data,
                name: name,
                fileName: filename,
                mimeType: mimeType
            )
            
            self.sendDocumentMessageAPI(MessageType: "file", files: [document])
        } catch {
            debugPrint(error)
        }
    }
}
*/
//MARK: - UIIMAGEPICKER CONTROLLER DELEGATE METHOD -

extension ChatVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
        let image = info[.editedImage] as! UIImage
        let data = image.jpegData(compressionQuality: 0.5)!
        
        var name: String?
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
                name = assetResources.first!.originalFilename
            }
        } else {
            if let imageURL = info[.referenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
                name = assetResources.first?.originalFilename
            }
        }
        
        let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_message.jpg"
        let document = Document(
            uploadParameterKey: "message",
            data: data,
            name: name ?? filename,
            fileName: filename,
            mimeType: "image/jpeg"
        )
        
        picker.dismiss(animated: true, completion: nil)
        
        self.sendDocumentMessageAPI(MessageType: "image", files: [document])
        */
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageData = image.jpeg(.medium) {
//                let selectedImage = UIImage.init(data: imageData)
//                let myImage = selectedImage?.resizeWithWidth(width: 500)
//                let orientationFixedImage = myImage?.fixOrientationForChat()
//                let uploadProofData = orientationFixedImage?.toBase64()
                
                var name: String?
                if #available(iOS 11.0, *) {
                    if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                        let assetResources = PHAssetResource.assetResources(for: asset)
                        name = assetResources.first!.originalFilename
                    }
                } else {
                    if let imageURL = info[.referenceURL] as? URL {
                        let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                        let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
                        name = assetResources.first?.originalFilename
                    }
                }
                
                let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_media.jpg"
                let document = Document(
                    uploadParameterKey: "media",
                    data: imageData,
                    name: name ?? filename,
                    fileName: filename,
                    mimeType: "image/jpeg"
                )
                
                picker.dismiss(animated: true, completion: nil)
                
                self.btnSend.isUserInteractionEnabled = false
                self.callSendImageMessageAPI(MessageType: "image", MessageDate: Date().timeIntervalSince1970 * 1000, files: [document])
            }
        }
        else {
            GlobalData.shared.showToastMessage(message: "Please select image to send!")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - GROWING TEXTVIEW DELEGATE METHOD -

extension ChatVC: DynamicTextViewDelegate {
    func textViewDidChangeHeight(_ textView: DynamicTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE METHOD -

extension ChatVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentChatMessage = self.chatMessages[indexPath.row]
        let type = currentChatMessage["message_type"] as! String
        
        if type == "text" {
            var message:String = ""
            message = currentChatMessage["message_text"] as! String
            
//            //CONVERT UTF8 TO NORMAL MESSAGE DECODING TO LOAD IN LIST
//            let latin1Data = message.data(using: .isoLatin1)!
//            let utf8String = String(data: latin1Data, encoding: .utf8)!
            
            if currentChatMessage["sender_id"] as! String == objUserDetail._id {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
                
                cell.lblMessage.text = message

                if let createDate = currentChatMessage["createdAt"] as? NSNumber {
                    var date = String()
                    let timestamp: NSNumber = createDate
                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));

                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let date1 = dateFormatt.string(from: exactDate as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
                        dateFormatt.dateFormat = "hh:mm a"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text  = "\(date)"
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text = date
                    }
                }
                else if let createDate = currentChatMessage["createdAt"] as? String {
                    var date = String()

//                    var timeStampNumber: NSNumber?
//                    if let strCreatedAt = createDate as? String {
//                        if let myInteger = Int(strCreatedAt) {
//                            timeStampNumber = NSNumber(value:myInteger)
//                        }
//                    }
//
//                    let timestamp: NSNumber = timeStampNumber ?? 0
//                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));
                    
                    let dateConv = createDate.fromUTCToLocalDateTime(OutputFormat: "yyyy-MM-dd")
                    
                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let exactDate = dateFormatt.date(from: dateConv)
                    let date1 = dateFormatt.string(from: exactDate! as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
//                        dateFormatt.dateFormat = "hh:mm a"
//                        date = dateFormatt.string(from: exactDate! as Date)
//                        cell.lblTime.text = "\(date)"
                        cell.lblTime.text = createDate.fromUTCToLocalDateTime(OutputFormat: "hh:mm a")
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate! as Date)
                        cell.lblTime.text = date
                    }
                }
                
                let font = UIFont(name: Constants.Font.ROBOTO_REGULAR, size: cell.lblTime.font.pointSize)!
                var width: CGFloat = 0
                let item = cell.lblTime.text ?? ""
                width = NSString(string: item).size(withAttributes: [NSAttributedString.Key.font : font]).width
                DispatchQueue.main.async {
                    cell.lblTimeWidthConstraint?.constant = width + 5
                }
                
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
                
                cell.lblMessage.text = message
                
                if let createDate = currentChatMessage["createdAt"] as? NSNumber {
                    var date = String()
                    let timestamp: NSNumber = createDate
                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));

                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let date1 = dateFormatt.string(from: exactDate as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
                        dateFormatt.dateFormat = "hh:mm a"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text  = "\(date)"
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text = date
                    }
                }
                else if let createDate = currentChatMessage["createdAt"] as? String {
                    var date = String()
                    
//                    var timeStampNumber: NSNumber?
//                    if let strCreatedAt = createDate as? String {
//                        if let myInteger = Int(strCreatedAt) {
//                            timeStampNumber = NSNumber(value:myInteger)
//                        }
//                    }
//
//                    let timestamp: NSNumber = timeStampNumber ?? 0
//                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));

                    let dateConv = createDate.fromUTCToLocalDateTime(OutputFormat: "yyyy-MM-dd")
                    
                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let exactDate = dateFormatt.date(from: dateConv)
                    let date1 = dateFormatt.string(from: exactDate! as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
//                        dateFormatt.dateFormat = "hh:mm a"
//                        date = dateFormatt.string(from: exactDate! as Date)
//                        cell.lblTime.text = "\(date)"
                        cell.lblTime.text = createDate.fromUTCToLocalDateTime(OutputFormat: "hh:mm a")
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate! as Date)
                        cell.lblTime.text = date
                    }
                }
                
                let font = UIFont(name: Constants.Font.ROBOTO_REGULAR, size: cell.lblTime.font.pointSize)!
                var width: CGFloat = 0
                let item = cell.lblTime.text ?? ""
                width = NSString(string: item).size(withAttributes: [NSAttributedString.Key.font : font]).width
                DispatchQueue.main.async {
                    cell.lblTimeWidthConstraint?.constant = width + 5
                }
                
                cell.selectionStyle = .none
                return cell
            }
        }
        else if type == "image" {
            let message = currentChatMessage["media_file"] as AnyObject
            
            if currentChatMessage["sender_id"] as! String == objUserDetail._id {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderImageCell", for: indexPath) as! SenderImageCell
                
//                let strMessage = String(describing: message)
//
//                if strMessage.hasPrefix("http://") || strMessage.hasPrefix("https://") {
//                    cell.imgContent.sd_setImage(with: URL(string: message as! String), completed: nil)
//                }
//                else {
//                    cell.imgContent.image = self.convertBase64StringToImage(imageBase64String: strMessage)
//                }
                
                cell.imgContent.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgContent.sd_setImage(with: URL(string: message as! String), placeholderImage: nil)
                
                if let createDate = currentChatMessage["createdAt"] as? NSNumber {
                    var date = String()
                    let timestamp: NSNumber = createDate
                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));

                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let date1 = dateFormatt.string(from: exactDate as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
                        dateFormatt.dateFormat = "hh:mm a"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text  = "\(date)"
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text = date
                    }
                }
                else if let createDate = currentChatMessage["createdAt"] as? String {
                    var date = String()
                    
//                    var timeStampNumber: NSNumber?
//                    if let strCreatedAt = createDate as? String {
//                        if let myInteger = Int(strCreatedAt) {
//                            timeStampNumber = NSNumber(value:myInteger)
//                        }
//                    }
//
//                    let timestamp: NSNumber = timeStampNumber ?? 0
//                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));

                    let dateConv = createDate.fromUTCToLocalDateTime(OutputFormat: "yyyy-MM-dd")
                    
                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let exactDate = dateFormatt.date(from: dateConv)
                    let date1 = dateFormatt.string(from: exactDate! as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
//                        dateFormatt.dateFormat = "hh:mm a"
//                        date = dateFormatt.string(from: exactDate! as Date)
//                        cell.lblTime.text = "\(date)"
                        cell.lblTime.text = createDate.fromUTCToLocalDateTime(OutputFormat: "hh:mm a")
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate! as Date)
                        cell.lblTime.text = date
                    }
                }
                
                cell.btnImage.tag = indexPath.row
                cell.btnImage.addTarget(self, action: #selector(btnImageClick), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverImageCell", for: indexPath) as! ReceiverImageCell
                
//                cell.imgContent.sd_setImage(with: URL(string: message as! String), completed: nil)
                
//                let strMessage = String(describing: message)
//
//                if strMessage.hasPrefix("http://") || strMessage.hasPrefix("https://") {
//                    cell.imgContent.sd_setImage(with: URL(string: message as! String), completed: nil)
//                } else {
//                    cell.imgContent.image = self.convertBase64StringToImage(imageBase64String: strMessage)
//                }
                
                cell.imgContent.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgContent.sd_setImage(with: URL(string: message as! String), placeholderImage: nil)
                
                if let createDate = currentChatMessage["createdAt"] as? NSNumber {
                    var date = String()
                    let timestamp: NSNumber = createDate
                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));

                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let date1 = dateFormatt.string(from: exactDate as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
                        dateFormatt.dateFormat = "hh:mm a"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text  = "\(date)"
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text = date
                    }
                }
                else if let createDate = currentChatMessage["createdAt"] as? String {
                    var date = String()
                    
//                    var timeStampNumber: NSNumber?
//                    if let strCreatedAt = createDate as? String {
//                        if let myInteger = Int(strCreatedAt) {
//                            timeStampNumber = NSNumber(value:myInteger)
//                        }
//                    }
//
//                    let timestamp: NSNumber = timeStampNumber ?? 0
//                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));

                    let dateConv = createDate.fromUTCToLocalDateTime(OutputFormat: "yyyy-MM-dd")
                    
                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let exactDate = dateFormatt.date(from: dateConv)
                    let date1 = dateFormatt.string(from: exactDate! as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
//                        dateFormatt.dateFormat = "hh:mm a"
//                        date = dateFormatt.string(from: exactDate! as Date)
//                        cell.lblTime.text = "\(date)"
                        cell.lblTime.text = createDate.fromUTCToLocalDateTime(OutputFormat: "hh:mm a")
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate! as Date)
                        cell.lblTime.text = date
                    }
                }
                
                cell.btnImage.tag = indexPath.row
                cell.btnImage.addTarget(self, action: #selector(btnImageClick), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            }
        }
        else if type == "audio" {
            var finalDuration: String = ""
            
            if let duration = currentChatMessage["duration"] as? Int {
                finalDuration = GlobalData.shared.FullTimeString(time: TimeInterval(duration))
            } else {
                finalDuration = currentChatMessage["duration"] as! String
            }
            
            if currentChatMessage["sender_id"] as! String == objUserDetail._id {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderAudioCell", for: indexPath) as! SenderAudioCell
                
                cell.lblPlayerTime.text = finalDuration
                
                if let createDate = currentChatMessage["createdAt"] as? NSNumber {
                    var date = String()
                    let timestamp: NSNumber = createDate
                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));

                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let date1 = dateFormatt.string(from: exactDate as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
                        dateFormatt.dateFormat = "hh:mm a"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text  = "\(date)"
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text = date
                    }
                }
                else if let createDate = currentChatMessage["createdAt"] as? String {
                    var date = String()
                    
//                    var timeStampNumber: NSNumber?
//                    if let strCreatedAt = createDate as? String {
//                        if let myInteger = Int(strCreatedAt) {
//                            timeStampNumber = NSNumber(value:myInteger)
//                        }
//                    }
//
//                    let timestamp: NSNumber = timeStampNumber ?? 0
//                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));

                    let dateConv = createDate.fromUTCToLocalDateTime(OutputFormat: "yyyy-MM-dd")
                    
                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let exactDate = dateFormatt.date(from: dateConv)
                    let date1 = dateFormatt.string(from: exactDate! as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
//                        dateFormatt.dateFormat = "hh:mm a"
//                        date = dateFormatt.string(from: exactDate! as Date)
//                        cell.lblTime.text = "\(date)"
                        cell.lblTime.text = createDate.fromUTCToLocalDateTime(OutputFormat: "hh:mm a")
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate! as Date)
                        cell.lblTime.text = date
                    }
                }
                
                let isPlaying = (currentChatMessage["isPlaying"] as AnyObject).boolValue //currentChatMessage["isPlaying"] as! Bool
                debugPrint("Playing Status is:-\(isPlaying!)")
                cell.btnPlay.isSelected = isPlaying!
                
                cell.btnPlay.tag = indexPath.row
                cell.btnPlay.addTarget(self, action: #selector(btnAudioPlayClick(sender:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverAudioCell", for: indexPath) as! ReceiverAudioCell
                
                cell.lblPlayerTime.text = finalDuration
                
                if let createDate = currentChatMessage["createdAt"] as? NSNumber {
                    var date = String()
                    let timestamp: NSNumber = createDate
                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));

                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let date1 = dateFormatt.string(from: exactDate as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
                        dateFormatt.dateFormat = "hh:mm a"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text  = "\(date)"
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate as Date)
                        cell.lblTime.text = date
                    }
                }
                else if let createDate = currentChatMessage["createdAt"] as? String {
                    var date = String()
                    
//                    var timeStampNumber: NSNumber?
//                    if let strCreatedAt = createDate as? String {
//                        if let myInteger = Int(strCreatedAt) {
//                            timeStampNumber = NSNumber(value:myInteger)
//                        }
//                    }
//
//                    let timestamp: NSNumber = timeStampNumber ?? 0
//                    let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: Int(truncating: timestamp)/1000)));

                    let dateConv = createDate.fromUTCToLocalDateTime(OutputFormat: "yyyy-MM-dd")
                    
                    let dateFormatt = DateFormatter()
                    dateFormatt.dateFormat = "yyyy-MM-dd"
                    let exactDate = dateFormatt.date(from: dateConv)
                    let date1 = dateFormatt.string(from: exactDate! as Date)
                    let date2 = dateFormatt.string(from: Date())
                    
                    if date1 == date2 {
//                        dateFormatt.dateFormat = "hh:mm a"
//                        date = dateFormatt.string(from: exactDate! as Date)
//                        cell.lblTime.text = "\(date)"
                        cell.lblTime.text = createDate.fromUTCToLocalDateTime(OutputFormat: "hh:mm a")
                    }
                    else {
                        dateFormatt.dateFormat = "dd MMM yyyy"
                        date = dateFormatt.string(from: exactDate! as Date)
                        cell.lblTime.text = date
                    }
                }
                
                let isPlaying = (currentChatMessage["isPlaying"] as AnyObject).boolValue //currentChatMessage["isPlaying"] as! Bool
                cell.btnPlay.isSelected = isPlaying!
                
                cell.btnPlay.tag = indexPath.row
                cell.btnPlay.addTarget(self, action: #selector(btnAudioPlayClick(sender:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            }
        }
        else if type == "document" {
            if currentChatMessage["sender_id"] as! String == objUserDetail._id {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderFileCell", for: indexPath) as! SenderFileCell
                
                cell.imgFile.image = UIImage(named: "ic_document")
                cell.lblTime.text = "7:10 PM"
                
                cell.btnFile.tag = indexPath.row
                cell.btnFile.addTarget(self, action: #selector(btnFileClick), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverFileCell", for: indexPath) as! ReceiverFileCell
                
                cell.imgFile.image = UIImage(named: "ic_document")
                cell.lblTime.text = "7:10 PM"
                
                cell.btnFile.tag = indexPath.row
                cell.btnFile.addTarget(self, action: #selector(btnFileClick), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            }
        }
        else {
            let Cell = UITableViewCell()
            return Cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            if self.loadMore == true {
                self.isFirstApiCall = false
//                self.isShowLoader = false
                self.callGetAllMessagesAPI()
            } else {
                debugPrint("No More Record")
            }
        }
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .ignoreUnknownCharacters)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    //MARK: - CELL BUTTON ACTION
    
    @objc func btnImageClick(_ sender: UIButton) {
        let currentChatMessage = self.chatMessages[sender.tag]
        let message = currentChatMessage["media_file"] as AnyObject
//        let strMessage = String(describing: message)

        self.viewPopup.isHidden = false
        self.scrollPreview.isHidden = false
        self.viewWeb.isHidden = true
        
        self.scrollPreview.zoomScale = 1.0
        
//        if strMessage.hasPrefix("http://") || strMessage.hasPrefix("https://") {
//            self.imgPreview.sd_setImage(with: URL(string: message as! String), completed: nil)
//        } else {
//            self.imgPreview.image = self.convertBase64StringToImage(imageBase64String: strMessage)
//        }
        
        self.imgPreview.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.imgPreview.sd_setImage(with: URL(string: message as! String), placeholderImage: nil)
    }
    
    @IBAction func btnAudioPlayClick(sender: UIButton) {
        debugPrint("\(#function)")
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if self.previousAudioSelectedIndexPath != nil {
            if (indexPath == self.previousAudioSelectedIndexPath) {
                debugPrint("\(#function) pause")
                if self.avPlayer?.isPlaying == true {
                    self.avPlayer?.pause()
                } else {
                    self.avPlayer?.play()
                }
                self.updateAudioPlayerUI(indexPath)
            } else {
                debugPrint("\(#function) reset")
                
                self.stopPlayer()
                self.updateAudioPlayerUI(self.previousAudioSelectedIndexPath)
                self.previousAudioSelectedIndexPath = nil
                self.btnAudioPlayClick(sender: sender)
            }
        } else {
            debugPrint("\(#function) new")
            self.previousAudioSelectedIndexPath = indexPath
            self.playMusicAt(index: sender.tag)
        }
    }
    
    func playMusicAt(index: Int) {
//        guard self.chatMessages.count > index else { return }
//        let chatMessage = self.chatMessages[index]
//        let message = chatMessage["message"] as AnyObject
//        let strMessage = String(describing: message)
//        let audioId = chatMessage["message_id"] as? String ?? ""
        
        guard self.chatMessages.count > index else { return }
        let chatMessage = self.chatMessages[index]
        guard let url = (chatMessage["media_file"] as! String).url else { return }
        
//        if let data = Data(base64Encoded: strMessage) {
//            let player = try? AVAudioPlayer(data: data)
//            player?.prepareToPlay()
//            player?.play()
//        }
        
        if self.avPlayer != nil {
            self.stopPlayer()
        }
        
//        if self.previousAudioSelectedIndexPath != nil {
//            if !self.isPlayerOberverAdded {
//                NotificationCenter.default.addObserver(self, selector: #selector(avPlayerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//                self.isPlayerOberverAdded = true
//            }
//            if self.avPlayer == nil {
////                self.avPlayer = AVPlayer(url: url)
//                if let data = Data(base64Encoded: strMessage) {
//                    if let audioURL = setupNamedPipe(withData: data, audioId: audioId) {
//                        var strURL = audioURL.absoluteString
//                        if !strURL.contains(".m4a") {
//                            strURL = strURL + ".m4a"
//                        }
//                        let finalURL = URL(string: strURL)
//
//                        self.avPlayer = AVPlayer(url: finalURL!)
//                        self.avPlayer?.play()
//                        self.updateAudioPlayerUI(self.previousAudioSelectedIndexPath)
//                    }
//                }
//            }
////            self.avPlayer?.play()
////            self.updateAudioPlayerUI(self.previousAudioSelectedIndexPath)
//        }
        
        if self.previousAudioSelectedIndexPath != nil {
            if !self.isPlayerOberverAdded {
                NotificationCenter.default.addObserver(self, selector: #selector(avPlayerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                self.isPlayerOberverAdded = true
            }
            if self.avPlayer == nil {
                self.avPlayer = AVPlayer(url: url)
            }
            self.avPlayer?.play()
            self.updateAudioPlayerUI(self.previousAudioSelectedIndexPath)
        }
    }
    
    func setupNamedPipe(withData data: Data, audioId: String) -> URL? {
        // Build a URL for a named pipe in the documents directory
        let fifoBaseName = "\(audioId)" //"myRecording"
        let fifoUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent(fifoBaseName)

        // Ensure there aren't any remnants of the fifo from a previous run
        unlink(fifoUrl.path)

        // Create the FIFO pipe
        if mkfifo(fifoUrl.path, 0o666) != 0 {
            debugPrint("Failed to create named pipe")
            return nil
        }

        // Run the code to manage the pipe on a dispatch queue
        DispatchQueue.global().async {
            debugPrint("Waiting for somebody to read...")
            let fd = open(fifoUrl.path, O_WRONLY)
            if fd != -1 {
                debugPrint("Somebody is trying to read, writing data on the pipe")
                data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
                    let num = write(fd, bytes, data.count)
                    if num != data.count
                    {
                        debugPrint("Write error")
                    }
                }
                debugPrint("Closing the write side of the pipe")
                close(fd)
            } else {
                debugPrint("Failed to open named pipe for write")
            }

            debugPrint("Cleaning up the named pipe")
            unlink(fifoUrl.path)
        }
        return fifoUrl
    }
    
    func stopPlayer() {
        self.avPlayer?.pause()
        if self.isPlayerOberverAdded {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            self.isPlayerOberverAdded = false
        }
        self.avPlayer = nil
    }
    
    func updateAudioPlayerUI(_ indexPath: IndexPath) {
        let isPlay = self.avPlayer?.isPlaying ?? false
        debugPrint("\(#function) indexPath: \(indexPath), isPlay: \(isPlay)")

        if self.chatMessages.count > indexPath.row {
            var objMessage = self.chatMessages[indexPath.row]
            
            if isPlay == false {
                objMessage["isPlaying"] = false as AnyObject
            } else {
                objMessage["isPlaying"] = true as AnyObject
            }
            
            self.chatMessages[indexPath.row] = objMessage
            self.tblMessages.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    @objc func btnFileClick(_ sender: UIButton) {
        let fileURL = "http://www.africau.edu/images/default/sample.pdf"
        
        self.viewPopup.isHidden = false
        self.viewWeb.isHidden = false
        self.scrollPreview.isHidden = true
        self.loadWebview(strURL: fileURL)
    }
    
    func loadWebview(strURL: String) {
        let webView = WKWebView(frame: CGRect (x: 0, y: 0, width: self.viewWeb.frame.size.width, height: self.viewWeb.frame.size.height))
        webView.tag = 100
        webView.navigationDelegate = self
        self.viewWeb.addSubview(webView)
       
        if let url = URL(string: strURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

//MARK: - WEBVIEW DELEGATE METHOD -

extension ChatVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("Start to load")
        GlobalData.shared.showDefaultProgress()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("Finish")
        GlobalData.shared.hideProgress()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint("Fail")
        GlobalData.shared.hideProgress()
    }
}

//MARK: - API CALL -

extension ChatVC {
    //GET USER DETAIL BY USER ID
    func callGetUserDetail() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["userId"] = self.notificationUserID
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.PROFILE_BY_ID, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            let object: UserDetail = UserDetail.initWith(dict: payload.removeNull())
                            
                            strongSelf.objNotiUserDetail = object
                            
                            if strongSelf.objNotiUserDetail.profileImage == "" {
                                strongSelf.imgUser.image = UIImage.init(named: "user_placeholder")
                            } else {
                                strongSelf.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                                strongSelf.imgUser.sd_setImage(with: URL(string: strongSelf.objNotiUserDetail.profileImage), placeholderImage: UIImage.init(named: "user_placeholder"))
                            }
                            
                            strongSelf.lblUsername.text = strongSelf.objNotiUserDetail.userName
                            
                            strongSelf.RoomID = strongSelf.objNotiUserDetail._id
                            GlobalData.shared.JoinedRoomID = strongSelf.RoomID
                            
                            strongSelf.callGetAllMessagesAPI()
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
    
    //SEND PUSH NOTIFICATION FOR CALL
    func callSendNotificationForCall(CallType callType: String) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var strReceiverID:String = ""
        
        if self.isComeFromPushNotification == false {
            if self.isFromFriendList == true {
                strReceiverID = self.objContactDetail.userId
            } else {
                strReceiverID = ""//self.objThreadDetail.oposite_id
            }
        } else {
            strReceiverID = self.notificationUserID
        }
        
        var params: [String:Any] = [:]
        params["receiver_id"] = strReceiverID
        params["call_type"] = callType
        
        GlobalData.shared.showDefaultProgress()
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.CALL_NOTIFICATION, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if callType == "audio" {
                            strongSelf.initiateCall(to: strongSelf.RoomID, type: .user, callType: .audio)
                        } else {
                            strongSelf.initiateCall(to: strongSelf.RoomID, type: .user, callType: .video)
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
    
    //GET ALL MESSAGE
    func callGetAllMessagesAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var strReceiverID:String = ""
        
        if self.isComeFromPushNotification == false {
            if self.isFromFriendList == true {
                strReceiverID = self.objContactDetail.userId
            } else {
                strReceiverID = ""//self.objThreadDetail.oposite_id
            }
        } else {
            strReceiverID = self.notificationUserID
        }
        
        var params: [String:Any] = [:]
        params["receiver_id"] = strReceiverID
        params["page_no"] = self.pageNo
//        params["limit"] = 20
        
//        if self.isShowLoader == true {
            GlobalData.shared.showDefaultProgress()
//        }
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.GET_MESSAGES, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
//            if strongSelf.isShowLoader == true {
                GlobalData.shared.hideProgress()
//            }
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let data = response["data"] as? Dictionary<String, Any> {
                            if let pageInfo = data["page_info"] as? [Dictionary<String, Any>] {
                                if pageInfo.count > 0 {
                                    let objFirst = pageInfo[0] as Dictionary<String, Any>
                                    strongSelf.totalMessages = objFirst["total"] as! Int
                                    
                                    if strongSelf.totalMessages > strongSelf.chatMessages.count {
                                        strongSelf.pageNo += 1
                                    }
                                }
                            }
                            
                            if let payloadData = data["payload"] as? [Dictionary<String, Any>] {
                                var reverseArray = payloadData
                                reverseArray.reverse()
                                
                                var finalArr: [Dictionary<String,Any>] = []
                                
                                for i in 0..<reverseArray.count {
                                    let objData = reverseArray[i] as Dictionary<String,Any>
                                    finalArr.append(objData)
                                }
                                
                                if finalArr.count > 0 {
                                    strongSelf.loadMore = true
                                    finalArr.append(contentsOf: strongSelf.chatMessages)
                                    strongSelf.chatMessages.removeAll()
                                    strongSelf.chatMessages = finalArr
                                    
                                    strongSelf.updateDuration()
                                } else {
                                    strongSelf.loadMore = false
                                }
                            }
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnSend.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnSend.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnSend.isUserInteractionEnabled = true
        }
    }
    
    func updateDuration() {
        for i in 0..<self.chatMessages.count {
            var dict = self.chatMessages[i]
            if dict["media_file"] != nil {
                if dict["message_type"] as! String == "audio" {
                    if let url = (dict["media_file"] as! String).url {
                        dict["duration"] = self.getAudioDuration(url)
                        dict["isPlaying"] = false as AnyObject
                        self.chatMessages[i] = dict
                    }
                }
            }
        }
        
        debugPrint("\(#function)")
        DispatchQueue.main.async {
            self.tblMessages.reloadData()
//            if self.isFirstApiCall == true {
//                if self.chatMessages.count > 1 {
//                    self.tblMessages.scrollToRow(at: IndexPath(row: self.chatMessages.count - 1, section: 0), at: .bottom, animated: false)
//                }
            self.scrollToBottom()
//            }
        }
    }
    
    func getAudioDuration(_ url: URL) -> Int {
        let asset1 = AVURLAsset(url: url)
        let totalSeconds = Int(CMTimeGetSeconds(asset1.duration))
        //                    let hours = totalSeconds / 3600
        //                    let minutes = (totalSeconds % 3600) / 60 //totalSeconds / 60
        //                    let seconds = (totalSeconds % 3600) % 60 //totalSeconds % 60
        //                    let mediaDuration = String(format:"%02i:%02i:%02i",hours,minutes, seconds)
        
        //                    let finalDuration = GlobalData.shared.FullTimeString(time: TimeInterval(totalSeconds))
        
        //                    let url = URL(string: objTimeline.file_upload_url)
        //                    let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        ////                    let player = AVPlayer(playerItem: playerItem)
        //                    let duration : CMTime = playerItem.asset.duration
        //                    let totalSeconds : Float64 = CMTimeGetSeconds(duration)
        //                    let finalDuration = GlobalData.shared.FullTimeString(time: TimeInterval(totalSeconds))
        return totalSeconds
    }
    
    //SEND TEXT MESSAGE API
    func callSendTextMessageAPI(MessageType messageType: String, Message message: String, MessageDate messageDate: Double) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var strReceiverID:String = ""
        var strReceiverContact:String = ""
        
        if self.isComeFromPushNotification == false {
            if self.isFromFriendList == true {
                strReceiverID = self.objContactDetail.userId
                strReceiverContact = self.objContactDetail.contactNo
            } else {
                strReceiverID = self.objThreadDetail.oposite_id
                strReceiverContact = self.objThreadDetail.oposite_contact
            }
        } else {
            strReceiverID = self.notificationUserID
            strReceiverContact = self.notificationUserContact
        }
        
        var params: [String:Any] = [:]
        params["receiver_id"] = strReceiverID
        params["sender_contact"] = objUserDetail.contactNo
        params["receiver_contact"] = strReceiverContact
        params["message_type"] = messageType
        params["user_send_date"] = messageDate
        params["message"] = message
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.STORE_MESSAGE, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
                        
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payloadData = response["data"] as? Dictionary<String, Any> {
                            if let messageText = payloadData["message_text"] as? String {
                                let mediaFile:String = ""
                                
                                let messageId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                                
                                var sendMessageDict = Dictionary<String,AnyObject>()
                                sendMessageDict["message_id"] = messageId as AnyObject
                                sendMessageDict["sender_id"] = objUserDetail._id as AnyObject
                                sendMessageDict["room_id"] = strongSelf.RoomID as AnyObject
                                sendMessageDict["room_key"] = strongSelf.RoomID as AnyObject
                                sendMessageDict["message_text"] = messageText as AnyObject
                                sendMessageDict["media_file"] = mediaFile as AnyObject
                                sendMessageDict["message_type"] = messageType as AnyObject
                                sendMessageDict["createdAt"] = messageDate as AnyObject
                                sendMessageDict["isPlaying"] = false as AnyObject
                                sendMessageDict["duration"] = strongSelf.recordingTime as AnyObject
                                
                                strongSelf.txtMessage.text = ""
                                
                                var messageObject = Dictionary<String,Any>()
                                messageObject["message_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_id") as AnyObject
                                messageObject["sender_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "sender_id") as AnyObject
                                messageObject["room_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_id") as AnyObject
                                messageObject["room_key"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_key") as AnyObject
                                messageObject["message_text"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_text") as AnyObject
                                messageObject["media_file"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "media_file") as AnyObject
                                messageObject["message_type"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_type") as AnyObject
                                messageObject["createdAt"] = messageDate as AnyObject
                        //            messageObject["createdAt"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "createdAt") as AnyObject
                                messageObject["isPlaying"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "isPlaying") as AnyObject
                                messageObject["duration"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "duration") as AnyObject
                                
                                //CONVERT NORMAL MESSAGE TO UTF8 ENCODING TO LOAD IN LIST
        //                        let utf8Data = Data(textMessage?.utf8 ?? "".utf8)
        //                        let encodedMessage = String(data: utf8Data, encoding: .isoLatin1)!
        //                        messageObject["message"] = encodedMessage
                                
                                strongSelf.chatMessages.append(messageObject)
                                
                                DispatchQueue.main.async {
                                    strongSelf.tblMessages.reloadData()
                                    strongSelf.scrollToBottom()
                                }
                                
                                strongSelf.btnSend.isUserInteractionEnabled = true
                            }
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnSend.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnSend.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnSend.isUserInteractionEnabled = true
        }
    }
    
    //SEND IMAGE MESSAGE API
    func callSendImageMessageAPI(MessageType messageType: String, MessageDate messageDate: Double, files: [Document] = []) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var strReceiverID:String = ""
        var strReceiverContact:String = ""
        
        if self.isComeFromPushNotification == false {
            if self.isFromFriendList == true {
                strReceiverID = self.objContactDetail.userId
                strReceiverContact = self.objContactDetail.contactNo
            } else {
                strReceiverID = ""//self.objThreadDetail.oposite_id
                strReceiverContact = ""//self.objThreadDetail.oposite_contact
            }
        } else {
            strReceiverID = self.notificationUserID
            strReceiverContact = self.notificationUserContact
        }
        
        var params: [String:Any] = [:]
        params["receiver_id"] = strReceiverID
        params["sender_contact"] = objUserDetail.contactNo
        params["receiver_contact"] = strReceiverContact
        params["message_type"] = messageType
        params["user_send_date"] = messageDate
        
        AFWrapper.shared.postWithUploadMultipleFiles(files, strURL: Constants.URLS.STORE_MESSAGE, params: params as [String : AnyObject], headers: nil, success: { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payloadData = response["data"] as? Dictionary<String, Any> {
                            if let mediaFile = payloadData["media_file"] as? String {
                                let messageText:String = ""
                                
                                let messageId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                                
                                var sendMessageDict = Dictionary<String,AnyObject>()
                                sendMessageDict["message_id"] = messageId as AnyObject
                                sendMessageDict["sender_id"] = objUserDetail._id as AnyObject
                                sendMessageDict["room_id"] = strongSelf.RoomID as AnyObject
                                sendMessageDict["room_key"] = strongSelf.RoomID as AnyObject
                                sendMessageDict["message_text"] = messageText as AnyObject
                                sendMessageDict["media_file"] = mediaFile as AnyObject
                                sendMessageDict["message_type"] = messageType as AnyObject
                                sendMessageDict["createdAt"] = messageDate as AnyObject
                                sendMessageDict["isPlaying"] = false as AnyObject
                                sendMessageDict["duration"] = strongSelf.recordingTime as AnyObject
                                
                                strongSelf.txtMessage.text = ""
                                
                                var messageObject = Dictionary<String,Any>()
                                messageObject["message_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_id") as AnyObject
                                messageObject["sender_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "sender_id") as AnyObject
                                messageObject["room_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_id") as AnyObject
                                messageObject["room_key"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_key") as AnyObject
                                messageObject["message_text"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_text") as AnyObject
                                messageObject["media_file"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "media_file") as AnyObject
                                messageObject["message_type"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_type") as AnyObject
                                messageObject["createdAt"] = messageDate as AnyObject
                        //            messageObject["createdAt"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "createdAt") as AnyObject
                                messageObject["isPlaying"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "isPlaying") as AnyObject
                                messageObject["duration"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "duration") as AnyObject
                                
                                strongSelf.chatMessages.append(messageObject)
                                
                                DispatchQueue.main.async {
                                    strongSelf.tblMessages.reloadData()
                                    strongSelf.scrollToBottom()
                                }
                                
                                strongSelf.btnSend.isUserInteractionEnabled = true
                            }
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnSend.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnSend.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnSend.isUserInteractionEnabled = true
        }
    }
    
    //SEND AUDIO MESSAGE API
    func callSendAudioMessageAPI(MessageType messageType: String, MessageDate messageDate: Double, files: [Document] = []) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var strReceiverID:String = ""
        var strReceiverContact:String = ""
        
        if self.isComeFromPushNotification == false {
            if self.isFromFriendList == true {
                strReceiverID = self.objContactDetail.userId
                strReceiverContact = self.objContactDetail.contactNo
            } else {
                strReceiverID = ""//self.objThreadDetail.oposite_id
                strReceiverContact = ""//self.objThreadDetail.oposite_contact
            }
        } else {
            strReceiverID = self.notificationUserID
            strReceiverContact = self.notificationUserContact
        }
        
        var params: [String:Any] = [:]
        params["receiver_id"] = strReceiverID
        params["sender_contact"] = objUserDetail.contactNo
        params["receiver_contact"] = strReceiverContact
        params["message_type"] = messageType
        params["user_send_date"] = messageDate
        
        AFWrapper.shared.postWithUploadMultipleFiles(files, strURL: Constants.URLS.STORE_MESSAGE, params: params as [String : AnyObject], headers: nil, success: { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payloadData = response["data"] as? Dictionary<String, Any> {
                            if let mediaFile = payloadData["media_file"] as? String {
                                let messageText:String = ""
                                
                                let messageId = strongSelf.uniqueID
                                
                                var sendMessageDict = Dictionary<String,AnyObject>()
                                sendMessageDict["message_id"] = messageId as AnyObject
                                sendMessageDict["sender_id"] = objUserDetail._id as AnyObject
                                sendMessageDict["room_id"] = strongSelf.RoomID as AnyObject
                                sendMessageDict["room_key"] = strongSelf.RoomID as AnyObject
                                sendMessageDict["message_text"] = messageText as AnyObject
                                sendMessageDict["media_file"] = mediaFile as AnyObject
                                sendMessageDict["message_type"] = messageType as AnyObject
                                sendMessageDict["createdAt"] = messageDate as AnyObject
                                sendMessageDict["isPlaying"] = false as AnyObject
                                sendMessageDict["duration"] = strongSelf.recordingTime as AnyObject
                                
                                strongSelf.txtMessage.text = ""
                                strongSelf.recordingTime = ""
                                
                                var messageObject = Dictionary<String,Any>()
                                messageObject["message_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_id") as AnyObject
                                messageObject["sender_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "sender_id") as AnyObject
                                messageObject["room_id"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_id") as AnyObject
                                messageObject["room_key"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "room_key") as AnyObject
                                messageObject["message_text"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_text") as AnyObject
                                messageObject["media_file"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "media_file") as AnyObject
                                messageObject["message_type"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "message_type") as AnyObject
                                messageObject["createdAt"] = messageDate as AnyObject
                        //            messageObject["createdAt"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "createdAt") as AnyObject
                                messageObject["isPlaying"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "isPlaying") as AnyObject
                                messageObject["duration"] = GlobalData.GetValueFromData(dataDict: sendMessageDict, key: "duration") as AnyObject
                                
                                strongSelf.chatMessages.append(messageObject)
                                
                                DispatchQueue.main.async {
                                    strongSelf.tblMessages.reloadData()
                                    strongSelf.scrollToBottom()
                                }
                                
                                strongSelf.btnSend.isUserInteractionEnabled = true
                            }
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnSend.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnSend.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnSend.isUserInteractionEnabled = true
        }
    }
}
