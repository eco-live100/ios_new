//
//  FoodAndGroceryCategoryVC.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 23/06/22.
//

import UIKit

class FoodAndGroceryCategoryVC: UIViewController {

    static func getObject()-> FoodAndGroceryCategoryVC {
        let storyboard = UIStoryboard(name: "ShopOwner", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FoodAndGroceryCategoryVC") as? FoodAndGroceryCategoryVC
        if let vc = vc {
            return vc
        }
        return FoodAndGroceryCategoryVC()
    }
    //MARK: - PROPERTIES & OUTLETS
    @IBOutlet weak var foodGroceryTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bgBanner: UIImageView!


    enum vcType {
        case taxi
        case food
        case grocery
        case pharmacy
        case retail
    }

    var vcType : vcType = .food

    var searchActive : Bool = false
    //MARK: - VIEWCONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        foodGroceryTableView.dataSource = self
        foodGroceryTableView.delegate = self
//        setupViewDetail()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - SETUP VIEW
    func setupViewDetail() {
        self.searchBar.showsCancelButton = false
        self.searchBar.delegate = self
    }
    
    //MARK: - ACTIONS
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - API CALL

}

//MARK: - UISEARCHBAR DELEGATE METHOD -

extension FoodAndGroceryCategoryVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if(searchBar.text != "") {
            self.searchActive = true
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar.showsCancelButton = true
        print("searchText",searchText)
        if(searchText != "") {
            self.searchActive = true
        } else {
            self.searchActive = false
        }
    }
}
