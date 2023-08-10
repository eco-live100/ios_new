//
//  OnboardingVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 01/06/21.
//

import UIKit
import AdvancedPageControl
import SDWebImage

class OnboardingVC: UIViewController {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var pageControl: AdvancedPageControlView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var btnGetStartedBottomConstraint: NSLayoutConstraint!
    let reuseIdentifier = "BoardingCell"
    var arrOnboarding: [OnboardingObject] = []
    var currentPage: Int = 0
    
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
        self.btnSkip.isHidden = false
        self.btnNext.isHidden = false
        self.btnGetStarted.isHidden = true
        
        //FETCH ONBOARDING DATA
//        if let data = defaults.value(forKey: configurationData) as? Data,
//            let configData = try? JSONDecoder().decode(UtilityObject.self, from: data) {
//            GlobalData.shared.objConfiguration = configData
//
//            self.arrOnboarding = GlobalData.shared.objConfiguration.arrOnboarding
//        }
        
        self.pageControl.drawer = ExtendedDotDrawer(numberOfPages: self.arrOnboarding.count,
                                                    height: 8.0,
                                                    width: 8.0,
                                                    space: 16.0,
                                                    indicatorColor: Constants.Color.THEME_YELLOW,
                                                    dotsColor: Constants.Color.THEME_BLACK,
                                                    isBordered: false,
                                                    borderWidth: 0.0,
                                                    indicatorBorderColor: .clear,
                                                    indicatorBorderWidth: 0.0)
        
        if UIDevice.current.hasNotch {
            self.btnGetStartedBottomConstraint.constant = 0
        } else {
            self.btnGetStartedBottomConstraint.constant = 10
        }
        
        DispatchQueue.main.async {
            self.btnGetStarted.layer.cornerRadius = self.btnGetStarted.frame.height / 2.0
        }
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnSkipClick(_ sender: UIButton) {
        gotoRootVC()
    }
    
    @IBAction func btnNextClick(_ sender: UIButton) {
        if self.arrOnboarding.count - 1 > currentPage {
            collectionView.scrollToNextItem()
        }
    }
    
    @IBAction func btnGetStartedClick(_ sender: UIButton) {
        gotoRootVC()
    }
    
    private func gotoRootVC(){
        
        defaults.set(true, forKey: isOnBoradingScreenDisplayed)
        defaults.synchronize()
        
        //:- Go to Login Page
        
        let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.window?.rootViewController = navController
        
//        appDelegate.drawerController.contentViewController = navController
//        appDelegate.drawerController.hideMenu(animated: true, completion:nil)
//        
//        let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
//        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        let navController = UINavigationController.init(rootViewController: controller)
//        appDelegate.drawerController.contentViewController = navController
//        appDelegate.drawerController.menuViewController = leftMenuVC
//        appDelegate.window?.rootViewController = appDelegate.drawerController
    }
}

//MARK: - UICOLLECTIONVIEW DATASOURCE & DELEGATE METHOD -

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOnboarding.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! BoardingCell
        
        let objData = self.arrOnboarding[indexPath.row]
        
        cell.imgBackground.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgBackground.sd_setImage(with: URL(string: objData.appImage), placeholderImage: UIImage(named: "noImage"))
        
//        cell.lblTitle.text = objData.title
        cell.lblTitle.attributedText =  objData.appDescription.htmlToAttributedString
//        cell.lblDescription.text = objData.appDescription
//        cell.lblDescription.attributedText = objData.appDescription
        cell.lblDescription.attributedText =  objData.appContent.htmlToAttributedString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

//MARK: - UISCROLLVIEW DELEGATE -

extension OnboardingVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width

        self.pageControl.setPage(Int(round(offSet / width)))
        self.pageControl.setPageOffset(offSet / width)

        currentPage = Int(round(offSet / width))
        
        if currentPage == self.arrOnboarding.count - 1 {
            self.btnSkip.isHidden = true
            self.btnNext.isHidden = true
            self.btnGetStarted.isHidden = false
        } else {
            self.btnSkip.isHidden = false
            self.btnNext.isHidden = false
            self.btnGetStarted.isHidden = true
        }
    }
}


extension String{
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
