//
//  SelectAgeViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 5/31/22.
//

import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

class SelectAgeViewController: UIViewController {

    @IBOutlet weak var selectBirthdayButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var nextButton: UIButton!
        
    @IBOutlet weak var errorMessage: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.addTarget(self, action: #selector(datePickerValueChange(sender:)), for: UIControl.Event.valueChanged)
        
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        datePicker.maximumDate = maxDate
        
        selectBirthdayButton.layer.borderColor = UIColor.systemGray6.cgColor
        selectBirthdayButton.layer.cornerRadius = 5
        selectBirthdayButton.layer.borderWidth = 1
        
        nextButton.layer.cornerRadius = 10
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidePicker)))
        
        
    }
    
    @objc private func errorVibration() {
        HapticsManager.shared.vibrate(for: .error)
    }
    
    
    
    @objc private func hidePicker() {
        if datePicker.isHidden == false {
            datePicker.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.nextButton.frame.origin.y += 265
                self.errorMessage.frame.origin.y += 267
            }
        
        }
        else {
            print("no")
        }
        
        }

    
    
    
    @objc func datePickerValueChange(sender: UIDatePicker) {
        selectBirthdayButton.setTitle("\(formatDate(date: datePicker.date))", for: .normal)
    }
    
    @IBAction func nextButtonSelected(_ sender: Any) {
        if selectBirthdayButton.titleLabel?.text == "Select Birthday" {
            errorMessage.isHidden = false
            errorVibration()
            errorMessage.text = "Please select your birthday."
        }
        else if datePicker.date > Date() {
            errorMessage.isHidden = false
            errorVibration()
            errorMessage.text = "Please select a valid birthday."
        }
        else {
            
//            print(calcAge(birthday: (selectBirthdayButton.titleLabel?.text)!))
            db.collection("Users").document(userID).updateData(["birthday" : selectBirthdayButton.titleLabel?.text])
            errorMessage.isHidden = true
            performSegue(withIdentifier: "fromBirthdaySegue", sender: self)
        }
        
    }
    
//    func calcAge(birthday: String) -> Int {
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "MMMM d, yyyy"
//        let birthdayDate = dateFormater.date(from: birthday)
//        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
//        let now = Date()
//        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
//        let age = calcAge.year
//        return age!
//    }
//
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }

    
    @IBAction func selectedBirthdaySelected(_ sender: Any) {
        if datePicker.isHidden {
            UIView.animate(withDuration: 0.3) {
                self.nextButton.frame.origin.y -= 265
                self.errorMessage.frame.origin.y -= 267

            }
            animate(toggle: true)
            
            
            
        } else {
            
            animate(toggle: false)
            UIView.animate(withDuration: 0.3) {
                self.nextButton.frame.origin.y += 265
                self.errorMessage.frame.origin.y += 267
            }
            
            
            
        }
    }
    
    
    func animate(toggle: Bool) {
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.datePicker.isHidden = false
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.datePicker.isHidden = true
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


