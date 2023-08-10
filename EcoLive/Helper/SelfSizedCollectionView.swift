//
//  SelfSizedCollectionView.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 02/06/21.
//

import UIKit

class SelfSizedCollectionView: UICollectionView {

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        let s = self.collectionViewLayout.collectionViewContentSize
        return CGSize(width: max(s.width, 1), height: max(s.height,1))
    }
}
