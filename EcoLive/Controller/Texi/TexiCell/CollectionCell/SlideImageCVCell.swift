//
//  SlideImageCVCell.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit

class SlideImageCVCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var viewC: UIView!
    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var lblBringTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewC.setCornerRadiusWithBorder(cornerRadius: 12)
        img.setCornerRadiusWithBorder(cornerRadius: 12)
        gradientView.applyGradient(isVertical: false, colorArray: [.black,.black,.black, .clear])
       
    }
}
extension UIView{
    
    func setCornerRadiusWithBorder(cornerRadius:CGFloat = 10, clipsToBound:Bool = true, borderWidth:CGFloat = 0.0, borderColor:CGColor? = UIColor.clear.cgColor){
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = clipsToBound
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor ?? UIColor().cgColor
        
    }
    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
                layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
                 
                let gradientLayer = CAGradientLayer()
                    gradientLayer.colors = colorArray.map({ $0.cgColor })
                if isVertical {
                    //top to bottom
                    gradientLayer.locations = [0.0, 1.0]
                } else {
                    //left to right
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                }
                
                backgroundColor = .clear
                gradientLayer.frame = bounds
                layer.insertSublayer(gradientLayer, at: 0)
            }
}


