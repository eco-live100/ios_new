//
//  ViewController.swift
//  Screen
//
//  Created by sunil biloniya on 23/10/22.
//

import UIKit

class PayResturentAndBusiness: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func didTapPay(_ sender: Any) {
        print("ACTION")
    }
    
    @IBAction func didTapSplit(_ sender: Any) {
        print("ACTION")

    }
    @IBAction func didTapSplitPlus(_ sender: Any) {
        print("ACTION")

    }
    @IBAction func didTapSplitMinus(_ sender: Any) {
        print("ACTION")

    }
    @IBAction func didTapTipPlus(_ sender: Any) {
        print("ACTION")

    }
    @IBAction func didTapTipMinus(_ sender: Any) {
        print("ACTION")

    }
    @IBAction func didTapTipConfirm(_ sender: Any) {
        print("ACTION")

    }
    @IBAction func didTapTipCancel(_ sender: Any) {
        self.dismiss(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

