//
//  ColorChatBGVC.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 20/05/22.
//

import UIKit



class ColorChatBGVC: BaseVC {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    @IBOutlet weak var clViewBGImages: UICollectionView!
    @IBOutlet weak var clBGCOlors: UICollectionView!
    
    var arBGImages = ["cbg1","cbg2","cbg3"]
    var arBGColors = ["#FFFFFF","#85A2FF","#000000","#FBCDF0","#A0FF9B","#E9E9E9"]

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func btnBackClick(_ sender: UIButton) {
        self.pop()
    }
}
extension ColorChatBGVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clViewBGImages {
            return arBGImages.count
        }else{
            return arBGColors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bgColorCell", for: indexPath) as! bgColorCell
        if clViewBGImages == collectionView {
            cell.bgImage.image = UIImage(named: arBGImages[indexPath.row])
        }else{
            cell.bgImage.backgroundColor = GlobalData().hexStringToUIColor(hex: "\(arBGColors[indexPath.row])")
        }
        return cell
        
    }
    
}
extension ColorChatBGVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if clViewBGImages == collectionView {
            return CGSize(width: collectionView.frame.width / 2 , height: collectionView.frame.height)

        }
        return CGSize(width: 124, height: 124)

    }
}
