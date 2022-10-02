//
//  SelectPersonalViewController.swift
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

class SelectPersonalViewController: UIViewController {

    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var borderViewTwo: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    
    @IBOutlet weak var whiteRaceButton: UIButton!
    
    @IBOutlet weak var blackRaceButton: UIButton!
    
    @IBOutlet weak var americanIndianRaceButton: UIButton!
    
    @IBOutlet weak var asianRaceButton: UIButton!
    
    
    @IBOutlet weak var whiteRaceCircle: UIImageView!
    
    @IBOutlet weak var blackRaceCircle: UIImageView!
    
    @IBOutlet weak var americanIndianRaceCircle: UIImageView!
    
    @IBOutlet weak var asianRaceCircle: UIImageView!
    
    @IBOutlet weak var nativeHawaiianCircle: UIImageView!
    
    @IBOutlet weak var nativeHawaiianButton: UIButton!
    
    
    @IBOutlet weak var femaleCircle: UIImageView!
    
    @IBOutlet weak var otherCircle: UIImageView!
    
    @IBOutlet weak var maleCircle: UIImageView!
    
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var otherButton: UIButton!
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        borderView.backgroundColor = UIColor.systemGray6
        borderView.layer.borderColor = UIColor.systemGray6.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 10
        
        borderViewTwo.backgroundColor = UIColor.systemGray6
        borderViewTwo.layer.borderColor = UIColor.systemGray6.cgColor
        borderViewTwo.layer.borderWidth = 1
        borderViewTwo.layer.cornerRadius = 10
        
        nextButton.layer.cornerRadius = 10
        

    }
    
    @objc private func errorVibration() {
        HapticsManager.shared.vibrate(for: .error)
    }
    
    
    @IBAction func whiteRaceSelected(_ sender: Any) {
        if whiteRaceCircle.image == UIImage(systemName: "circle"){
            whiteRaceCircle.image = UIImage(systemName: "checkmark.circle.fill")
            whiteRaceCircle.tintColor = UIColor.systemBlue
            
            blackRaceCircle.image = UIImage(systemName: "circle")
            blackRaceCircle.tintColor = UIColor.darkGray
            americanIndianRaceCircle.image = UIImage(systemName: "circle")
            americanIndianRaceCircle.tintColor = UIColor.darkGray
            asianRaceCircle.image = UIImage(systemName: "circle")
            asianRaceCircle.tintColor = UIColor.darkGray
            nativeHawaiianCircle.image = UIImage(systemName: "circle")
            nativeHawaiianCircle.tintColor = UIColor.darkGray
        }
        else {
            whiteRaceCircle.image = UIImage(systemName: "circle")
            whiteRaceCircle.tintColor = UIColor.darkGray
        }
    }
    
    @IBAction func blackRaceSelected(_ sender: Any) {
        if blackRaceCircle.image == UIImage(systemName: "circle"){
            blackRaceCircle.image = UIImage(systemName: "checkmark.circle.fill")
            blackRaceCircle.tintColor = UIColor.systemBlue
            
            whiteRaceCircle.image = UIImage(systemName: "circle")
            whiteRaceCircle.tintColor = UIColor.darkGray
            americanIndianRaceCircle.image = UIImage(systemName: "circle")
            americanIndianRaceCircle.tintColor = UIColor.darkGray
            asianRaceCircle.image = UIImage(systemName: "circle")
            asianRaceCircle.tintColor = UIColor.darkGray
            nativeHawaiianCircle.image = UIImage(systemName: "circle")
            nativeHawaiianCircle.tintColor = UIColor.darkGray
            
        }
        else {
            blackRaceCircle.image = UIImage(systemName: "circle")
            blackRaceCircle.tintColor = UIColor.darkGray
        }
    }
    
    @IBAction func americanIndianRaceSelected(_ sender: Any) {
        if americanIndianRaceCircle.image == UIImage(systemName: "circle"){
            americanIndianRaceCircle.image = UIImage(systemName: "checkmark.circle.fill")
            americanIndianRaceCircle.tintColor = UIColor.systemBlue
            
            blackRaceCircle.image = UIImage(systemName: "circle")
            blackRaceCircle.tintColor = UIColor.darkGray
            whiteRaceCircle.image = UIImage(systemName: "circle")
            whiteRaceCircle.tintColor = UIColor.darkGray
            asianRaceCircle.image = UIImage(systemName: "circle")
            asianRaceCircle.tintColor = UIColor.darkGray
            nativeHawaiianCircle.image = UIImage(systemName: "circle")
            nativeHawaiianCircle.tintColor = UIColor.darkGray
        }
        else {
            americanIndianRaceCircle.image = UIImage(systemName: "circle")
            americanIndianRaceCircle.tintColor = UIColor.darkGray
        }
    }
    
    @IBAction func asianRaceSelected(_ sender: Any) {
        if asianRaceCircle.image == UIImage(systemName: "circle"){
            asianRaceCircle.image = UIImage(systemName: "checkmark.circle.fill")
            asianRaceCircle.tintColor = UIColor.systemBlue
            
            blackRaceCircle.image = UIImage(systemName: "circle")
            blackRaceCircle.tintColor = UIColor.darkGray
            americanIndianRaceCircle.image = UIImage(systemName: "circle")
            americanIndianRaceCircle.tintColor = UIColor.darkGray
            whiteRaceCircle.image = UIImage(systemName: "circle")
            whiteRaceCircle.tintColor = UIColor.darkGray
            nativeHawaiianCircle.image = UIImage(systemName: "circle")
            nativeHawaiianCircle.tintColor = UIColor.darkGray
        }
        else {
            asianRaceCircle.image = UIImage(systemName: "circle")
            asianRaceCircle.tintColor = UIColor.darkGray
        }
    }
    
    @IBAction func nativeHawaiianRaceSelected(_ sender: Any) {
        if nativeHawaiianCircle.image == UIImage(systemName: "circle"){
            nativeHawaiianCircle.image = UIImage(systemName: "checkmark.circle.fill")
            nativeHawaiianCircle.tintColor = UIColor.systemBlue
            
            blackRaceCircle.image = UIImage(systemName: "circle")
            blackRaceCircle.tintColor = UIColor.darkGray
            americanIndianRaceCircle.image = UIImage(systemName: "circle")
            americanIndianRaceCircle.tintColor = UIColor.darkGray
            asianRaceCircle.image = UIImage(systemName: "circle")
            asianRaceCircle.tintColor = UIColor.darkGray
            whiteRaceCircle.image = UIImage(systemName: "circle")
            whiteRaceCircle.tintColor = UIColor.darkGray
        }
        else {
            nativeHawaiianCircle.image = UIImage(systemName: "circle")
            nativeHawaiianCircle.tintColor = UIColor.darkGray
        }
    
    }
    
    @IBAction func femaleSelected(_ sender: Any) {
        if femaleCircle.image == UIImage(systemName: "circle"){
            femaleCircle.image = UIImage(systemName: "checkmark.circle.fill")
            femaleCircle.tintColor = UIColor.systemBlue
            
            maleCircle.image = UIImage(systemName: "circle")
            maleCircle.tintColor = UIColor.darkGray
            otherCircle.image = UIImage(systemName: "circle")
            otherCircle.tintColor = UIColor.darkGray
        }
        else {
            femaleCircle.image = UIImage(systemName: "circle")
            femaleCircle.tintColor = UIColor.darkGray
        }
    }
    
    @IBAction func maleSelected(_ sender: Any) {
        if maleCircle.image == UIImage(systemName: "circle"){
            maleCircle.image = UIImage(systemName: "checkmark.circle.fill")
            maleCircle.tintColor = UIColor.systemBlue
            
            femaleCircle.image = UIImage(systemName: "circle")
            femaleCircle.tintColor = UIColor.darkGray
            otherCircle.image = UIImage(systemName: "circle")
            otherCircle.tintColor = UIColor.darkGray
        }
        else {
            maleCircle.image = UIImage(systemName: "circle")
            maleCircle.tintColor = UIColor.darkGray
        }
    }
    
    @IBAction func otherSelected(_ sender: Any) {
        if otherCircle.image == UIImage(systemName: "circle"){
            otherCircle.image = UIImage(systemName: "checkmark.circle.fill")
            otherCircle.tintColor = UIColor.systemBlue
            
            femaleCircle.image = UIImage(systemName: "circle")
            femaleCircle.tintColor = UIColor.darkGray
            maleCircle.image = UIImage(systemName: "circle")
            maleCircle.tintColor = UIColor.darkGray
        }
        else {
            otherCircle.image = UIImage(systemName: "circle")
            otherCircle.tintColor = UIColor.darkGray
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if ((whiteRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") || blackRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") || americanIndianRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") || asianRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") || nativeHawaiianCircle.image == UIImage(systemName: "checkmark.circle.fill")) && (femaleCircle.image == UIImage(systemName: "checkmark.circle.fill") || maleCircle.image == UIImage(systemName: "checkmark.circle.fill") || otherCircle.image == UIImage(systemName: "checkmark.circle.fill"))) {
            var selectedRace = ""
            var selectedGender = ""
            if whiteRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") {
                selectedRace = whiteRaceButton.titleLabel!.text!
            }
            else if blackRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") {
                selectedRace = blackRaceButton.titleLabel!.text!
            }
            else if asianRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") {
                selectedRace = asianRaceButton.titleLabel!.text!
            }
            else if nativeHawaiianCircle.image == UIImage(systemName: "checkmark.circle.fill") {
                selectedRace = nativeHawaiianButton.titleLabel!.text!
            }
            else if americanIndianRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") {
                selectedRace = americanIndianRaceButton.titleLabel!.text!
            }
            
            db.collection("Users").document(userID).updateData(["race" : selectedRace])
            
            if femaleCircle.image == UIImage(systemName: "checkmark.circle.fill") {
                selectedGender = femaleButton.titleLabel!.text!
            }
            else if maleCircle.image == UIImage(systemName: "checkmark.circle.fill") {
                selectedGender = maleButton.titleLabel!.text!
            }
            else if otherCircle.image == UIImage(systemName: "checkmark.circle.fill") {
                selectedGender = otherButton.titleLabel!.text!
            }
            db.collection("Users").document(userID).updateData(["gender" : selectedGender])
            db.collection("Users").document(userID).updateData(["pinned" : [""]])
            db.collection("Users").document(userID).updateData(["saved" : [""]])
            db.collection("Users").document(userID).updateData(["upvotes" : [""]])
            db.collection("Users").document(userID).updateData(["downvotes" : [""]])
            
            
            errorMessage.isHidden = true
            print("Success")
        }
        else if ((whiteRaceCircle.image != UIImage(systemName: "checkmark.circle.fill") || blackRaceCircle.image != UIImage(systemName: "checkmark.circle.fill") || americanIndianRaceCircle.image != UIImage(systemName: "checkmark.circle.fill") || asianRaceCircle.image != UIImage(systemName: "checkmark.circle.fill") || nativeHawaiianCircle.image != UIImage(systemName: "checkmark.circle.fill")) && (femaleCircle.image == UIImage(systemName: "checkmark.circle.fill") || maleCircle.image == UIImage(systemName: "checkmark.circle.fill") || otherCircle.image == UIImage(systemName: "checkmark.circle.fill"))) {
            
            errorMessage.isHidden = false
            errorMessage.text = "Please select your race."
            errorVibration()
        }
        else if ((whiteRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") || blackRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") || americanIndianRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") || asianRaceCircle.image == UIImage(systemName: "checkmark.circle.fill") || nativeHawaiianCircle.image == UIImage(systemName: "checkmark.circle.fill")) && (femaleCircle.image != UIImage(systemName: "checkmark.circle.fill") || maleCircle.image != UIImage(systemName: "checkmark.circle.fill") || otherCircle.image != UIImage(systemName: "checkmark.circle.fill"))) {
            
            errorMessage.isHidden = false
            errorMessage.text = "Please select your gender."
            errorVibration()
        }
        
        
        else {
            errorMessage.isHidden = false
            errorMessage.text = "Please select your race and your gender."
            errorVibration()
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
