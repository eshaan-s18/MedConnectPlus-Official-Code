//
//  DiscussionCommentsCollectionViewCell.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 7/8/22.
//

import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

var replyTextFieldVal2 = ""

// MARK: - Discussion Responses CollectionView Cell
class DiscussionCommentsCollectionViewCell: UICollectionViewCell, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
        
    var db = Firestore.firestore()

    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var upHeartLabel: UILabel!
    
    @IBOutlet weak var downHeartLabel: UILabel!
    
    @IBOutlet weak var upHeartButton: UIButton!
    
    @IBOutlet weak var downHeartButton: UIButton!
    
    @IBOutlet weak var upHeartImage: UIImageView!
    
    @IBOutlet weak var downHeartImage: UIImageView!
    
    @IBOutlet weak var upHeartView: UIView!
    
    @IBOutlet weak var downHeartView: UIView!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var commentDateLabel: UILabel!
    
    @IBOutlet weak var corneredView: UIView!
    
    @IBOutlet weak var repliesButton: UIButton!
    
    @IBOutlet weak var cellUsername: UILabel!
    
    @IBOutlet weak var responseCommentsViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var responseCommentsView: UIView!
    
    @IBOutlet weak var responseCommentsCollectionView: UICollectionView!
    
    @IBOutlet weak var repliesButtonWidth: NSLayoutConstraint!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var pieChartButton: UIButton!
    
    @IBOutlet weak var postReplyView: UIView!
    
    @IBOutlet weak var replyTextField: UITextField!
    
    @IBOutlet weak var replyTextFieldHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var replyCancelSendButton: UIButton!
    
    @IBOutlet weak var postReplyViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deleteOrFlag: UIButton!
    
    @IBOutlet weak var postCommentReplyView: UIView!
    
    @IBOutlet weak var postCommentReplyLabel: UIView!
    
    @IBOutlet weak var postCommentReplyTextField: UITextField!
    
    @IBOutlet weak var postCommentReplyCancelorPost: UIButton!
    
    @IBOutlet weak var postCommentReplyViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postCommentReplyUpperConstraint: NSLayoutConstraint!
    
    var discussionCommentUserDownvote = [String]()
    var discussionCommentUserUpvote = [String]()
    
    var dateFormatter = DateFormatter()

    var discussions: DiscussionComment? {
        didSet {
            commentLabel.text = discussions?.discussionsCommentTitle
            responseCommentsCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        responseCommentsCollectionView.delegate = self
        responseCommentsCollectionView.dataSource = self
        
        replyTextField.delegate = self
        
        let docRefTwo = db.collection("Users").document(Auth.auth().currentUser!.uid)

        docRefTwo.getDocument { (document, error) in

            let result = Result {
              try document?.data(as: UpvoteReference.self)

            }
            print(result)
            switch result {
            case .success(let upvote):
                if let upvote = upvote {
                    let docRefThree = self.db.collection("Users").document(Auth.auth().currentUser!.uid)
                    docRefThree.getDocument { (document, error) in

                        let result = Result {
                          try document?.data(as: DownvoteReference.self)

                        }
                        print(result)
                        switch result {
                        case .success(let downvote):
                            if let downvote = downvote {
                                self.discussionCommentUserDownvote = downvote.downvotes!
                                self.discussionCommentUserUpvote = upvote.upvotes!
                                
                            } else {
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding question: \(error)")
                            }
                        }
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding question: \(error)")
                }
            }
        
    }
    
    @objc func getVoteData() {
        let docRefTwo = db.collection("Users").document(Auth.auth().currentUser!.uid)

        docRefTwo.getDocument { (document, error) in

            let result = Result {
              try document?.data(as: UpvoteReference.self)

            }
            print(result)
            switch result {
            case .success(let upvote):
                if let upvote = upvote {
                    let docRefThree = self.db.collection("Users").document(Auth.auth().currentUser!.uid)
                    docRefThree.getDocument { (document, error) in

                        let result = Result {
                          try document?.data(as: DownvoteReference.self)

                        }
                        print(result)
                        switch result {
                        case .success(let downvote):
                            if let downvote = downvote {
                                self.discussionCommentUserDownvote = downvote.downvotes!
                                self.discussionCommentUserUpvote = upvote.upvotes!
                                
                                discussionRepliesIndicator = self.responseCommentsCollectionView.tag - 1
                                
                                self.responseCommentsCollectionView.reloadData()
                                self.responseCommentsCollectionView.dataSource = self
                                self.responseCommentsCollectionView.delegate = self
                                
                            } else {
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding question: \(error)")
                            }
                        }
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding question: \(error)")
                }
            }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextFieldCount = textField.tag + 1
        
        textFieldIndicator = "comment"
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count > 0 {
            replyCancelSendButton.setTitle("Post", for: .normal)
        }
        else {
            replyCancelSendButton.setTitle("Cancel", for: .normal)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        replyTextFieldVal = textField.text!
    }


   
}


// MARK: - Discussion Response Replies CollectionView Setup
extension DiscussionCommentsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 320, height: 105)
    
        }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if discussionRepliesIndicator == sharedComments.count - 1 {
            discussionRepliesIndicator = -1
        }
        discussionRepliesIndicator += 1
        
        collectionView.tag = discussionRepliesIndicator
        
        if sharedComments.map({$0.commentReplies})[discussionRepliesIndicator].count > 0 {

            
            var sortedComments = [DiscussionComment]()
          
            sharedComments[discussionRepliesIndicator].commentReplies = sharedComments.map({$0.commentReplies})[discussionRepliesIndicator].sorted(by: {$0.discussionCommentReplyDate.compare($1.discussionCommentReplyDate) == .orderedDescending})
        
        
        
            return sharedComments.map({$0.commentReplies})[discussionRepliesIndicator].count

        }
        else {
            return 0
        }

    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "responseCommentsCollectionCell", for: indexPath) as? ResponseCommentsCollectionViewCell

       
        cell?.responseReplyLabel.text = sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle})[indexPath.row]
  
        
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"

        var displayedDate = sharedComments.map({$0.commentReplies})[collectionView.tag].map({dateFormatter.string(from: $0.discussionCommentReplyDate)})
        
                

        if sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle})[indexPath.row].prefix(1) == "@" {
            let recognizedUsertag = sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle})[indexPath.row].components(separatedBy: " ").first
            mutatedTitle = NSMutableAttributedString(string: sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle})[indexPath.row], attributes: [NSAttributedString.Key.font :UIFont(name: "Manrope", size: 14)])
            mutatedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length:  recognizedUsertag!.count))
            cell?.responseReplyLabel.attributedText = mutatedTitle

        }
        
        
        let check = sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionReplyCancelorPost})[indexPath.row]
        
        if check == "Post" {
            let replyTitle = cell?.postCommentReplyTextField.text
            var docCount2  = 0
            var originalDiscussionComment  = sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussCommentTitle})[indexPath.row]
            
            db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: originalDiscussionComment).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).collection("replies").getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                                
                                cell?.presentError()
                                
                                
                                
                                
                            } else {
                                
                                docCount2 = querySnapshot!.documents.count
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                                let date = Date()
                                
                                let replyTitle = cell?.postCommentReplyTextField.text
                                
                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).collection("replies").document("\(docCount2)").setData(["commentTitle" : originalDiscussionComment, "repliesTitle" : ("@User_" + sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionReplyUsername})[indexPath.row].prefix(12) + "... " + replyTextFieldVal2), "repliesDate": dateFormatter.string(from: date), "repliesDownvotes": 0, "repliesUpvotes": 0, "repliesUser": Auth.auth().currentUser!.uid, "gender": ["Male", "Female", "Other"], "genderUpvotes": [0,0,0], "race": ["White", "Black or African American", "American Indian or Alaska Native", "Asian", "Native Hawaiian or Other Pacific Islander"], "raceUpvotes": [0,0,0,0,0], "age": ["0-10","10-20", "20-30", "30-40", "40-50", "50-60", "60-70", "70-80", "80+"], "ageUpvotes": [0,0,0,0,0,0,0,0,0], "country": [""], "countryUpvotes": [0]])
                                
                                let docRefFour = self.db.collection("Users").document(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyUsername})[indexPath.row])

                                docRefFour.getDocument { (document, error) in

                                    let result = Result {
                                      try document?.data(as: DeviceTokenReference.self)

                                    }
                                    print(result)
                                    switch result {
                                    case .success(let deviceToken):
                                        if let deviceToken = deviceToken {

                                            let commentReply = cell?.responseReplyLabel.text
                                            let sender = PushNotificationSender()
                                            sender.sendPushNotification(to: deviceToken.deviceToken!, title: "MedConnect+", body: "💬 Someone replied to your response reply: \(commentReply!)")
                                            
                                            self.db.collection("Users").document(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyUsername})[indexPath.row]).collection("notifications").getDocuments() { (querySnapshot, err) in
                                                    if let err = err {
                                                        print("Error getting documents: \(err)")
                                                    } else {
                                                        let totalDocCount = querySnapshot!.documents.count
                                                        
                                                        let dateFormatter = DateFormatter()
                                                        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                                                        let date = Date()
                                                        
                                                        
                                                        
                                                        self.db.collection("Users").document(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyUsername})[indexPath.row]).collection("notifications").document("\(totalDocCount)").setData(["notificationTitle": "💬 New Reply to Reply", "notificationBody": "Someone replied to your response reply: \(commentReply!)", "notificationCondition": conditionSelected, "notificationDiscussion": selectedDiscussion, "notificationDate": dateFormatter.string(from: date)])
                                                    }
                                            }
                                            
                                            
                                        } else {
                                            print("Document does not exist")
                                        }
                                    case .failure(let error):
                                        print("Error decoding question: \(error)")
                                        }
                                    }
                                
                                
                                
                                cell?.presentSuccess()
                            }}
                    }
                }}
            
        }
        
        
        
        
        if sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionReplyButtonTapped})[indexPath.row] == false {
            cell?.postCommentReplyViewHeightConstraint.constant = 0
            cell?.postCommentReplyView.layoutIfNeeded()
            
            cell?.postCommentReplyLabel.isHidden = true
            
            cell?.postCommentReplyTextField.isHidden = true
            cell?.postCommentReplyCancelorPost.isHidden = true
            cell?.postCommentReplyTextField.isEnabled = false
            cell?.postCommentReplyCancelorPost.isEnabled = false
        }
        
        else {
            textFieldIndicator = "commentReply"

            cell?.postCommentReplyViewHeightConstraint.constant = 80
            cell?.postCommentReplyLabel.text = "     Reply To: User " + sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionReplyUsername})[indexPath.row]

            cell?.postCommentReplyView.layoutIfNeeded()
            
            cell?.postCommentReplyLabel.isHidden = false
            
            cell?.postCommentReplyTextField.isHidden = false
            cell?.postCommentReplyCancelorPost.isHidden = false
            cell?.postCommentReplyTextField.isEnabled = true
            cell?.postCommentReplyCancelorPost.isEnabled = true
            
            replyIndex = indexPath.row
        }
        
        
        
                
                
                
                cell?.responseDateLabel.text = String(displayedDate[indexPath.row][..<displayedDate[indexPath.row].index(displayedDate[indexPath.row].startIndex, offsetBy:10)])
                
                cell?.layer.cornerRadius = 10
                
                cell?.responseUserLabel.text = "User " + sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionReplyUsername})[indexPath.row]
                
                cell?.responseUpvoteLabel.text = String(sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyUpvotes})[indexPath.row])
                
                cell?.replyButton.layer.cornerRadius = 10
                cell?.responseReplyLabel.sizeToFit()
                cell?.responseReplyLabel.numberOfLines = 0
                
                cell?.voteContentView.layer.cornerRadius = 10
                cell?.upheartView.layer.cornerRadius = 10
                cell?.downheartView.layer.cornerRadius = 10
        
    
                
                if self.discussionCommentUserUpvote.contains((cell?.responseReplyLabel.text)!) {
                    cell?.upheartImage.image = UIImage(systemName: "arrow.up.heart.fill")
                    cell?.upheartView.backgroundColor = UIColor.white
                    
                }
                else {
                    cell?.upheartImage.image = UIImage(systemName: "arrow.up.heart")
                    cell?.upheartView.backgroundColor = UIColor.systemGray6
                    
                    
                }
                
                
                
                
                
                
                if self.discussionCommentUserDownvote.contains((cell?.responseReplyLabel.text)!) {
                    cell?.downheartImage.image = UIImage(systemName: "arrow.down.heart.fill")
                    cell?.downheartView.backgroundColor = UIColor.white
                }
                else {
                    cell?.downheartImage.image = UIImage(systemName: "arrow.down.heart")
                    cell?.downheartView.backgroundColor = UIColor.systemGray6
                }
                
                cell?.upheartButton.addTarget(self, action: #selector(upheartTapped(sender:)), for: .touchUpInside)
                
                cell?.downheartButton.addTarget(self, action: #selector(downheartTapped(sender:)), for: .touchUpInside)
                
                cell?.replyButton.addTarget(self, action: #selector(commentReplyButtonTapped(sender:)), for: .touchUpInside)
                
                cell?.postCommentReplyCancelorPost.tag = indexPath.row
                cell?.postCommentReplyCancelorPost.addTarget(self, action: #selector(postOrCancelButton(sender: )), for: .touchUpInside)
                
                cell?.replyButton.tag = indexPath.row
                
                cell?.upheartButton.tag = indexPath.row
                cell?.downheartButton.tag = indexPath.row
        
        
                cell?.postCommentReplyTextField.tag = collectionView.tag
        
        
        
        cell?.deleteOrFlag.showsMenuAsPrimaryAction = true
        
        if sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionReplyUsername})[indexPath.row] == Auth.auth().currentUser!.uid {
            cell?.deleteOrFlag.menu = UIMenu(children: [
                UIAction(title: "Delete Response", image: UIImage(systemName: "trash"), handler: { action in
                    
                    
                    self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussCommentTitle})[indexPath.row])
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    print("\(document.documentID) => \(document.data())")
                                    
                                    let commentDocument = document.documentID
                                    
                                    

                                    
                                    self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).collection("replies").whereField("commentTitle", isEqualTo: sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussCommentTitle})[indexPath.row]).whereField("repliesTitle", isEqualTo: sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle})[indexPath.row]).whereField("repliesDate", isEqualTo: displayedDate[indexPath.row]).whereField("repliesUser", isEqualTo: sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionReplyUsername})[indexPath.row])
                                        .getDocuments() { (querySnapshot, err) in
                                            if let err = err {
                                                print("Error getting documents: \(err)")
                                                let alert = UIAlertController(title: "Error⚠️❌", message: "Please Connect to WiFi or Restart App", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                    switch action.style{
                                                        case .default:
                                                        print("default")

                                                        
                                                        case .cancel:
                                                        print("cancel")
                                                        
                                                        case .destructive:
                                                        print("destructive")
                                                        
                                                    }
                                                }))
                                                
                                                cell?.presentError()
                                            }
                                            
                                            else {
                                                for document in querySnapshot!.documents {
                                                    self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(commentDocument).collection("replies").document(document.documentID).updateData(["repliesTitle" : " "])
                                                    
                                                    let alert = UIAlertController(title: "Successfully Deleted🗑", message: "Please Refresh", preferredStyle: .alert)
                                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                        switch action.style{
                                                            case .default:
                                                            print("default")

                                                            
                                                            case .cancel:
                                                            print("cancel")
                                                            
                                                            case .destructive:
                                                            print("destructive")
                                                            
                                                        }
                                                    }))
                                                    
                                                    cell?.presentSuccess()
                                                    
                                                    cell?.responseReplyLabel.textColor = UIColor.red
                                                 
                                                }
                                            }
                                            
                                    
                                    
                                }
                                
                            }}
                    
                    
                    
               
                    }
                    
                })
            ])
        }
        else {
            cell?.deleteOrFlag.menu = UIMenu(children: [
                
                UIAction(title: "Report Post",image: UIImage(systemName: "flag"), handler: { action in
                    
                    reportedDiscussion = sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussCommentTitle})[indexPath.row]

                    reportedDiscussionReply = (cell?.responseReplyLabel.text)!

                    self.reportCommentButtonTapped()
                    
                })
            ])
        }
                
        cell?.pieChartButton.addTarget(self, action: #selector(pieChartButtonTapped(sender:)), for: .touchUpInside)

        cell?.pieChartButton.tag = indexPath.row
                
                
                return cell!
                
            }
        

    @objc func pieChartButtonTapped(sender:UIButton) {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)

        var pieChartVC = UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "PieChartViewController")
        if let sheet = pieChartVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
            
        
        var delimeter = "-"
        var commentTitle = sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row]
        var newCommentTitle = commentTitle.components(separatedBy: delimeter)
        

        selectedPieChartResponse = newCommentTitle[0]
        
        selectedGenderVotes = sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyGenderUpvotes})[indexpath1.row]
        selectedRaceVotes = sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyRaceUpvotes})[indexpath1.row]
        selectedAgeVotes = sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyAgeUpvotes})[indexpath1.row]
        selectedCountry = sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountry})[indexpath1.row]
        selectedCountryVotes = sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountryUpvotes})[indexpath1.row]
        
        
        self.window?.rootViewController?.present(pieChartVC, animated: true, completion: nil)

        
    }
    
    
    @objc func reportCommentButtonTapped() {
        var reportResponseVC = UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "ReportResponseViewController")
        if let sheet = reportResponseVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 25
            
        }
        
        self.window?.rootViewController?.present(reportResponseVC, animated: true, completion: nil)

    }
    
    
    
    @objc func postOrCancelButton(sender: UIButton) {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        
        if sender.titleLabel?.text == "Cancel" {
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyButtonTapped = false
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyCancelorPost = ""

            discussionRepliesIndicator = self.responseCommentsCollectionView.tag - 1

            self.responseCommentsCollectionView.reloadData()

        }
        else {
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyButtonTapped = false
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyCancelorPost = "Post"

            discussionRepliesIndicator = self.responseCommentsCollectionView.tag - 1

            self.responseCommentsCollectionView.reloadData()
        }
        
    }
    
    
    @objc func commentReplyButtonTapped(sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
                
        
        if sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionReplyButtonTapped})[indexpath.row] == false {
            
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath.row].discussionReplyButtonTapped = true
            
            
            var i = 0
            
            
            while i < sharedComments[self.responseCommentsCollectionView.tag].commentReplies.count {
                if i != indexpath.row {
                    sharedComments[self.responseCommentsCollectionView.tag].commentReplies[i].discussionReplyButtonTapped = false
                }
                i+=1
            }
            
            
            discussionRepliesIndicator = self.responseCommentsCollectionView.tag - 1

            self.responseCommentsCollectionView.reloadData()
            
            
            
        }
        
        
        
        
    }

    @objc func upheartTapped(sender: UIButton) {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        
        var docCommentNum = ""
        
        if self.discussionCommentUserUpvote.contains((sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])) {
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                "upvotes": FieldValue.arrayRemove([sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row]
                                                ])])
            
            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussCommentTitle})[indexpath1.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            docCommentNum = document.documentID
                            
                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies")
                                .whereField("repliesTitle", isEqualTo: sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])
                                .getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        for document in querySnapshot!.documents {
                                            print("\(document.documentID) => \(document.data())")

                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                "repliesUpvotes": (Int(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyUpvotes})[indexpath1.row]) - 1)


                                            ])
                                            
                                            if sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountry})[indexpath1.row].contains(sharedDiscussionCommentUserCountry) {
                                                var countryIndex = sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountry})[indexpath1.row].firstIndex(of: sharedDiscussionCommentUserCountry)
                                                sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyCountryUpvotes[countryIndex!] -= 1

                                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                    "countryUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountryUpvotes})[indexpath1.row]])
                                            }





                                            var genderIndex = 0
                                            if sharedDiscussionCommentUserGender == "Male" {
                                                genderIndex = 0
                                            }
                                            else if sharedDiscussionCommentUserGender == "Female" {
                                                genderIndex = 1

                                            }
                                            else if sharedDiscussionCommentUserGender == "Other" {
                                                genderIndex = 2

                                            }
                                            
                                            
                                            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyGenderUpvotes[genderIndex] -= 1
                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                "genderUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyGenderUpvotes})[indexpath1.row]
                                            ])
                                            
                                            var raceIndex = 0
                                            if sharedDiscussionCommentUserRace == "White" {
                                                raceIndex = 0
                                            }
                                            else if sharedDiscussionCommentUserRace == "Black or African American" {
                                                raceIndex = 1

                                            }
                                            else if sharedDiscussionCommentUserRace == "American Indian or Alaska Native" {
                                                raceIndex = 2

                                            }
                                            else if sharedDiscussionCommentUserRace == "Asian" {
                                                raceIndex = 3

                                            }
                                            else if sharedDiscussionCommentUserRace == "Native Hawaiian or Other Pacific Islander" {
                                                raceIndex = 4

                                            }

                                            
                                            
                                            
                                            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyRaceUpvotes[raceIndex] -= 1
                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                "raceUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyRaceUpvotes})[indexpath1.row]
                                            ])
                                            
                                            
                


                                            var ageIndex = 0
                                            if sharedDiscussionCommentUserAge > 0 && sharedDiscussionCommentUserAge <= 10 {
                                                ageIndex = 0
                                            }
                                            else if sharedDiscussionCommentUserAge > 10 && sharedDiscussionCommentUserAge <= 20 {
                                                ageIndex = 1
                                            }
                                            else if sharedDiscussionCommentUserAge > 20 && sharedDiscussionCommentUserAge <= 30 {
                                                ageIndex = 2
                                            }
                                            else if sharedDiscussionCommentUserAge > 30 && sharedDiscussionCommentUserAge <= 40 {
                                                ageIndex = 3
                                            }
                                            else if sharedDiscussionCommentUserAge > 40 && sharedDiscussionCommentUserAge <= 50 {
                                                ageIndex = 4
                                            }
                                            else if sharedDiscussionCommentUserAge > 50 && sharedDiscussionCommentUserAge <= 60 {
                                                ageIndex = 5
                                            }
                                            else if sharedDiscussionCommentUserAge > 60 && sharedDiscussionCommentUserAge <= 70 {
                                                ageIndex = 6
                                            }
                                            else if sharedDiscussionCommentUserAge > 70 && sharedDiscussionCommentUserAge <= 80 {
                                                ageIndex = 7
                                            }
                                            else if sharedDiscussionCommentUserAge > 80 {
                                                ageIndex = 8
                                            }


                                            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyAgeUpvotes[ageIndex] -= 1
                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                "ageUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyAgeUpvotes})[indexpath1.row]
                                            ])

                                        }

                                    }
                                    
                                    
                                    
                                    
                                    
                                    sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionCommentReplyUpvotes = (sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyUpvotes})[indexpath1.row] - 1)

                                    
                                    self.getVoteData()


                            }
                            
                        }
                        
                    }}

            

            var index = 0
            var i = 1
            
            while i < discussionCommentUserUpvote.count {
                if discussionCommentUserUpvote[i] == sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row] {
                    index = i
                }
                i+=1
            }

            discussionCommentUserUpvote.remove(at: index)


        }

        else {
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                "upvotes": FieldValue.arrayUnion([sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row]
                                                ])])


            discussionCommentUserUpvote.append(sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])

            
            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussCommentTitle})[indexpath1.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            docCommentNum = document.documentID
                            
                    

                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies")
                                .whereField("repliesTitle", isEqualTo: sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])
                                .getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        for document in querySnapshot!.documents {
                                            print("\(document.documentID) => \(document.data())")

                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                "repliesUpvotes": (Int(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyUpvotes})[indexpath1.row]))
                                            ])
                                            
                                            let docRefFour = self.db.collection("Users").document(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyUsername})[indexpath1.row])

                                            docRefFour.getDocument { (document, error) in

                                                let result = Result {
                                                  try document?.data(as: DeviceTokenReference.self)

                                                }
                                                print(result)
                                                switch result {
                                                case .success(let deviceToken):
                                                    if let deviceToken = deviceToken {
                                                        
                                                        let sender = PushNotificationSender()
                                                        sender.sendPushNotification(to: deviceToken.deviceToken!, title: "MedConnect+", body: "♥️⬆️ Someone upvoted your response reply: \(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])")
                                                        
                                                        self.db.collection("Users").document(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyUsername})[indexpath1.row]).collection("notifications").getDocuments() { (querySnapshot, err) in
                                                                if let err = err {
                                                                    print("Error getting documents: \(err)")
                                                                } else {
                                                                    let totalDocCount = querySnapshot!.documents.count
                                                                    
                                                                    let dateFormatter = DateFormatter()
                                                                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                                                                    let date = Date()
                                                                    
                                                                    
                                                                    
                                                                    self.db.collection("Users").document(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyUsername})[indexpath1.row]).collection("notifications").document("\(totalDocCount)").setData(["notificationTitle": "♥️⬆️ New Upheart", "notificationBody": "Someone upvoted your response reply: \(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])", "notificationCondition": conditionSelected, "notificationDiscussion": selectedDiscussion, "notificationDate": dateFormatter.string(from: date)])
                                                                }
                                                        }
                                                        
                                                    } else {
                                                        print("Document does not exist")
                                                    }
                                                case .failure(let error):
                                                    print("Error decoding question: \(error)")
                                                    }
                                                }
                                            
                                            
                                            
                                            if sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountry})[indexpath1.row].contains(sharedDiscussionCommentUserCountry) {

                                                var countryIndex = sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountry})[indexpath1.row].firstIndex(of: sharedDiscussionCommentUserCountry)
                                                sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyCountryUpvotes[countryIndex!] += 1
                                               

                                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                    "countryUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountryUpvotes})[indexpath1.row]])
                                            }



                                            else {

                                                sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyCountry.append(sharedDiscussionCommentUserCountry)



                                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                    "country": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountry})[indexpath1.row]
                                                ])


                                                sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyCountryUpvotes.append(1)
                                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                    "countryUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountryUpvotes})[indexpath1.row]
                                                ])


                                            }


                                            var genderIndex = 0
                                            if sharedDiscussionCommentUserGender == "Male" {
                                                genderIndex = 0
                                            }
                                            else if sharedDiscussionCommentUserGender == "Female" {
                                                genderIndex = 1

                                            }
                                            else if sharedDiscussionCommentUserGender == "Other" {
                                                genderIndex = 2

                                            }
                                            
                                            
                                            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyGenderUpvotes[genderIndex] += 1
                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                "genderUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyGenderUpvotes})[indexpath1.row]
                                            ])
                                            
                                            
                                            var raceIndex = 0
                                            if sharedDiscussionCommentUserRace == "White" {
                                                raceIndex = 0
                                            }
                                            else if sharedDiscussionCommentUserRace == "Black or African American" {
                                                raceIndex = 1

                                            }
                                            else if sharedDiscussionCommentUserRace == "American Indian or Alaska Native" {
                                                raceIndex = 2

                                            }
                                            else if sharedDiscussionCommentUserRace == "Asian" {
                                                raceIndex = 3

                                            }
                                            else if sharedDiscussionCommentUserRace == "Native Hawaiian or Other Pacific Islander" {
                                                raceIndex = 4

                                            }

                                            
                                            
                                            
                                            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyRaceUpvotes[raceIndex] += 1
                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                "raceUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyRaceUpvotes})[indexpath1.row]
                                            ])
                                            
                                            
                


                                            var ageIndex = 0
                                            if sharedDiscussionCommentUserAge > 0 && sharedDiscussionCommentUserAge <= 10 {
                                                ageIndex = 0
                                            }
                                            else if sharedDiscussionCommentUserAge > 10 && sharedDiscussionCommentUserAge <= 20 {
                                                ageIndex = 1
                                            }
                                            else if sharedDiscussionCommentUserAge > 20 && sharedDiscussionCommentUserAge <= 30 {
                                                ageIndex = 2
                                            }
                                            else if sharedDiscussionCommentUserAge > 30 && sharedDiscussionCommentUserAge <= 40 {
                                                ageIndex = 3
                                            }
                                            else if sharedDiscussionCommentUserAge > 40 && sharedDiscussionCommentUserAge <= 50 {
                                                ageIndex = 4
                                            }
                                            else if sharedDiscussionCommentUserAge > 50 && sharedDiscussionCommentUserAge <= 60 {
                                                ageIndex = 5
                                            }
                                            else if sharedDiscussionCommentUserAge > 60 && sharedDiscussionCommentUserAge <= 70 {
                                                ageIndex = 6
                                            }
                                            else if sharedDiscussionCommentUserAge > 70 && sharedDiscussionCommentUserAge <= 80 {
                                                ageIndex = 7
                                            }
                                            else if sharedDiscussionCommentUserAge > 80 {
                                                ageIndex = 8
                                            }


                                            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyAgeUpvotes[ageIndex] += 1
                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                                "ageUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyAgeUpvotes})[indexpath1.row]
                                            ])
                                            
                                            
                                            
                                            
        
                                        }
                                    }
                            }
                            
                        }}}
            
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionCommentReplyUpvotes = (sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyUpvotes})[indexpath1.row] + 1)


            if self.discussionCommentUserDownvote.contains((sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])) {
                self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                    "downvotes": FieldValue.arrayRemove([sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row]])])
                
                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussCommentTitle})[indexpath1.row])
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                
                                docCommentNum = document.documentID
                                
                            

                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies")
                                    .whereField("repliesTitle", isEqualTo: sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")

                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum).collection("replies").document(document.documentID).updateData([
                                    "repliesDownvotes": (Int(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyDownvotes})[indexpath1.row]) - 1)
                                ])
                                
                                
                                

                            }
                        }

                        
                        sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionCommentReplyDownvotes = (sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyDownvotes})[indexpath1.row] - 1)




                        self.getVoteData()
                }
                                
                            }}}

                var index = 0
                var i = 1
                
                while i < discussionCommentUserDownvote.count {
                    if discussionCommentUserDownvote[i] == sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row] {
                        index = i
                    }
                    i+=1
                }

                discussionCommentUserDownvote.remove(at: index)


            }

            else {
                getVoteData()
            }
















    }
    }
    
    @objc func downheartTapped(sender: UIButton) {
        
        var docCommentNum2 = ""
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        
        self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussCommentTitle})[indexpath1.row])
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        docCommentNum2 = document.documentID
                        
                    }}}
        
        
        
        if self.discussionCommentUserDownvote.contains((sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])) {
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                "downvotes": FieldValue.arrayRemove([sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row]
                                                ])])
            
            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussCommentTitle})[indexpath1.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            docCommentNum2 = document.documentID
                            
                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum2).collection("replies")
                                .whereField("repliesTitle", isEqualTo: sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])
                                .getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        for document in querySnapshot!.documents {
                                            print("\(document.documentID) => \(document.data())")

                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum2).collection("replies").document(document.documentID).updateData([
                                                "repliesDownvotes": (Int(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyDownvotes})[indexpath1.row]) - 1)


                                            ])

                                        }

                                    }
                                    
                                    sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionCommentReplyDownvotes = (sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyDownvotes})[indexpath1.row] - 1)

                                    
                                    self.getVoteData()
                                }}}}
            
            
                    
                    
                    
                            
                    
                    

   
            
            var index = 0
            var i = 1
            
            while i < discussionCommentUserDownvote.count {
                if discussionCommentUserDownvote[i] == sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row] {
                    index = i
                }
                i+=1
            }
            
            discussionCommentUserDownvote.remove(at: index)
            
            
        }
        
        else {
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                "downvotes": FieldValue.arrayUnion([sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row]
                                                ])])
            
            discussionCommentUserDownvote.append(sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])

        
            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussCommentTitle})[indexpath1.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            docCommentNum2 = document.documentID
                            
                        
            
            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum2).collection("replies")
                                .whereField("repliesTitle", isEqualTo: sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")

                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum2).collection("replies").document(document.documentID).updateData([
                                "repliesDownvotes": (Int(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyDownvotes})[indexpath1.row]))
                            ])
                        }
                    }
            }
                        }
                    }
                }
            
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionCommentReplyDownvotes = (sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyDownvotes})[indexpath1.row] + 1)


            
            if self.discussionCommentUserUpvote.contains((sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])) {
                self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                    "upvotes": FieldValue.arrayRemove([sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row]])])
                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussCommentTitle})[indexpath1.row])
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                
                                docCommentNum2 = document.documentID
                                
                            
                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum2).collection("replies")
                                    .whereField("repliesTitle", isEqualTo: sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")

                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum2).collection("replies").document(document.documentID).updateData([
                                    "repliesUpvotes": (Int(sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyUpvotes})[indexpath1.row]) - 1)
                                ])

                                
                                
                                if sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountry})[indexpath1.row].contains(sharedDiscussionCommentUserCountry) {
                                    var countryIndex = sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountry})[indexpath1.row].firstIndex(of: sharedDiscussionCommentUserCountry)
                                    sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyCountryUpvotes[countryIndex!] -= 1

                                    self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum2).collection("replies").document(document.documentID).updateData([
                                        "countryUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyCountryUpvotes})[indexpath1.row]])
                                }





                                var genderIndex = 0
                                if sharedDiscussionCommentUserGender == "Male" {
                                    genderIndex = 0
                                }
                                else if sharedDiscussionCommentUserGender == "Female" {
                                    genderIndex = 1

                                }
                                else if sharedDiscussionCommentUserGender == "Other" {
                                    genderIndex = 2

                                }
                                
                                
                                sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyGenderUpvotes[genderIndex] -= 1
                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum2).collection("replies").document(document.documentID).updateData([
                                    "genderUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyGenderUpvotes})[indexpath1.row]
                                ])
                                
                                var raceIndex = 0
                                if sharedDiscussionCommentUserRace == "White" {
                                    raceIndex = 0
                                }
                                else if sharedDiscussionCommentUserRace == "Black or African American" {
                                    raceIndex = 1

                                }
                                else if sharedDiscussionCommentUserRace == "American Indian or Alaska Native" {
                                    raceIndex = 2

                                }
                                else if sharedDiscussionCommentUserRace == "Asian" {
                                    raceIndex = 3

                                }
                                else if sharedDiscussionCommentUserRace == "Native Hawaiian or Other Pacific Islander" {
                                    raceIndex = 4

                                }

                                
                                
                                
                                sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyRaceUpvotes[raceIndex] -= 1
                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum2).collection("replies").document(document.documentID).updateData([
                                    "raceUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyRaceUpvotes})[indexpath1.row]
                                ])
                                
                                
    


                                var ageIndex = 0
                                if sharedDiscussionCommentUserAge > 0 && sharedDiscussionCommentUserAge <= 10 {
                                    ageIndex = 0
                                }
                                else if sharedDiscussionCommentUserAge > 10 && sharedDiscussionCommentUserAge <= 20 {
                                    ageIndex = 1
                                }
                                else if sharedDiscussionCommentUserAge > 20 && sharedDiscussionCommentUserAge <= 30 {
                                    ageIndex = 2
                                }
                                else if sharedDiscussionCommentUserAge > 30 && sharedDiscussionCommentUserAge <= 40 {
                                    ageIndex = 3
                                }
                                else if sharedDiscussionCommentUserAge > 40 && sharedDiscussionCommentUserAge <= 50 {
                                    ageIndex = 4
                                }
                                else if sharedDiscussionCommentUserAge > 50 && sharedDiscussionCommentUserAge <= 60 {
                                    ageIndex = 5
                                }
                                else if sharedDiscussionCommentUserAge > 60 && sharedDiscussionCommentUserAge <= 70 {
                                    ageIndex = 6
                                }
                                else if sharedDiscussionCommentUserAge > 70 && sharedDiscussionCommentUserAge <= 80 {
                                    ageIndex = 7
                                }
                                else if sharedDiscussionCommentUserAge > 80 {
                                    ageIndex = 8
                                }


                                sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyAgeUpvotes[ageIndex] -= 1
                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(docCommentNum2).collection("replies").document(document.documentID).updateData([
                                    "ageUpvotes": sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionReplyAgeUpvotes})[indexpath1.row]
                                ])
                                
                            }
                        }
                
                        sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionCommentReplyUpvotes = (sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyUpvotes})[indexpath1.row] - 1)


                        
                        
     
                        self.getVoteData()

                }
                            }}}
                
                
                
                var index = 0
                var i = 1
                
                while i < discussionCommentUserUpvote.count {
                    if discussionCommentUserUpvote[i] == sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row] {
                        index = i
                    }
                    i+=1
                }

                discussionCommentUserUpvote.remove(at: index)
            }
            
            else {
                getVoteData()
            }
                
            
        
            
        
        
     
       

        
            
        
        
        
        }}
}

    
