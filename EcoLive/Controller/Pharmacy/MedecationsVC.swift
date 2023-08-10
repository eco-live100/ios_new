//
//  MedecationsVC.swift
//  EcoLive
//
//  Created by sunil biloniya on 05/11/22.
//

import UIKit

class MedecationsVC: UIViewController {
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewAddCard: UIView!
    var arr = ["Atorvastatin","Alogliptin/Metformin","Lisinopril","Bupropion","Humalog","Spironolactone"]
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var collView_hc: NSLayoutConstraint!
    @IBOutlet weak var collectionFlow: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnContinue.layer.cornerRadius = self.btnContinue.frame.height / 2.0
        self.btnContinue.createButtonShadow()
        self.viewAddCard.drawShadow(borderWidth: 0)
        
        configationCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var height = collView.collectionViewLayout.collectionViewContentSize.height
        collView_hc.constant = height
        self.collView.setNeedsLayout()
        self.collView.layoutIfNeeded()
        self.collView.reloadData()
        collView.layoutIfNeeded()
    }
    //MARK: - FLOW LAYOUT
    func configationCollectionView (){
        collectionFlow.scrollDirection = .vertical
        collectionFlow.minimumLineSpacing = 5
        collectionFlow.minimumInteritemSpacing = 2
        let cellWidth = (collView.frame.size.width/3)-2
        collectionFlow.itemSize = CGSize(width: cellWidth , height: 40)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnContinueClick(_ sender: UIButton) {

        let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "PHSignUpIntro") as! PHSignUpIntro
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func btnHelpClick(_ sender: UIButton) {
        guard let url = URL(string: "https://www.ecommercepartners.net/content/contact-us") else { return }
        UIApplication.shared.open(url)
    }


}

extension MedecationsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MedicationCollectionCell", for: indexPath) as! MedicationCollectionCell
        cell.lblTitle.text = arr[indexPath.row]
        return cell
    }
}




class MedicationCollectionCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
