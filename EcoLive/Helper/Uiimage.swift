//
//  Uiimage.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 18/05/22.
//

import Foundation
import UIKit


class CustomeImage: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setRadiusAndShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setRadiusAndShadow()
    }
    
    func setRadiusAndShadow() {
        layer.cornerRadius = 22.5
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowColor = UIColor.init(hexString: "A8FEA4")?.cgColor //#A8FEA4
    }
}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat, isNew : Bool = true) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
