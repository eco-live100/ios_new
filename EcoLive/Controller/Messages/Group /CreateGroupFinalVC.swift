//
//  CreateGroupFinalVC.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 26/05/22.
//

import UIKit

class CreateGroupFinalVC: BaseVC {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var clView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clView.delegate = self
        clView.dataSource = self
        
    }
    
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func btnDoneClick(_ sender: UIButton) {
        self.pop()
    }
}



extension CreateGroupFinalVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedUserChat", for: indexPath) as! selectedUserChat
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 100)
    }
    
    
}



