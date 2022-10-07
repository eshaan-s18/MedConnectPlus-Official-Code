//
//  ReportResponseViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 10/1/22.
//

import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore


class ReportResponseViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var reportView: UIView!
    
    @IBOutlet weak var reportLabel: UILabel!
    
    @IBOutlet weak var reportResponseTextView: UITextView!
    
    @IBOutlet weak var placeholderText: UILabel!
    
    @IBOutlet weak var sendReportButton: UIBarButtonItem!
    
    var db = Firestore.firestore()
    var documentsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportResponseTextView.delegate = self
        
        print(reportedDiscussion)
        
        if reportedDiscussionReply != "Nil" {
            reportLabel.text = reportedDiscussionReply

        }
        
        else if reportedDiscussion != "Nil" {
            reportLabel.text = reportedDiscussion

        }
        
        else {
            reportLabel.text = reportedPost

        }
        
        reportView.layer.cornerRadius = 10
        
        allowPost()

        // Do any additional setup after loading the view.
    }
    @objc private func allowPost() {
        if reportResponseTextView.text!.count >= 1 {
            sendReportButton.isEnabled = true
            placeholderText.isHidden = true
        }
        else {
            placeholderText.isHidden = false
            sendReportButton.isEnabled = false
        }
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
        
        if placeholderText.isHidden == true {
            placeholderText.isHidden = false
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
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
    
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let date = Date()
        
        db.collection("REPORTED DISCUSSIONS").getDocuments()
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
                print("Hello this is document count")
                print(documentsCount)
                
                db.collection("REPORTED DISCUSSIONS").document("\(documentsCount)").setData(["condition": conditionSelected, "post": reportedPost, "discussion": selectedDiscussion, "reportedComment": reportedDiscussion, "reportedCommentReply": reportedDiscussionReply])
                
                
                
//                let alert = Service.createAlertController(title: "Response Posted‼️✅", message: "Please Refresh Page")
//                self.present(alert, animated: true, completion: nil)
                
                let alert = UIAlertController(title: "Report Sent🚩", message: "Successfully reported post. Please give our team a couple days to review your report.", preferredStyle: .alert)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
