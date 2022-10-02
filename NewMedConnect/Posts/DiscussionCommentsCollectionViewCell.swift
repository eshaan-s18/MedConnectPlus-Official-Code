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

var selectedTextFieldCount2 = 0
var replyTextFieldVal2 = ""



var x = 3

class DiscussionCommentsCollectionViewCell: UICollectionViewCell, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
    var cellHeightNew = 0
    
    

    
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
    
    var test = [[1,2,3], [1,2,3,4], [1,2,3,4,5]]


    var displayedReplies = 0
    var dateFormatter = DateFormatter()

    var collectionViewTag = 0

    var discussions: DiscussionComment? {
        didSet {
            commentLabel.text = discussions?.discussionsCommentTitle
            responseCommentsCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        // Initialization code
        responseCommentsCollectionView.delegate = self
        responseCommentsCollectionView.dataSource = self
//        replyTextField.delegate = self
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
                    // A `City` value was successfully initialized from the DocumentSnapshot.
                    let docRefThree = self.db.collection("Users").document(Auth.auth().currentUser!.uid)
                    docRefThree.getDocument { (document, error) in

                        let result = Result {
                          try document?.data(as: DownvoteReference.self)

                        }
                        print(result)
                        switch result {
                        case .success(let downvote):
                            if let downvote = downvote {
                                // A `City` value was successfully initialized from the DocumentSnapshot.
                                self.discussionCommentUserDownvote = downvote.downvotes!
                                self.discussionCommentUserUpvote = upvote.upvotes!
                                
                                print("okay")
                            } else {
                                // A nil value was successfully initialized from the DocumentSnapshot,
                                // or the DocumentSnapshot was nil.
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            // A `City` value could not be initialized from the DocumentSnapshot.
                            print("Error decoding question: \(error)")
                            }
                        }
                    print("okay")
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
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
                    // A `City` value was successfully initialized from the DocumentSnapshot.
                    let docRefThree = self.db.collection("Users").document(Auth.auth().currentUser!.uid)
                    docRefThree.getDocument { (document, error) in

                        let result = Result {
                          try document?.data(as: DownvoteReference.self)

                        }
                        print(result)
                        switch result {
                        case .success(let downvote):
                            if let downvote = downvote {
                                // A `City` value was successfully initialized from the DocumentSnapshot.
                                self.discussionCommentUserDownvote = downvote.downvotes!
                                self.discussionCommentUserUpvote = upvote.upvotes!
                                
                                countNum = self.responseCommentsCollectionView.tag - 1
                                print(countNum)
                                
                                self.responseCommentsCollectionView.reloadData()
                                self.responseCommentsCollectionView.dataSource = self
                                self.responseCommentsCollectionView.delegate = self
                                
                                print("okay")
                            } else {
                                // A nil value was successfully initialized from the DocumentSnapshot,
                                // or the DocumentSnapshot was nil.
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            // A `City` value could not be initialized from the DocumentSnapshot.
                            print("Error decoding question: \(error)")
                            }
                        }
                    print("okay")
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("Error decoding question: \(error)")
                }
            }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TEst")
        selectedTextFieldCount = textField.tag + 1
        
        whichTextField = "comment"
        

        
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
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        print("TEST")
//    }
//
    

   
}


    
extension DiscussionCommentsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 320, height: 105)
    
        }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        self.sortedDiscussionComments = self.unsortedDiscussionComments.sorted(by: {$0.discussionCommentDate.compare($1.discussionCommentDate) == .orderedDescending})

        
        print(sharedComments.count)
        print(countNum)
        if countNum == sharedComments.count - 1 {
            countNum = -1
        }
        countNum += 1
        print(countNum)
        
        collectionView.tag = countNum
        
        print(sharedComments)

        print(sharedComments.map({$0.commentReplies})[countNum])
        
        if sharedComments.map({$0.commentReplies})[countNum].count > 0 {

            
            
            var sortedComments = [DiscussionComment]()
            
            //sharedComments[countNum] = sortedComments.map({$0.commentReplies}).sorted(by: {$0.discussionCommentDate.compare($1.discussionCommentDate) == .orderedDescending})
            sharedComments[countNum].commentReplies = sharedComments.map({$0.commentReplies})[countNum].sorted(by: {$0.discussionCommentReplyDate.compare($1.discussionCommentReplyDate) == .orderedDescending})
        
        
        
            return sharedComments.map({$0.commentReplies})[countNum].count

        }
        else {
            return 0
        }
//        print(sharedComments)
//        if i == sharedComments.count - 1 {
//            i = -1
//        }
//        i += 1
//        print(i)
//        print(test[i].count)
//        print(test[i])
//        collectionView.tag = i
//        return test[i].count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "responseCommentsCollectionCell", for: indexPath) as? ResponseCommentsCollectionViewCell
        
        print(sharedComments.map({$0.commentReplies})[collectionView.tag])
        print(sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle}))
        print(sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle})[indexPath.row])
       
        cell?.responseReplyLabel.text = sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle})[indexPath.row]
        
       // responseCommentsViewHeightConstraint.constant = (responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height) + 65
        
        
        //cell?.responseReplyLabel.text = String(test[collectionView.tag][indexPath.row])
        
//        print(sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle})[indexPath.row])
//
//        print(collectionView.collectionViewLayout.collectionViewContentSize.height)
//        print(collectionView.tag)
//
//        print(repliesCollectionViewHeights)
//
//
//        repliesCollectionViewHeights[collectionView.tag] = (collectionView.collectionViewLayout.collectionViewContentSize.height)
////        print(repliesCollectionViewHeights)
////
//        if openReplies[collectionView.tag] == true {
//            responseCommentsViewHeightConstraint.constant -= repliesCollectionViewHeights[indexPath.row] + 65
//        }
//        else {
//            responseCommentsViewHeightConstraint.constant = 0
//        }
        
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"

//        var displayedDate = sortedDiscussionComments.map({dateFormatter.string(from:$0.discussionCommentDate)})
        var displayedDate = sharedComments.map({$0.commentReplies})[collectionView.tag].map({dateFormatter.string(from: $0.discussionCommentReplyDate)})
        
                
//            var dateDisplayed:String = String(self.sortedDiscussions!.map({dateFormatter!.string(from:$0.discussionDates!)!}!)!)! ?? ""

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
                                
                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).collection("replies").document("\(docCount2)").setData(["commentTitle" : originalDiscussionComment, "repliesTitle" : ("@User_" + sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionReplyUsername})[indexPath.row].prefix(12) + "... " + replyTextFieldVal2), "repliesDate": dateFormatter.string(from: date), "repliesDownvotes": 0, "repliesUpvotes": 0, "repliesUser": Auth.auth().currentUser!.uid])
                                
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
            whichTextField = "commentReply"

            cell?.postCommentReplyViewHeightConstraint.constant = 80
            cell?.postCommentReplyLabel.text = "     Reply To: User " + sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionReplyUsername})[indexPath.row]

            cell?.postCommentReplyView.layoutIfNeeded()
            
            cell?.postCommentReplyLabel.isHidden = false
            
            cell?.postCommentReplyTextField.isHidden = false
            cell?.postCommentReplyCancelorPost.isHidden = false
            cell?.postCommentReplyTextField.isEnabled = true
            cell?.postCommentReplyCancelorPost.isEnabled = true
            
            replyIndex = indexPath.row
            print(replyIndex)
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
                
                
                
                
                
                print(discussionCommentUserDownvote)
                
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
        
        
                
        
                
                
                return cell!
                
            }
        

//    @objc func upheartTapped(sender: UIButton) {
//
//        let indexpath1 = IndexPath(row: sender.tag, section: 0)
//
//        print((sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row]))
//    }
    
    
    @objc func postOrCancelButton(sender: UIButton) {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        
        if sender.titleLabel?.text == "Cancel" {
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyButtonTapped = false
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyCancelorPost = ""

            countNum = self.responseCommentsCollectionView.tag - 1

            self.responseCommentsCollectionView.reloadData()

        }
        else {
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyButtonTapped = false
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionReplyCancelorPost = "Post"

            countNum = self.responseCommentsCollectionView.tag - 1

            self.responseCommentsCollectionView.reloadData()
        }
        
    }
    
    
    @objc func commentReplyButtonTapped(sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        
        print("Test")
        
        
        if sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionReplyButtonTapped})[indexpath.row] == false {
            
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath.row].discussionReplyButtonTapped = true
            
            
            var i = 0
            
            
            while i < sharedComments[self.responseCommentsCollectionView.tag].commentReplies.count {
                if i != indexpath.row {
                    sharedComments[self.responseCommentsCollectionView.tag].commentReplies[i].discussionReplyButtonTapped = false
                    print(sharedComments[self.responseCommentsCollectionView.tag].commentReplies[i])
                }
                i+=1
            }
            
            
            countNum = self.responseCommentsCollectionView.tag - 1

            self.responseCommentsCollectionView.reloadData()
            
            
            
        }
        
        
        
        
        
        
        
        
            
            
            
        
        
        
        
//        print(responseCommentsViewHeightConstraint.constant)
////        postCommentReplyUpperConstraint.constant = 72
//
//        responseCommentsViewHeightConstraint.constant = responseCommentsViewHeightConstraint.constant - 50
////        postCommentReplyViewHeightConstraint.constant = 72
//        print(responseCommentsViewHeightConstraint.constant)
    }

    @objc func upheartTapped(sender: UIButton) {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        
        var docCommentNum = ""
        
        
        
        
        
        
        print(discussionCommentUserUpvote)

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

                                        }

                                    }
                                    
                                    
                                    
                                    
                                    
                                    sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionCommentReplyUpvotes = (sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyUpvotes})[indexpath1.row] - 1)

                                    
                                    self.getVoteData()


                            }
                            
                        }
                        
                    }}

            

            var index = 0
            var i = 1
            print(discussionCommentUserUpvote.count)
            print(discussionCommentUserUpvote)
          //  print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
            while i < discussionCommentUserUpvote.count {
                if discussionCommentUserUpvote[i] == sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row] {
                    index = i
                }
                i+=1
            }

            print(index)
            discussionCommentUserUpvote.remove(at: index)
            print(discussionCommentUserUpvote)


        }

        else {
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                "upvotes": FieldValue.arrayUnion([sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row]
                                                ])])


            print(discussionCommentUserUpvote)
            discussionCommentUserUpvote.append(sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])
            print(discussionCommentUserUpvote)



            print(conditionSelected)
            print(discussionDocument)
            print(docCommentNum)
            
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
                                        }
                                    }
                            }
                            
                        }}}
            
            sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionCommentReplyUpvotes = (sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyUpvotes})[indexpath1.row] + 1)


//
//            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row] + 1), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath1.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath1.row], discussionReplyCancelOrPost: ""), at: indexpath1.row)
//            print(self.sortedDiscussionComments)
//            print(self.sortedDiscussionComments)
//            self.sortedDiscussionComments.remove(at: indexpath1.row + 1)
//            print(self.sortedDiscussionComments)
//            print(indexpath1.row)

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


//                        self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row] - 1, discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath1.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath1.row], discussionReplyCancelOrPost: ""), at: indexpath1.row)
//                        print(self.sortedDiscussionComments)
//                        self.sortedDiscussionComments.remove(at: indexpath1.row + 1)
//                        print(self.sortedDiscussionComments)

                        self.getVoteData()
                }
                                
                            }}}

                var index = 0
                var i = 1
                print(discussionCommentUserDownvote.count)
                print(discussionCommentUserDownvote)
                    // print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
                while i < discussionCommentUserDownvote.count {
                    if discussionCommentUserDownvote[i] == sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row] {
                        index = i
                    }
                    i+=1
                }

                print(index)
                discussionCommentUserDownvote.remove(at: index)
                print(discussionCommentUserDownvote)


            }

            else {
                getVoteData()
            }








        //print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle}))








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
            print(discussionCommentUserUpvote.count)
            print(discussionCommentUserUpvote)
          //  print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
            while i < discussionCommentUserDownvote.count {
                if discussionCommentUserDownvote[i] == sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row] {
                    index = i
                }
                i+=1
            }
            
            print(index)
            discussionCommentUserDownvote.remove(at: index)
            print(discussionCommentUserDownvote)
            
            
        }
        
        else {
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                "downvotes": FieldValue.arrayUnion([sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row]
                                                ])])
            
            print(discussionCommentUserUpvote)
            discussionCommentUserDownvote.append(sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row])
            print(discussionCommentUserUpvote)

        
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

            
//            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row] + 1, discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath1.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath1.row], discussionReplyCancelOrPost: ""), at: indexpath1.row)
//            print(self.sortedDiscussionComments)
//            self.sortedDiscussionComments.remove(at: indexpath1.row + 1)
//            print(self.sortedDiscussionComments)

                
//            print(discussionCommentUserDownvote)
//            discussionCommentUserDownvote.append(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
//            print(discussionCommentUserDownvote)
            
            
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

                            }
                        }
                
                        sharedComments[self.responseCommentsCollectionView.tag].commentReplies[indexpath1.row].discussionCommentReplyUpvotes = (sharedComments.map({$0.commentReplies})[self.responseCommentsCollectionView.tag].map({$0.discussionCommentReplyUpvotes})[indexpath1.row] - 1)


                        
                        
                        
                        
//                        self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row] - 1), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath1.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath1.row], discussionReplyCancelOrPost: ""), at: indexpath1.row)
//                        print(self.sortedDiscussionComments)
//                        self.sortedDiscussionComments.remove(at: indexpath1.row + 1)
//                        print(self.sortedDiscussionComments)
                        self.getVoteData()

                }
                            }}}
                
                
                
                var index = 0
                var i = 1
                print(discussionCommentUserDownvote.count)
                print(discussionCommentUserDownvote)
                    // print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
                while i < discussionCommentUserUpvote.count {
                    if discussionCommentUserUpvote[i] == sharedComments.map({$0.commentReplies})[responseCommentsCollectionView.tag].map({$0.discussionCommentReplyTitle})[indexpath1.row] {
                        index = i
                    }
                    i+=1
                }

                print(index)
                discussionCommentUserUpvote.remove(at: index)
                print(discussionCommentUserUpvote)
            }
            
            else {
                getVoteData()
            }
                
            
        
            
        
        
     
       
                //print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle}))

        
            
        
        
        
        }}
}

    
    
//    func setCollectionViewDelegate<D: UICollectionViewDelegate & UICollectionViewDataSource>(delegate: D, forRow row:Int) {
//        responseCommentsCollectionView.delegate = delegate
//        responseCommentsCollectionView.dataSource = delegate
//        responseCommentsCollectionView.tag = row
//        responseCommentsCollectionView.reloadData()
//    }
    


//extension DiscussionCommentsCollectionViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 300, height: 105)
//
//    }
//func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////    if collectionView.tag == 0 {
////        return 1
////    } else if collectionView.tag == 1 {
////        return 2
////    }
////    else {
////        return 3
////    }
////
//    print(sentComment)
//    print(sentIndex)
//    
//    print(collectionView.tag)
//    
//    
//    if sentComment.count > 0 {
//        if collectionView.tag == sentIndex {
//            return sentComment[0].commentReplies.count
//        }
//        else {
//            return 0
//        }
//
//    }
//    else {
//        return 0
//    }
////    print(sharedCommentReplies)
////    return sharedCommentReplies.count
//    }
////    print(specificReplies)
////    print(collectionView.tag)
////    print(specificReplies[collectionView.tag].commentReplies.count)
////    return specificReplies[collectionView.tag].commentReplies.count
//
//    
//
//
//
//func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "responseCommentsCollectionCell", for: indexPath) as? ResponseCommentsCollectionViewCell
//    cell!.layer.cornerRadius = 10
//    //cell?.responseReplyLabel.text = specificReplies[collectionView.tag].commentReplies.map({$0.discussionCommentReplyTitle})[indexPath.row]
////    cell?.responseReplyLabel.text = discussionCommentRepliesSortedList.map({$0.discussionCommentReplyTitle})[indexPath.row]
//    
//    return cell!
//}
//}
//
//
