//
//  AddProductViewController.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 14/07/22.
//

import UIKit
import SwiftyJSON

@available(iOS 14.0, *)
class AddProductViewController: UIViewController {
    
    static func getObject()-> AddProductViewController {
        let storyboard = UIStoryboard(name: "ShopOwner", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController
        if let vc = vc {
            return vc
        }
        return AddProductViewController()
    }
    var myShop : ShopObject!

    var productName = ""

    
    //MARK: - PROPERTIES & OUTLETS
    @IBOutlet weak var tableAddProduct: UITableView!
    @IBOutlet weak var navigationHeaderView: UIView!

    
    var mainData:[ProductAttribute] = [ProductAttribute](){
        didSet{
            tableAddProduct.reloadData()
        }
    }
    
    // Initializing Color Picker
    let picker = UIColorPickerViewController()
    var selectedColorCellIndex: IndexPath = IndexPath()
    var selectedVendorShop : String = ""
    //MARK: -  PROPERTY OBESEVERR
 
    //MARK: - VIEWCONTROLLER LIFE CYCLE
  
    override func viewDidLoad() {
        super.viewDidLoad()
        callProductAttributeFormAPI()
        
        tableAddProduct.delegate = self
        tableAddProduct.dataSource = self
        self.navigationHeaderView.roundCorners(corners: [.bottomLeft , .bottomRight ], radius: 15.0)
        picker.selectedColor = .red
        picker.delegate = self
  
        // Do any additional setup after loading the view.
    }
    
    //MARK: - SETUP VIEW
    //MARK: - HELPER
    //MARK: - ACTIONS
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAddProduct(_ sender:UIButton){
        var productParams: [[String:Any]] = [[String:Any]]()
   
        for objectProject in mainData {
            if objectProject.inputType.lowercased() == "color"{
                if objectProject.validation.isRequire {
                    if objectProject.inputColor.count != 0 {
                        print(objectProject.inputColor)
                        productParams.append([objectProject.key:objectProject.inputColor])
                    }else{
                        self.showAlert(message: objectProject.validation.message)
                        break
                    }
                }
            } else {
                if objectProject.validation.isRequire {
                    if objectProject.inputValue != ""{
                        print(objectProject.inputValue)
                        productParams.append([objectProject.key:objectProject.inputValue])
                    }else{
                        self.showAlert(message: objectProject.validation.message)
                        break
                    }
                }
            }
        }



        // Dummy data


        var productParamsDummy = ["name" : productName,"color" : "red"]

        let params = ["shopCategoryId" : myShop.shopCategoryID,//self.mainData[0].shopCategoryID ,
                      "shopSubCategoryId" : myShop.shopSubCategoryID, //self.mainData[0].shopSubCategoryID ,
                      "vendorShopId" : myShop._id ,
                    "productData" : productParamsDummy
        ] as! [String : Any]
        
        self.callAddProductFormDataAPI(parm: params)


    }

    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    //MARK: - API CALL
    func callProductAttributeFormAPI() { 
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        var params: [String:Any] = [:]
        //63454ae4371e0a4d412176c0
        //633b0a424fb1678403deecbf
        //63454b02371e0a4d412176c3
        //633b0a424fb1678403deecbf // userId
        //6347f83a6e54f23001b6a89c // _id
        params["shopSubCategoryId"] = myShop.shopSubCategoryID
        
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.PRODUCT_ATTRIBUTE_FORM, parameters: params) { responce in
            GlobalData.shared.hideProgress()
            switch responce {
            case .success(let jsondata):
                let isSuccess:Int = jsondata["statusCode"] as! Int
                if(isSuccess == 200){
                    //                    guard let jsonData = try? JSONSerialization.data(withJSONObject: jsondata, options: .prettyPrinted),
                    //                          let user = try? JSONDecoder().decode(ProductAttributeModel.self, from: jsonData) else { return }
                    //                    self.mainData = user.data
                    
                    
                    do{
                        let jsonNew = try JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
                        let jsonN = try JSONDecoder().decode(ProductAttributeModel.self, from: jsonNew)
                        self.mainData = jsonN.data
                    } catch let error {
                        print(error)
                        print(error.localizedDescription)
                    }
                }
                
            case .failed(let errorMessage):
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            }
        }
    }
    
    func callAddProductFormDataAPI (parm : [String : Any]){
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        let vDocument : SSFiles = SSFiles(image: UIImage(named: "food")!, paramKey: "images")
        let sendFiles = [vDocument]

        NetworkManager.callServiceMultipalFiles(url: NetworkManager.New_API_DIR + Constants.URLS.ADD_PRODUCT, files: sendFiles, parameters: parm) { responce in
            GlobalData.shared.hideProgress()
            switch responce {
            case .success(let jsondata):
                let isSuccess:Int = jsondata["statusCode"] as! Int
                let message:String = jsondata["message"] as? String ?? ""

                if(isSuccess == 201){
                    //                    guard let jsonData = try? JSONSerialization.data(withJSONObject: jsondata, options: .prettyPrinted),
                    //                          let user = try? JSONDecoder().decode(ProductAttributeModel.self, from: jsonData) else { return }
                    //                    self.mainData = user.data

                    self.navigationController?.popViewController(animated: true)
                    GlobalData.shared.showDarkStyleToastMesage(message: message)

                    do {
                        let jsonNew = try JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
                        print(jsonNew)


                        //                        let jsonN = try JSONDecoder().decode(ProductAttributeModel.self, from: jsonNew)
                        //                        self.mainData = jsonN.data
                    } catch let error {
                        print(error)
                        print(error.localizedDescription)
                    }
                }

            case .failed(let errorMessage):
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            }
        }
        
//        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.ADD_PRODUCT, parameters: parm) { responce in
//            GlobalData.shared.hideProgress()
//            switch responce {
//            case .success(let jsondata):
//                let isSuccess:Int = jsondata["statusCode"] as! Int
//                if(isSuccess == 201){
//                    //                    guard let jsonData = try? JSONSerialization.data(withJSONObject: jsondata, options: .prettyPrinted),
//                    //                          let user = try? JSONDecoder().decode(ProductAttributeModel.self, from: jsonData) else { return }
//                    //                    self.mainData = user.data
//                    do {
//                        let jsonNew = try JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
//                        print(jsonNew)
////                        let jsonN = try JSONDecoder().decode(ProductAttributeModel.self, from: jsonNew)
////                        self.mainData = jsonN.data
//                    } catch let error {
//                        print(error)
//                        print(error.localizedDescription)
//                    }
//                }
//
//            case .failed(let errorMessage):
//                switch errorMessage {
//                default:
//                    self.handleDefaultResponse(errorMessage: errorMessage)
//                    break
//                }
//            }
//        }
    }
    
}

@available(iOS 14.0, *)
extension AddProductViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let cell = tableAddProduct.dequeueReusableCell(withIdentifier: "ProductInputColorTableCell", for: self.selectedColorCellIndex) as! ProductInputColorTableCell
        cell.SelectedColor.backgroundColor = viewController.selectedColor
        self.tableAddProduct.reloadData()
    }
}
