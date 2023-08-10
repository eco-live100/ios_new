//
//  ImageSlideTVCell.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//


import UIKit

class ImageSlideTVCell: UITableViewCell {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var viewC : UIView!
    @IBOutlet weak var slideCollectionV : UICollectionView!
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    @IBOutlet weak var lblBringMeHome: UILabel!
    
    
    //MARK: - Properties
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //slideCollectionV.isUserInteractionEnabled = false
        
       
        startTimer()
        slideCollectionV.delegate = self
        slideCollectionV.dataSource = self
    }
    

    func startTimer() {

        _ =  Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {

        if let coll  = slideCollectionV {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < 3){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    pageCtrl.currentPage = indexPath1?.item ?? 0
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: false)
                    pageCtrl.currentPage = indexPath1?.item ?? 0
                }
            }
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
//MARK: - Collection View Delegate and DataSource

extension ImageSlideTVCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageCtrl.numberOfPages = 4
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = slideCollectionV.dequeueReusableCell(withReuseIdentifier: "SlideImageCVCell", for: indexPath) as! SlideImageCVCell

        
        cell.img.image = UIImage(named: ["img1","img2","img3","img1",][indexPath.row])
        
        return cell
    }
}

//MARK: - UICollection View DelegateFlowlayout

extension ImageSlideTVCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = slideCollectionV.frame.width
        return CGSize(width: width/1, height: slideCollectionV.frame.height)
    }
    
}
