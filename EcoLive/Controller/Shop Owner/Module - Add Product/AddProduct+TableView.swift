//
//  AddProduct+TableView.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 14/07/22.
//

import Foundation
import UIKit

@available(iOS 14.0, *)
extension AddProductViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        return self.mainData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var Identifier:String = ""
        if indexPath.row == 0{
            let cell = tableAddProduct.dequeueReusableCell(withIdentifier: "AddProductImageTableCell", for: indexPath) as! AddProductImageTableCell
            return cell
        }
        
        let productobject = self.mainData[indexPath.row]
        
        if productobject.inputType.lowercased()  == "text" {
            let cell = tableAddProduct.dequeueReusableCell(withIdentifier: "ProductInputTextTableCell", for: indexPath) as! ProductInputTextTableCell
            cell.cellModel = productobject
            cell.vc = self
            return cell
        } else if productobject.inputType.lowercased() == "dropdown"{
            let cell = tableAddProduct.dequeueReusableCell(withIdentifier: "ProductInputDropdownTableCell", for: indexPath) as! ProductInputDropdownTableCell
            cell.cellModel = productobject
            return cell
        } else if productobject.inputType.lowercased() == "textarea"{
            let cell = tableAddProduct.dequeueReusableCell(withIdentifier: "ProductInputTextareaTableCell", for: indexPath) as! ProductInputTextareaTableCell
            cell.cellModel = productobject
            return cell
        } else if productobject.inputType.lowercased()  == "number"{
            let cell = tableAddProduct.dequeueReusableCell(withIdentifier: "ProductInputTextTableCell", for: indexPath) as! ProductInputTextTableCell
            cell.cellModel = productobject
            return cell
        } else if productobject.inputType.lowercased()  == "color"{
            let cell = tableAddProduct.dequeueReusableCell(withIdentifier: "ProductInputColorTableCell", for: indexPath) as! ProductInputColorTableCell
            cell.cellModel = productobject
            cell.btnSelectColorAction = { [weak self] (model) in
                self?.presentColorClicked(indexPath: indexPath)
            }
            return cell
        } else if productobject.inputType.lowercased()  == "date"{
            let cell = tableAddProduct.dequeueReusableCell(withIdentifier: "ProductInputDateTableCell", for: indexPath) as! ProductInputDateTableCell
            cell.cellModel = productobject
            return cell
        }
        
        return UITableViewCell()
    }
    
    func presentColorClicked(indexPath : IndexPath){
        self.selectedColorCellIndex = indexPath
        self.present(picker, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        let productobject = self.mainData[indexPath.row]
//
//        if productobject.inputType == "textarea"{
//            return 150
//        } else if productobject.inputType == "color"{
//            return 150
//        } else if ["dropdown","number","text","date"].contains(productobject.inputType.lowercased()){
//            return 100
//        }
        return 200
    }
    
}
