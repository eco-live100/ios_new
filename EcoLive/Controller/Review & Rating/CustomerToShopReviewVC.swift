//
//  CustomerToShopReviewVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 28/06/21.
//

import UIKit

class CustomerToShopReviewVC: BaseVC {

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

extension CustomerToShopReviewVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerToShopReviewCell", for: indexPath) as! CustomerToShopReviewCell
        
        cell.imgUser.image = UIImage.init(named: "review_placeholder")
        cell.lblUserName.text = "Petey Cruiser"
        cell.lblTime.text = "3 weeks ago"
        cell.lblReview.text = "This is a fantastic shop and one of my favourite shop to stay.love the staff here and their products! it gets crowded something but not too bad."
        
        cell.ratingView.rating = 4.0
//        cell.ratingView.text = "(4.1)"
        
        cell.btnReply.tag = indexPath.section
        cell.btnReply.addTarget(self, action: #selector(btnReplyClick), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185.0
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

extension CustomerToShopReviewVC {
    
}
