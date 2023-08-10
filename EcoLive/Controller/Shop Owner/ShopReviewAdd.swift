//
//  ShopReviewAdd.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 30/05/22.
//

import UIKit
import AlignedCollectionViewFlowLayout

class ShopReviewAdd: BaseVC {

    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var clView2: UICollectionView!

    var titleArray = ["All was perfect","I am mostly satisfied"]
    var titleArray2 = ["Was not Clean","Wasn't polite or respectful","didn't communicate well"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        
    }
    
    func initData(){
        
        clView.dataSource = self
        clView.delegate = self
        
        clView2.dataSource = self
        clView2.delegate = self
        
//        DispatchQueue.main.async {
//
//            let alignedFlowLayout = AlignedCollectionViewFlowLayout(
//                horizontalAlignment: .left,
//                verticalAlignment: .top
//            )
//            self.clView.collectionViewLayout = alignedFlowLayout
//            self.clView2.collectionViewLayout = alignedFlowLayout
//
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ShopReviewAdd : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clView {
            return titleArray.count
        }else{
            return titleArray2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == clView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewSuggetionCell", for: indexPath) as! ReviewSuggetionCell
            cell.lblTitle.text = titleArray[indexPath.row]
            return cell
        
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewSuggetionCell2", for: indexPath) as! ReviewSuggetionCell
            cell.lblTitle.text = titleArray2[indexPath.row]
            return cell
        }
        
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//       // return CGSize(width: 60, height: 60)
//    }
    
}



