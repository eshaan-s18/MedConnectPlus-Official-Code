//
//  AddDiscussionCommentViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 7/10/22.
//

import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

// MARK: - Add Discussion Response Page
class AddDiscussionCommentViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var discussionView: UIView!
    
    @IBOutlet weak var discussionLabel: UILabel!
    
    @IBOutlet weak var responseTextView: UITextView!
    @IBOutlet weak var placeholderText: UILabel!
    
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    var db = Firestore.firestore()
    var documentsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        responseTextView.delegate = self
        
        discussionLabel.text = selectedDiscussion
        
        discussionView.layer.cornerRadius = 10
        
        allowPost()
        
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc private func allowPost() {
        if responseTextView.text!.count >= 1 {
            postButton.isEnabled = true
            placeholderText.isHidden = true
        }
        else {
            placeholderText.isHidden = false
            postButton.isEnabled = false
        }
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
        
        if placeholderText.isHidden == true {
            placeholderText.isHidden = false
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
        }
    
    }
    
    func textViewDidChange(_ textView: UITextView) {
        allowPost()

    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        placeholderText.isHidden = true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderText.isHidden = true
    }
    
    
    @IBAction func postTapped(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let date = Date()
        
        
        db.collection(conditionSelected).document(discussionDocument).collection("comments").getDocuments()
        { [self]
            (querySnapshot, err) in

            if let err = err
            {
                print("Error getting documents: \(err)");
                let alert = UIAlertController(title: "Error⚠️❌", message: "Please Connect to WiFi or Restart App", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                        case .default:
                        print("default")
                        self.dismiss(animated: true)

                        
                        case .cancel:
                        print("cancel")
                        
                        case .destructive:
                        print("destructive")
                        
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                self.documentsCount = (querySnapshot?.documents.count)!
                db.collection(conditionSelected).document(discussionDocument).collection("comments").document("\(documentsCount)").setData(["commentTitle" : (responseTextView.text! + "- " + "\(documentsCount)"), "upvotes": 0, "downvotes": 0, "date": dateFormatter.string(from: date), "user": Auth.auth().currentUser!.uid, "gender": ["Male", "Female", "Other"], "genderUpvotes": [0,0,0], "race": ["White", "Black or African American", "American Indian or Alaska Native", "Asian", "Native Hawaiian or Other Pacific Islander"], "raceUpvotes": [0,0,0,0,0], "age": ["0-10","10-20", "20-30", "30-40", "40-50", "50-60", "60-70", "70-80", "80+"], "ageUpvotes": [0,0,0,0,0,0,0,0,0], "country": [""], "countryUpvotes": [0]])
                
                db.collection(conditionSelected).document(discussionDocument).collection("comments").document("\(documentsCount)").collection("replies").document("0").setData(["commentTitle" : "", "repliesTitle" : "", "repliesDate": "", "repliesDownvotes": 0, "repliesUpvotes": 0, "repliesUser": "", "gender": ["Male", "Female", "Other"], "genderUpvotes": [0,0,0], "race": ["White", "Black or African American", "American Indian or Alaska Native", "Asian", "Native Hawaiian or Other Pacific Islander"], "raceUpvotes": [0,0,0,0,0], "age": ["0-10","10-20", "20-30", "30-40", "40-50", "50-60", "60-70", "70-80", "80+"], "ageUpvotes": [0,0,0,0,0,0,0,0,0], "country": [""], "countryUpvotes": [0]])
                
                
                
                
                
                let docRefFour = db.collection("Users").document(sharedDiscussionUser)

                docRefFour.getDocument { (document, error) in

                    let result = Result {
                      try document?.data(as: DeviceTokenReference.self)

                    }
                    print(result)
                    switch result {
                    case .success(let deviceToken):
                        if let deviceToken = deviceToken {
                            
                            let sender = PushNotificationSender()
                            sender.sendPushNotification(to: deviceToken.deviceToken!, title: "MedConnect+", body: "💬 Someone responded to your discussion: \(selectedDiscussion)")
                            
                            self.db.collection("Users").document(sharedDiscussionUser).collection("notifications").getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        let totalDocCount = querySnapshot!.documents.count
                                        
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                                        let date = Date()
                                        
                                        
                                        
                                        self.db.collection("Users").document(sharedDiscussionUser).collection("notifications").document("\(totalDocCount)").setData(["notificationTitle": "💬 New Response", "notificationBody": "Someone responded to your discussion: \(selectedDiscussion)", "notificationCondition": conditionSelected, "notificationDiscussion": selectedDiscussion, "notificationDate": dateFormatter.string(from: date)])
                                    }
                            }
                            
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding question: \(error)")
                        }
                    }
                
                let alert = UIAlertController(title: "Response Posted‼️✅", message: "Please Refresh Page", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                        case .default:
                        print("default")
                        self.dismiss(animated: true)

                        
                        case .cancel:
                        print("cancel")
                        
                        case .destructive:
                        print("destructive")
                        
                    }
                }))
                self.present(alert, animated: true, completion: nil)

            }
        }
        
        
        
        
        
        }


}

