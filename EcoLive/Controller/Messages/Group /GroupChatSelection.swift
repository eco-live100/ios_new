//
//  GroupChatSelection.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 26/05/22.
//

import UIKit

class GroupChatSelection: BaseVC {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var clView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbView.delegate = self
        tbView.dataSource = self
        
        clView.delegate = self
        clView.dataSource = self
        
    }
    
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func btnNextClick(_ sender: UIButton) {
        
        let controller = GlobalData.messagesStoryBoard().instantiateViewController(withIdentifier: "CreateGroupFinalVC") as! CreateGroupFinalVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


extension GroupChatSelection : UITableViewDelegate, UITableViewDataSource {
    
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

extension GroupChatSelection : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedUserChat", for: indexPath) as! selectedUserChat
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }


}

class selectedUserChat : UICollectionViewCell {
    
}

