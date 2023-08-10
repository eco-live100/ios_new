//
//  CategoryList.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 12/05/22.
//

import UIKit

class CategoryList: BaseVC {
    
//    var productCategory = ["Fashion & Beauty","Electronics and Devices","Home & diy","Office & Professional","Automotive","Toys","Kids & Babies","Others"]
    private var selectSection : Int?
    @IBOutlet weak var tableView: UITableView!
    var productCategory: [ShopInfoCategoryObject] = []

    var applyFilter: ((ShopInfoCategorySubObject) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    // MARK: Private Funcation
    func initData(){
        
        if #available(iOS 15.0, *) {
            tableView .sectionHeaderTopPadding = 0
        }
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 30
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        apiShopCatlist()
    }
    
  
}

extension CategoryList : UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionGet = selectSection {
            if sectionGet == section {
                return productCategory[section].shopInfoCategorySubObject.count
            }
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = productCategory[indexPath.section].shopInfoCategorySubObject[indexPath.row].name 
        //"\(productCategory[indexPath.section].name ) - \(indexPath.row)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = UIView(frame:CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 55))
        let imagemenu = UIImageView()
        imagemenu.frame = CGRect(x: 10, y:10, width: 15, height: 15)
        imagemenu.backgroundColor = .clear
        imagemenu.contentMode = .center
        imagemenu.tintColor = .black
        imagemenu.image = UIImage(named: "ic_back_right")
        if let sectionGet = selectSection {
            if sectionGet == section {
                imagemenu.image = UIImage(named: "ic_down_arrow_black")
            }
        }
        imagemenu.clipsToBounds = true
        imagemenu.contentMode = .scaleAspectFit
        

        viewHeader.addSubview(imagemenu)
        let menulabel = UILabel()
        menulabel.frame = CGRect(x: 40, y: 5, width: tableView.frame.width - 80, height: 0)
        //menulabel.font = menulabel.font.withSize(20)
        menulabel.font = UIFont(name:Constants.Font.ROBOTO_MEDIUM, size: 18.0)
        menulabel.numberOfLines = 0
        menulabel.backgroundColor = .clear
        viewHeader.addSubview(menulabel)
        menulabel.text = productCategory[section].name ?? ""
        menulabel.sizeToFit()
        DispatchQueue.main.async {
            menulabel.frame.size = menulabel.bounds.size
        }
        menulabel.frame.size = menulabel.bounds.size
        
        let buttomLine = UIButton(frame: CGRect(x: 0, y: (10 + menulabel.bounds.size.height), width: tableView.frame.width, height: 0.5))
        buttomLine.setTitle("", for: .normal)
        buttomLine.backgroundColor = Constants.Color.THEME_BLACK
        viewHeader.addSubview(buttomLine)

        
        let buttonClick = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: viewHeader.frame.height))
        buttonClick.setTitle("", for: .normal)
        buttonClick.tag = section
        buttonClick.addTarget(self, action: #selector(handleTapOnHeader(_:)), for: .touchUpInside)
        viewHeader.addSubview(buttonClick)
        
        viewHeader.clipsToBounds = true
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    
    @objc func handleTapOnHeader(_ sender: UIButton? = nil) {

        selectSection = sender?.tag
        tableView.reloadData()
       // self.dismiss()
        
    }
    
    @IBAction func btnSelectLocationClick(_ sender: UIButton) {
        self.dismiss()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let sectionGet = selectSection {
            if sectionGet == indexPath.section {
                let selectCat = productCategory[sectionGet].shopInfoCategorySubObject[indexPath.row]
                print(selectCat._id)
                print(selectCat.shopCategoryId)
                print(selectCat.name)
                self.applyFilter!(selectCat)
                self.dismiss()
            }
        }
    }
}
extension CategoryList : UITableViewDelegate  {
    
    
    
}

extension CategoryList {

    func apiShopCatlist(){

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.GET_SHOP_CATEGORIES_LIST, parameters: [:]) { responce in
            print(responce)
            GlobalData.shared.hideProgress()
//            self.productCategory = []
            switch responce {
            case .success(let jsondata):
                print(jsondata)
                if let shopTypeList = jsondata["data"] as? NSArray {

                    for i in 0..<shopTypeList.count {
                        let objData = ShopInfoCategoryObject.init(shopTypeList[i] as! [String : Any])
                        //self.productCategory.append(objData.name)
                        self.productCategory.append(objData)
                    }

                    self.tableView.reloadData()


                    //                    self.setupShopCategoryDropDown()
                    //

                    //                    if let vehicleCategory = payloadData["vehicleCategory"] as? NSArray {
                    //
                    //                        for i in 0..<vehicleCategory.count  {
                    //                            let objData = ProductCategoryObjectNew.init(vehicleCategory[i] as! [String : Any])
                    //                            //self.arrVehicleCategory.append(objData)
                    //                        }
                    //                    }
                    //                    if let vehicleType = payloadData["vehicleType"] as? NSArray {
                    //                        for i in 0..<vehicleType.count  {
                    //                            let objData = ProductTypeObjectNew.init(vehicleType[i] as! [String : Any])
                    //                            //self.arrVehicleType.append(objData)
                    //                        }
                    //                    }

                    //self.setupCategoryDropDown()

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


}
