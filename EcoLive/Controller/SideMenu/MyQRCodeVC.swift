//
//  MyQRCodeVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 17/09/21.
//

import UIKit
import SideMenuSwift

class MyQRCodeVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgQR: UIImageView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
            
            self.btnDownload.layer.cornerRadius = self.btnDownload.frame.height / 2.0
            self.btnDownload.createButtonShadow()
            
            self.btnShare.layer.cornerRadius = self.btnShare.frame.height / 2.0
            self.btnShare.createButtonShadow()
        }
        
        self.createQRCodeImage()
    }
    
    //MARK: - HELPER -
    
    //code for a black foreground and white background
    func createQRCodeImage() {
        let myString = objUserDetail.email
        let data = myString.data(using: String.Encoding.ascii)
        
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        qrFilter.setValue(data, forKey: "inputMessage")
        
        guard let qrImage = qrFilter.outputImage else { return }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
        let processedImage = UIImage(cgImage: cgImage)
        
        self.imgQR.image = processedImage
    }
    
    //SHARE QR CODE
    func shareQRCode(Text text: String, QRImage qrImage: UIImage) {
        let objectsToShare: [Any] = [text, qrImage]

        if text == "" && qrImage.size.width == 0 {
            debugPrint("Noting to share")
        } else {
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }

            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    //SAVE QR CODE IMAGE IN DOCUMENT DIRECTORY
    func saveQRCodeImage(QRCode qrCode: UIImage) {
        let fileManager = FileManager.default
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let filePath =   documentsDirectory.appendingPathComponent("Ecolive")
        
        if !fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Couldn't create document directory")
            }
        }
        NSLog("Document directory is \(filePath)")
        
        let fileName = "\(objUserDetail.userName)_qrCode" + ".png"
        
        let fileURL = filePath.appendingPathComponent("\(fileName)")
        
        guard let data = qrCode.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                debugPrint("Removed old image")
            } catch let removeError {
                debugPrint("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
            GlobalData.shared.showDarkStyleToastMesage(message: "Download completed!")
        } catch let error {
            debugPrint("error saving file with error", error)
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func btnCartClick(_ sender: UIButton) {
        let controller = GlobalData.cartStoryBoard().instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnDownloadClick(_ sender: UIButton) {
        self.saveQRCodeImage(QRCode: self.imgQR.image!)
    }
    
    @IBAction func btnShareClick(_ sender: UIButton) {
        if self.imgQR.image != nil {
            self.shareQRCode(Text: "My QR Code is:", QRImage: self.imgQR.image!)
        }
    }
}
