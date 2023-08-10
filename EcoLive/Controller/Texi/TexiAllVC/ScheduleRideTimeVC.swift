//
//  ScheduleRideTimeVC.swift
//  DemoApp
//
//  Created by  on 14/11/22.
//

import UIKit

class ScheduleRideTimeVC: UIViewController {

    @IBOutlet weak var buttomView: UIStackView!
    @IBOutlet weak var btnSetPickup: UIButton!
    @IBOutlet var btnAllOutlet: [UIButton]!
    var selectButtonType = 0
    private var datePicker: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()

        buttomView.clipsToBounds = true
        buttomView.layer.cornerRadius = 30
        buttomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        btnSetPickup.clipsToBounds = true
        btnSetPickup.layer.cornerRadius = 20

    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func btnAllAction(_ sender: UIButton) {

        selectButtonType = sender.tag
        setupDatePicker()
    }


}
extension ScheduleRideTimeVC {

    private func setupDatePicker() {

        datePicker?.removeFromSuperview()

        let picker = datePicker ?? UIDatePicker()

        switch selectButtonType {
        case 1:
            picker.datePickerMode = .date
        case 2:
            picker.datePickerMode = .time
        case 3:
            picker.datePickerMode = .time
        case 4:
            self.dismiss(animated: true)
            break
        default:
            break
        }

        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        let size = self.view.frame.size
        picker.frame = CGRect(x: 0.0, y: size.height - 200, width: size.width, height: 200)
        picker.backgroundColor = UIColor.white
        self.datePicker = picker
        self.view.addSubview(self.datePicker!)
    }

    @objc func dueDateChanged(sender:UIDatePicker){

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none

        switch selectButtonType {
        case 1:
            if let date = datePicker?.date {
                let format = date.getFormattedDate(format: "E, MMM d")
                btnAllOutlet[0].setTitle(format, for: .normal)
            }
        case 2:
            if let date = datePicker?.date {
                let format = date.getFormattedDate(format: "hh:mm a")
                btnAllOutlet[1].setTitle(format, for: .normal)
            }
        case 3:
            if let date = datePicker?.date {
                let format = date.getFormattedDate(format: "hh:mm a")
                btnAllOutlet[2].setTitle(format, for: .normal)
            }
        default:
            break
        }

        datePicker?.removeFromSuperview()

    }

}

