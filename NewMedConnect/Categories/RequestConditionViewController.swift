//
//  RequestConditionViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 10/16/22.
//

import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

// MARK: - Request Condition Page
class RequestConditionViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var sendReportButton: UIBarButtonItem!
    
    @IBOutlet weak var requestTextView: UITextView!
    
    @IBOutlet weak var placeHolderText: UILabel!
    
    var db = Firestore.firestore()
    var documentsCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        requestTextView.delegate = self
    
    }
    
    func allowPost() {
        if requestTextView.text!.count >= 1 {
            sendReportButton.isEnabled = true
            placeHolderText.isHidden = true
        }
        else {
            sendReportButton.isEnabled = false
            placeHolderText.isHidden = false
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func sendReportButtonTapped(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let date = Date()
        
        db.collection("REQUEST CONDITION").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
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
                
                
            } else {
                self.documentsCount = (querySnapshot?.documents.count)!
                
                self.db.collection("REQUEST CONDITION").document("\(self.documentsCount)").setData(["conditionRequest" : self.requestTextView.text])
                
                let alert = UIAlertController(title: "Request Sent💡", message: "Successfully sent request. Please give our team a couple days to review your request.", preferredStyle: .alert)
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
    
    func textViewDidChange(_ textView: UITextView) {
        allowPost()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        placeHolderText.isHidden = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderText.isHidden = true
    }
    

}
