//
//  Notification.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 19/05/22.
//

import UIKit

class NotificationVC: BaseVC {
    
    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    func initData() {
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    
    // MARK: - ACTIONS -
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.pop()
    }
   

}

extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    
}
