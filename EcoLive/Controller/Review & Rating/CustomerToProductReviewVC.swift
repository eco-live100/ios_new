//
//  CustomerToProductReviewVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 29/06/21.
//

import UIKit
import Cosmos
import GTProgressBar

class CustomerToProductReviewVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var viewRatingContent: UIView!
    @IBOutlet weak var ratingViewOverAll: CosmosView!
    @IBOutlet weak var fiveStarProgressBar: GTProgressBar!
    @IBOutlet weak var fourStarProgressBar: GTProgressBar!
    @IBOutlet weak var threeStarProgressBar: GTProgressBar!
    @IBOutlet weak var twoStarProgressBar: GTProgressBar!
    @IBOutlet weak var oneStarProgressBar: GTProgressBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewMore: UIView!
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
        }
        
        self.tblView.showsVerticalScrollIndicator = false
        self.tblView.tableFooterView = UIView()
        
        self.ratingViewOverAll.rating = 4.3
        self.ratingViewOverAll.text = "4.3 out of 5"
        
        if Constants.DeviceType.IS_IPHONE_5 {
            self.fiveStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 12.0)!
            self.fourStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 12.0)!
            self.threeStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 12.0)!
            self.twoStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 12.0)!
            self.oneStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 12.0)!
        }
        if Constants.DeviceType.IS_IPHONE_6 {
            self.fiveStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 13.0)!
            self.fourStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 13.0)!
            self.threeStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 13.0)!
            self.twoStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 13.0)!
            self.oneStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 13.0)!
        }
        if Constants.DeviceType.IS_IPHONE_6P {
            self.fiveStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15.0)!
            self.fourStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15.0)!
            self.threeStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15.0)!
            self.twoStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15.0)!
            self.oneStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15.0)!
        }
        if Constants.DeviceType.IS_IPHONE_X {
            self.fiveStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 14.0)!
            self.fourStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 14.0)!
            self.threeStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 14.0)!
            self.twoStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 14.0)!
            self.oneStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 14.0)!
        }
        if Constants.DeviceType.IS_IPHONE_11_PRO_MAX {
            self.fiveStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 16.0)!
            self.fourStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 16.0)!
            self.threeStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 16.0)!
            self.twoStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 16.0)!
            self.oneStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 16.0)!
        }
        if Constants.DeviceType.IS_IPHONE_12_PRO {
            self.fiveStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15.0)!
            self.fourStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15.0)!
            self.threeStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15.0)!
            self.twoStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15.0)!
            self.oneStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15.0)!
        }
        if Constants.DeviceType.IS_IPHONE_12_PRO_MAX {
            self.fiveStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 17.0)!
            self.fourStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 17.0)!
            self.threeStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 17.0)!
            self.twoStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 17.0)!
            self.oneStarProgressBar.font = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 17.0)!
        }
        
        self.fiveStarProgressBar.animateTo(progress: CGFloat(0.55))
        self.fourStarProgressBar.animateTo(progress: CGFloat(0.67))
        self.threeStarProgressBar.animateTo(progress: CGFloat(0.59))
        self.twoStarProgressBar.animateTo(progress: CGFloat(0.20))
        self.oneStarProgressBar.animateTo(progress: CGFloat(0.30))
        
        self.viewMore.isHidden = true
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMoreClick(_ sender: UIButton) {
        if self.btnMore.accessibilityViewIsModal {
            self.viewMore.isHidden = true
            self.btnMore.accessibilityViewIsModal = false
        } else {
            self.viewMore.isHidden = false
            self.btnMore.accessibilityViewIsModal = true
        }
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension CustomerToProductReviewVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerToProductReviewCell", for: indexPath) as! CustomerToProductReviewCell
        
        cell.imgUser.image = UIImage.init(named: "A")
        cell.lblUserName.text = "Petey Cruiser"
        cell.lblTime.text = "3 weeks ago"
        
        cell.lblContent1.text = "Very good product"
        cell.lblContent2.text = "Reviewed in Tokyo on 5 april 2021"
        cell.lblContent3.text = "Battery Life: 2o Hours" + " | " + "Wireless" + " | " + "Type: Over-ear"
        cell.lblReview.text = "This is a fantastic shop and one of my favourite shop to stay.love the staff here and their products! it gets crowded something but not too bad."

        if (indexPath.section % 2 == 0) {
            cell.stackviewImgReview.isHidden = false
            cell.imgReview.image = UIImage.init(named: "temp7")
        } else {
            cell.stackviewImgReview.isHidden = true
        }
        
        cell.ratingView.rating = 4.0
//        cell.ratingView.text = "(4.1)"
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //CELL ACTION
    @objc func btnReplyClick(_ sender: UIButton) {
        debugPrint("Reply Tag: \(sender.tag)")
    }
}

//MARK: - API CALL -

extension CustomerToProductReviewVC {
    
}
