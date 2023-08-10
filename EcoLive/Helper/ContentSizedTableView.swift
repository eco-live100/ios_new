//
//  ContentSizedTableView.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 02/06/21.
//

import UIKit

class ContentSizedTableView: UITableView {

    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
