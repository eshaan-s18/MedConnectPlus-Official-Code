//
//  ReportABugViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 10/12/22.
//

import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

class ReportABugViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var sendReportButton: UIBarButtonItem!
    
    @IBOutlet weak var placeholderText: UILabel!
    
    @IBOutlet weak var reportTextView: UITextView!
    
    var db = Firestore.firestore()
    var documentsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        reportTextView.delegate = self
        
        
    }
    
    func allowPost() {
        if reportTextView.text!.count >= 1 {
            sendReportButton.isEnabled = true
            placeholderText.isHidden = true
        }
        else {
            sendReportButton.isEnabled = false
            placeholderText.isHidden = false
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
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
    
    @IBAction func sendReportButtonTapped(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let date = Date()
        
        db.collection("REPORTED BUGS").getDocuments()
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
                
                var delimeter = "-"
                var commentTitle = reportedDiscussion
                var newCommentTitle = commentTitle.components(separatedBy: delimeter)
                print(newCommentTitle[0])
                
                db.collection("REPORTED BUGS").document("\(documentsCount)").setData(["bugReportDescription" : reportTextView.text])
                
                
                
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
