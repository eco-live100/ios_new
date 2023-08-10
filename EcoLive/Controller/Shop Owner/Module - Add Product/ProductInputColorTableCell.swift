//
//  ProductInputColorTableCell.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 19/07/22.
//

import UIKit

class ProductInputColorTableCell: UITableViewCell {
    
    @IBOutlet weak var collectionSelectedColor:UICollectionView!
    @IBOutlet weak var SelectedColor: UIControl!
    
    var btnSelectColorAction: ((String) -> ())?
    var cellModel : ProductAttribute!
    var arraySelectedColor:[UIColor] = [UIColor]() {
        didSet{
            var arrTemp = [String]()
            for item in arraySelectedColor{
                arrTemp.append(String("#" + item.toHex!))
            }
            cellModel.inputColor = arrTemp
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionSelectedColor.delegate = self
        collectionSelectedColor.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func actionSelectColor (_ sender: UIControl){
        self.btnSelectColorAction?("sdsds")
    }
    
    @IBAction func actionAddColor (_ sender: UIControl){
        if SelectedColor.backgroundColor != .clear{
            print("colo", SelectedColor.backgroundColor!)
            self.arraySelectedColor.append(SelectedColor.backgroundColor!)
            SelectedColor.backgroundColor = .clear
            collectionSelectedColor.reloadData()
        }else{
            GlobalData.shared.showDarkStyleToastMesage(message: "Select Color")
        }
    }
    

}
//MARK: - UICOLLECTIONVIEW DATASOURSE & DELEGATES METHOD

extension ProductInputColorTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySelectedColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductColorCollectionCell", for: indexPath as IndexPath) as! ProductColorCollectionCell
        let obj = arraySelectedColor[indexPath.row]
        cell.viewcolor.backgroundColor = obj
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 40)
    }
}

class ProductColorCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var buttonRemoveColor: UIButton!
    @IBOutlet weak var viewcolor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonRemoveColor.setTitle("", for: .normal)
        // Initialization code
    }
    
}
