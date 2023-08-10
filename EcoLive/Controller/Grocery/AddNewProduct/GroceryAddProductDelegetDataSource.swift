//
//  GroceryAddProductDelegetDataSource.swift
//  EcoLive
//
//  Created by  on 26/11/22.
//

import Foundation
extension GroceryProductCreate : UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return arProductImage.count
        }else{
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clViewImagesProduct", for: indexPath) as? clViewImagesProduct else { return UICollectionViewCell() }
            if arProductImage.count > 0 {
                cell.imgMainProduct.image = arProductImage[indexPath.row].image
                cell.imgMainProduct.contentMode = .scaleAspectFill
            }
            if indexPath.row == 0 {
                self.imgMainProduct.image = arProductImage[indexPath.row].image
                self.imgMainProduct.contentMode = .scaleAspectFill
            }

            return cell
        }else{
            // Select Image
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clViewImagesProductAdd", for: indexPath) as? UICollectionViewCell else { return UICollectionViewCell() }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.selectImageMode = .Add
            self.showMediaPickerOptions()
        }else{
            self.imgMainProduct.image = arProductImage[indexPath.row].image
            self.imgMainProduct.contentMode = .scaleAspectFill
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5)
    }


}
