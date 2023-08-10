//
//  AddProductImageTableCell.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 14/07/22.
//

import UIKit

class AddProductImageTableCell: UITableViewCell {
   
    //MARK: - PROPERTIES & OUTLETS
    
    @IBOutlet weak var collectionProductImage: UICollectionView!
    @IBOutlet weak var imageAddProduct:UIImageView!
    @IBOutlet weak var buttonAddProduct: UIButton!
    
    var arrayofProductImage:[UIImage] = [UIImage]()
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionProductImage.dataSource = self
        collectionProductImage.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - ACTIONS
    
}

//MARK: - UICOLLECTIONVIEW DATASOURSE & DELEGATES METHOD

extension AddProductImageTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayofProductImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionCell", for: indexPath as IndexPath) as! ProductImageCollectionCell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 50, height: 50)
    }
}

class ProductImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageProduct: UIImageView!
}
