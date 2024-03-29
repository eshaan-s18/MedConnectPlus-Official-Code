//
//  AddDiscussionViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/25/22.
//


import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

protocol AddDiscussionDelegate {
    func addDiscussion()
}

// MARK: - Add Discussion Page
class AddDiscussionViewController: UIViewController, UITextViewDelegate {
    
    var delegate: AddDiscussionDelegate?
    var db = Firestore.firestore()
    var documentsCount = 0
    
    @IBOutlet weak var discussionTextView: UITextView!
    
    @IBOutlet weak var placeholderText: UILabel!
    
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    override func viewWillDisappear(_ animated: Bool) {
        if let discussionVC = presentingViewController as? DiscussionNewViewController {
            DispatchQueue.main.async {
                discussionVC.discussionCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discussionTextView.delegate = self
        
        allowPost()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc private func allowPost() {
        if discussionTextView.text!.count >= 1 {
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
        
        
        db.collection(conditionSelected).getDocuments()
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
                db.collection(conditionSelected).document("\(documentsCount)").setData(["discussion" : discussionTextView.text, "views": "0", "date": dateFormatter.string(from: date), "comments": [""], "user": Auth.auth().currentUser!.uid])
                
                self.db.collection(conditionSelected).document("\(documentsCount)").collection("comments").document("0").setData(["commentTitle" : "", "date": "", "downvotes": 0, "upvotes": 0, "user": ""])
                delegate?.addDiscussion()
                
                
                db.collection("Users").document(Auth.auth().currentUser!.uid).collection("discussions").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let discussionsCreatedDocumentCount = querySnapshot!.documents.count
                        
                        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("discussions").document(String(discussionsCreatedDocumentCount)).setData(["yourDiscussionTitle": discussionTextView.text, "yourDiscussionDate": dateFormatter.string(from: date), "conditionSelected": conditionSelected])
                        
                    }
                }
                
                let alert = UIAlertController(title: "Success‼️✅", message: "Please Refresh Page", preferredStyle: .alert)
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
