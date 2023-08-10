//
//  FoodAndGroceryCategoryVC+TableView.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 30/06/22.
//

import Foundation

extension FoodAndGroceryCategoryVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodAndGroceryTableViewCell", for: indexPath) as! FoodAndGroceryTableViewCell
        cell.selectionStyle = .none

        switch self.vcType {
        case .taxi:

            self.bgBanner.image = UIImage(named: "b0")
            cell.itemImage.image = UIImage(named: "b0")
            cell.lblItem.text = "Item \(indexPath.row + 1)"

        case .food:

            self.bgBanner.image = UIImage(named: "b1")
            cell.itemImage.image = UIImage(named: "b1")
            cell.lblItem.text = "Item \(indexPath.row + 1)"
        case .grocery:
            self.bgBanner.image = UIImage(named: "b2")
            cell.itemImage.image = UIImage(named: "b2")
            cell.lblItem.text = "Item \(indexPath.row + 1)"
        case .pharmacy:
            self.bgBanner.image = UIImage(named: "b3")
            cell.itemImage.image = UIImage(named: "b3")
            cell.lblItem.text = "Item \(indexPath.row + 1)"
        case .retail:
            self.bgBanner.image = UIImage(named: "b4")
            cell.itemImage.image = UIImage(named: "b4")
            cell.lblItem.text = "Item \(indexPath.row + 1)"

        default:
            print()
        }



        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
}
