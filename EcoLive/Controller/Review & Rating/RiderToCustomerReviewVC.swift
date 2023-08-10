//
//  RiderToCustomerReviewVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 28/06/21.
//

import UIKit

class RiderToCustomerReviewVC: BaseVC {
    
    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnMore: UIButton!
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

extension RiderToCustomerReviewVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerToRiderReviewCell", for: indexPath) as! CustomerToRiderReviewCell
        
        cell.imgUser.image = UIImage.init(named: "review_placeholder")
        cell.lblUserName.text = "Greta Life"
        cell.lblTime.text = "1 week ago"
        cell.lblReview.text = "Here 03 day's before i had a pathetic experience about such a bad negligence by customer care service providers. Because being a delivery i was working sincerely without any remarks but due to their negligence."
        
        cell.ratingView.rating = 2.0
//        cell.ratingView.text = "(4.1)"
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - API CALL -

extension RiderToCustomerReviewVC {
    
}
