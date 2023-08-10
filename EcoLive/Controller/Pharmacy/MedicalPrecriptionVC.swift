//
//  MedicalPrecriptionVC.swift
//  LancerT
//
//  Created by Admin on 07/11/22.
//

import UIKit
import DropDown

class MedicalPrecriptionVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var callImg: UIImageView!
    @IBOutlet weak var chatImg: UIImageView!
    
    @IBOutlet weak var strenghtView1: UIView!
    @IBOutlet weak var strenghtView2: UIView!
    @IBOutlet weak var strenghtView3: UIView!
    @IBOutlet weak var strenghtLbl1: UILabel!
    @IBOutlet weak var strenghtLbl2: UILabel!
    @IBOutlet weak var strenghtLbl3: UILabel!
    
    @IBOutlet weak var dateView1: UIView!
    @IBOutlet weak var dateView2: UIView!
    @IBOutlet weak var dateView3: UIView!
    @IBOutlet weak var dateLbl1: UILabel!
    @IBOutlet weak var dateLbl2: UILabel!
    @IBOutlet weak var dateLbl3: UILabel!
    
    @IBOutlet weak var routeView1: UIView!
    @IBOutlet weak var routeView2: UIView!
    @IBOutlet weak var routeView3: UIView!
    @IBOutlet weak var routeLbl1: UILabel!
    @IBOutlet weak var routeLbl2: UILabel!
    @IBOutlet weak var routeLbl3: UILabel!
    
    @IBOutlet weak var frequencyView1: UIView!
    @IBOutlet weak var frequencyView2: UIView!
    @IBOutlet weak var frequencyView3: UIView!
    @IBOutlet weak var frequencyView4: UIView!
    @IBOutlet weak var frequencyView5: UIView!
    @IBOutlet weak var frequencyView6: UIView!
    @IBOutlet weak var frequencyView7: UIView!
    @IBOutlet weak var frequencyView8: UIView!
    @IBOutlet weak var frequencyLbl1: UILabel!
    @IBOutlet weak var frequencyLbl2: UILabel!
    @IBOutlet weak var frequencyLbl3: UILabel!
    @IBOutlet weak var frequencyLbl4: UILabel!
    @IBOutlet weak var frequencyLbl5: UILabel!
    @IBOutlet weak var frequencyLbl6: UILabel!
    @IBOutlet weak var frequencyLbl7: UILabel!
    @IBOutlet weak var frequencyLbl8: UILabel!
    
    @IBOutlet weak var rafilsView1: UIView!
    @IBOutlet weak var rafilsView2: UIView!
    @IBOutlet weak var rafilsView3: UIView!
    @IBOutlet weak var rafilsView4: UIView!
    @IBOutlet weak var rafilsLbl1: UILabel!
    @IBOutlet weak var rafilsLbl2: UILabel!
    @IBOutlet weak var rafilsLbl3: UILabel!
    @IBOutlet weak var rafilsLbl4: UILabel!
    
    @IBOutlet weak var quantifyView1: UIView!
    @IBOutlet weak var quantifyView2: UIView!
    @IBOutlet weak var quantifyView3: UIView!
    @IBOutlet weak var quantifyView4: UIView!
    @IBOutlet weak var quantifyLbl1: UILabel!
    @IBOutlet weak var quantifyLbl2: UILabel!
    @IBOutlet weak var quantifyLbl3: UILabel!
    @IBOutlet weak var quantifyLbl4: UILabel!
    
    @IBOutlet weak var dropDownLbl1: UILabel!
    @IBOutlet weak var dropDownLbl2: UILabel!
    @IBOutlet weak var dropDownLbl3: UILabel!
    
    var strenghtViews = [UIView]()
    var dateViews = [UIView]()
    let dropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        setupUI()
    }
    
    func setupUI(){
        
        strenghtViews = [strenghtView1,strenghtView2,strenghtView3]
//        dateViews = [dateView1,dateView2,dateView3]
        profileImg.layer.cornerRadius = profileImg.bounds.height/2
        callImg.layer.cornerRadius = callImg.bounds.height/2
        chatImg.layer.cornerRadius = chatImg.bounds.height/2
    }
    
    func highlightText(selectView: UIView,selectLbl: UILabel,deselectView: [UIView],deSelectLbl: [UILabel]){
        selectView.backgroundColor = hexColor("007AFF")
        selectView.layer.borderWidth = 0
        selectLbl.textColor = UIColor.white
        for i in 0..<deselectView.count {
            print("itni bar....",i )
            deselectView[i].layer.borderWidth = 1
            deselectView[i].backgroundColor = UIColor.white
            deSelectLbl[i].textColor = UIColor.black
        }
    }
    
    @IBAction func selectButton(_ sender: UIButton){
        switch (sender.tag){
        case 1:
            print("call")
        case 2:
            print("chat")
        case 3:
            print("view user contact info")
        case 4:
            highlightText(selectView: strenghtView1,selectLbl: strenghtLbl1, deselectView: [strenghtView2,strenghtView3],deSelectLbl: [strenghtLbl2,strenghtLbl3])
        case 5:
            highlightText(selectView: strenghtView2,selectLbl: strenghtLbl2, deselectView: [strenghtView1,strenghtView3],deSelectLbl: [strenghtLbl1,strenghtLbl3])
        case 6:
            highlightText(selectView: strenghtView3,selectLbl: strenghtLbl3, deselectView: [strenghtView1,strenghtView2],deSelectLbl: [strenghtLbl1,strenghtLbl2])
        case 7:
            highlightText(selectView: dateView1,selectLbl: dateLbl1, deselectView: [dateView2,dateView3],deSelectLbl: [dateLbl2,dateLbl3])
        case 8:
            highlightText(selectView: dateView2,selectLbl: dateLbl2, deselectView: [dateView1,dateView3],deSelectLbl: [dateLbl1,dateLbl3])
        case 9:
            highlightText(selectView: dateView3,selectLbl: dateLbl3, deselectView: [dateView1,dateView2],deSelectLbl: [dateLbl1,dateLbl2])
        case 10:
            highlightText(selectView: routeView1,selectLbl: routeLbl1, deselectView: [routeView2,routeView3],deSelectLbl: [routeLbl2,routeLbl3])
        case 11:
            highlightText(selectView: routeView2,selectLbl: routeLbl2, deselectView: [routeView1,routeView3],deSelectLbl: [routeLbl1,routeLbl3])
        case 12:
            highlightText(selectView: routeView3,selectLbl: routeLbl3, deselectView: [routeView1,routeView2],deSelectLbl: [routeLbl1,routeLbl2])
        case 13:
            print("Others")
        case 14:
            dropDown.dataSource = ["Left","Right"]
               dropDown.anchorView = sender //5
               dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
            dropDown.width = 60
               dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                guard let _ = self else { return }
                self?.dropDownLbl1.text = item
            }
        case 15:
            dropDown.dataSource = ["Left","Right"]
               dropDown.anchorView = sender //5
               dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
            dropDown.width = 60
               dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                guard let _ = self else { return }
                self?.dropDownLbl2.text = item
            }
        case 16:
            dropDown.dataSource = ["Left","Right"]
               dropDown.anchorView = sender //5
               dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
            dropDown.width = 60
               dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                guard let _ = self else { return }
                self?.dropDownLbl3.text = item
            }
        case 17:
            print("Others")
        case 18:
            highlightText(selectView: frequencyView1,selectLbl: frequencyLbl1, deselectView: [frequencyView2,frequencyView3,frequencyView4,frequencyView5,frequencyView6,frequencyView7,frequencyView8],deSelectLbl: [frequencyLbl2,frequencyLbl3,frequencyLbl4,frequencyLbl5,frequencyLbl6,frequencyLbl7,frequencyLbl8])
        case 19:
            highlightText(selectView: frequencyView2,selectLbl: frequencyLbl2, deselectView: [frequencyView1,frequencyView3,frequencyView4,frequencyView5,frequencyView6,frequencyView7,frequencyView8],deSelectLbl: [frequencyLbl1,frequencyLbl3,frequencyLbl4,frequencyLbl5,frequencyLbl6,frequencyLbl7,frequencyLbl8])
        case 20:
            highlightText(selectView: frequencyView3,selectLbl: frequencyLbl3, deselectView: [frequencyView1,frequencyView2,frequencyView4,frequencyView5,frequencyView6,frequencyView7,frequencyView8],deSelectLbl: [frequencyLbl1,frequencyLbl2,frequencyLbl4,frequencyLbl5,frequencyLbl6,frequencyLbl7,frequencyLbl8])
        case 21:
            highlightText(selectView: frequencyView4,selectLbl: frequencyLbl4, deselectView: [frequencyView1,frequencyView2,frequencyView3,frequencyView5,frequencyView6,frequencyView7,frequencyView8],deSelectLbl: [frequencyLbl1,frequencyLbl2,frequencyLbl3,frequencyLbl5,frequencyLbl6,frequencyLbl7,frequencyLbl8])
        case 22:
            highlightText(selectView: frequencyView5,selectLbl: frequencyLbl5, deselectView: [frequencyView1,frequencyView2,frequencyView3,frequencyView4,frequencyView6,frequencyView7,frequencyView8],deSelectLbl: [frequencyLbl1,frequencyLbl2,frequencyLbl3,frequencyLbl4,frequencyLbl6,frequencyLbl7,frequencyLbl8])
        case 23:
            highlightText(selectView: frequencyView6,selectLbl: frequencyLbl6, deselectView: [frequencyView1,frequencyView2,frequencyView3,frequencyView4,frequencyView5,frequencyView7,frequencyView8],deSelectLbl: [frequencyLbl1,frequencyLbl2,frequencyLbl3,frequencyLbl4,frequencyLbl5,frequencyLbl7,frequencyLbl8])
        case 24:
            highlightText(selectView: frequencyView7,selectLbl: frequencyLbl7, deselectView: [frequencyView1,frequencyView2,frequencyView3,frequencyView4,frequencyView5,frequencyView6,frequencyView8],deSelectLbl: [frequencyLbl1,frequencyLbl2,frequencyLbl3,frequencyLbl4,frequencyLbl5,frequencyLbl6,frequencyLbl8])
        case 25:
            highlightText(selectView: frequencyView8,selectLbl: frequencyLbl8, deselectView: [frequencyView1,frequencyView2,frequencyView3,frequencyView4,frequencyView5,frequencyView6,frequencyView7],deSelectLbl: [frequencyLbl1,frequencyLbl2,frequencyLbl3,frequencyLbl4,frequencyLbl5,frequencyLbl6,frequencyLbl7])
        case 26:
            print("Others")
        case 27:
            highlightText(selectView: rafilsView1,selectLbl: rafilsLbl1, deselectView: [rafilsView2,rafilsView3,rafilsView4],deSelectLbl: [rafilsLbl2,rafilsLbl3,rafilsLbl4])
        case 28:
            dropDown.dataSource = ["1","2","3","4","5","6","7","8","9","10"]
               dropDown.anchorView = sender //5
               dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
            dropDown.width = 60
               dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                guard let _ = self else { return }
                self?.rafilsLbl2.text = item
            }
//            highlightText(selectView: rafilsView2,selectLbl: rafilsLbl2, deselectView: [rafilsView1,rafilsView3,rafilsView4],deSelectLbl: [rafilsLbl1,rafilsLbl3,rafilsLbl4])
        case 29:
            dropDown.dataSource = ["1 year","2 year","3 year"]
               dropDown.anchorView = sender //5
               dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
            dropDown.width = 80
               dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                guard let _ = self else { return }
                self?.rafilsLbl3.text = item
            }
//            highlightText(selectView: rafilsView3,selectLbl: rafilsLbl3, deselectView: [rafilsView1,rafilsView2,rafilsView4],deSelectLbl: [rafilsLbl1,rafilsLbl2,rafilsLbl4])
        case 30:
            highlightText(selectView: rafilsView4,selectLbl: rafilsLbl4, deselectView: [rafilsView1,rafilsView2,rafilsView3],deSelectLbl: [rafilsLbl1,rafilsLbl2,rafilsLbl3])
        case 31:
            highlightText(selectView: quantifyView1,selectLbl: quantifyLbl1, deselectView: [quantifyView2,quantifyView3,quantifyView4],deSelectLbl: [quantifyLbl2,quantifyLbl3,quantifyLbl4])
        case 32:
            highlightText(selectView: quantifyView2,selectLbl: quantifyLbl2, deselectView: [quantifyView1,quantifyView3,quantifyView4],deSelectLbl: [quantifyLbl1,quantifyLbl3,quantifyLbl4])
        case 33:
            highlightText(selectView: quantifyView3,selectLbl: quantifyLbl3, deselectView: [quantifyView1,quantifyView2,quantifyView4],deSelectLbl: [quantifyLbl1,quantifyLbl2,quantifyLbl4])
        case 34:
            highlightText(selectView: quantifyView4,selectLbl: quantifyLbl4, deselectView: [quantifyView1,quantifyView2,quantifyView3],deSelectLbl: [quantifyLbl1,quantifyLbl2,quantifyLbl3])
        case 35:
            print("Others")
        case 36:
            print("add another location:- Button")
        case 37:
            print("Send precription directly to pharmacy:- Button")
        case 38:
            print("Send precription to patient:- Button")
        case 39:
            print("Save this precrition for letter:- Button")
        default:
            print("")
        }
    }
    func hexColor(_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if (cString.count) != 6 {
            return UIColor.gray
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

