//
//  ScheduleDateTVCell.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit

class ScheduleDateTVCell: UITableViewCell {
    
    @IBOutlet var mainView : UIView!
    @IBOutlet var mainViewTime : UIView!
    
    @IBOutlet var confirmbtn : UIButton!
    @IBOutlet var cancelbtn : UIButton!

    @IBOutlet var lblFromDate : UILabel!
    @IBOutlet var lblToDate : UILabel!

    @IBOutlet var lblFromTime : UILabel!
    @IBOutlet var lblToTime : UILabel!

    var vc : ScheduleRideVC!
    var selectButtonType = 0
    private var datePicker: UIDatePicker?


    
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.dropShadowToCollC()
        mainViewTime.dropShadowToCollC()
        
        confirmbtn.layer.cornerRadius = confirmbtn.frame.height/2
        cancelbtn.layer.cornerRadius = cancelbtn.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func btnAction(_ sender: UIButton) {

        datePicker?.removeFromSuperview()

        var tag = sender.tag
        selectButtonType = tag
        if self.vc.view.subviews.contains(where: { $0 is UIDatePicker }) {
            self.datePicker?.removeFromSuperview()
        } else {
            datePicker = nil
            setupDatePicker()
        }

    }
    
}

extension ScheduleDateTVCell {

    private func setupDatePicker() {
        let picker = datePicker ?? UIDatePicker()

        switch selectButtonType {
        case 1:
            picker.datePickerMode = .date
        case 2:
            picker.datePickerMode = .date
        case 3:
            picker.datePickerMode = .time
        case 4:
            picker.datePickerMode = .time
        default:
            break
        }

//        if #available(iOS 13.4, *) {
//            picker.preferredDatePickerStyle = .wheels
//        }

        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        let size = self.vc.view.frame.size
        picker.frame = CGRect(x: 0.0, y: size.height - 200, width: size.width, height: 200)
        picker.backgroundColor = UIColor.white
        self.datePicker = picker
        self.vc.view.addSubview(self.datePicker!)
    }

    @objc func dueDateChanged(sender:UIDatePicker){

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none

        switch selectButtonType {
        case 1:
            if let date = datePicker?.date {
                let format = date.getFormattedDate(format: "E, MMM d")
                lblFromDate.text = format
            }
        case 2:
            if let date = datePicker?.date {
                let format = date.getFormattedDate(format: "E, MMM d")
                lblToDate.text = format
            }
        case 3:
            if let date = datePicker?.date {
                let format = date.getFormattedDate(format: "HH:mm")
                lblToTime.text = format
            }
        case 4:
            if let date = datePicker?.date {
                let format = date.getFormattedDate(format: "HH:mm")
                lblFromTime.text = format
            }
        default:
            break
        }

        datePicker?.removeFromSuperview()

    }

}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
