//
//  CreatChatGroup.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 26/05/22.
//

import UIKit



class CreatChatGroup: BaseVC {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tbView: UITableView!
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbView.delegate = self
        tbView.dataSource = self
        
        DispatchQueue.main.async {
            
            self.viewSearch.layer.masksToBounds = false
            self.viewSearch.layer.shadowRadius = 1
            self.viewSearch.layer.shadowOpacity = 0.6
            self.viewSearch.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewSearch.layer.shadowOffset = CGSize(width: 0, height: 2)
            
            self.searchBar.setupSearchBar(background: .clear, inputText: Constants.Color.THEME_BLACK, placeholderText: Constants.Color.SEARCHBAR_PLACEHOLDER, image: Constants.Color.SEARCHBAR_IMAGE)
        }

    }
    
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func btnCreateGroupClick(_ sender: UIButton) {
        
        let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "GroupChatSelection") as! GroupChatSelection
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}


extension CreatChatGroup : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupChatUser", for: indexPath) as! CreateGroupChatUser
        return cell

        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
