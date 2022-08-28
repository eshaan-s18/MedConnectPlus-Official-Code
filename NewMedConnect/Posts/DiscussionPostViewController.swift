//
//  DiscussionPostViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 7/4/22.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

var discussionDocument = ""
var discussionCommentDocument = ""

var discussionCommentTitlesList = [String]()
var discussionCommentReplyReferenceComment = ""
var discussionCommentRepliesIndexPath = 0





struct DiscussionCommentReply {
    var discussCommentTitle:String
    var discussionCommentReplyTitle:String
    var discussionCommentReplyDate:Date
    var discussionCommentReplyDownvotes:Int
    var discussionCommentReplyUpvotes:Int
    var discussionReplyUsername:String
}

struct DiscussionComment {
    var discussionsCommentTitle:String
    var discussionCommentDate:Date
    var discussionCommentDownvotes:Int
    var discussionCommentUpvotes:Int
    var discussionCommentPopularity:Int
    var discussionUsername:String
    var discussionCommentRepliesOpen:Bool
    var commentReplies:[DiscussionCommentReply]
}


var discussionCommentRepliesSortedList = [DiscussionCommentReply]()
var filteredStruct = [DiscussionCommentReply]()

var sharedComments = [DiscussionComment]()

var sentCommentTitle = ""
var sentComment = [DiscussionComment]()
var sentIndex = 0


class DiscussionPostViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var q = 0
    var filterVals = [DiscussionCommentReply]()

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewInScrollView: UIView!
    
    @IBOutlet weak var viewInScrollViewHeightConstraint: NSLayoutConstraint!
    

    @IBOutlet weak var discussionTitleLabel: UILabel!
    
    @IBOutlet weak var discussionViewCount: UILabel!
    
    @IBOutlet weak var discussionCommentCount: UILabel!
    
    @IBOutlet weak var discussionDateLabel: UILabel!
    
    @IBOutlet weak var discussionUsernameLabel: UILabel!
    
    
    @IBOutlet weak var discussionView: UIView!
    
    @IBOutlet weak var informationView: UIView!
    
    @IBOutlet weak var responsesCollectionView: UICollectionView!
    
    @IBOutlet weak var responseRepliesCollectionView: UICollectionView!
    
    
    
    @IBOutlet weak var viewsOrDate: UIButton!
    var currentFilter = "Popularity"
    
    
    lazy var addCommentButton = UIBarButtonItem(image: UIImage(systemName: "plus.bubble"), style: .plain, target: self, action: #selector(addCommentTapped))
    
    let refreshControl = UIRefreshControl()
    
    var db = Firestore.firestore()
    
    var discussionComments = [String]()
    var discussionCommentDates = [String]()
    var discussionCommentDownvotes = [Int]()
    var discussionCommentUpvotes = [Int]()
    var discussionCommentUserUpvote = [String]()
    var discussionCommentUserDownvote = [String]()
    var discussionCommentPopularity = [Int]()
    var discussionUsername = [String]()
    var discussionCommentRepliesOpen = [Bool]()

    var discussionCommentsViewHeight = 0


    
    var unsortedDiscussionComments = [DiscussionComment]()
    var sortedDiscussionComments = [DiscussionComment]()
    var unsortedDiscussionCommentReplies = [DiscussionCommentReply]()
    var sortedDiscussionCommentReplies = [DiscussionCommentReply]()

    var dateFormatter = DateFormatter()

    var documentsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        



        getData()
        
        
        // Do any additional setup after loading the view.
        
        discussionTitleLabel.text = selectedDiscussion
        
        self.navigationItem.rightBarButtonItem = addCommentButton
        
        discussionView.layer.cornerRadius = 10
        informationView.layer.cornerRadius = 10
        
        discussionTitleLabel.sizeToFit()
        
        print(responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
        
//        self.viewInScrollViewHeightConstraint.constant = 220
//        self.viewInScrollView.layoutIfNeeded()
//
                
        

        navigationItem.title = "Posts"
        
        setPopupButton()
    }
    
    func setPopupButton(){
        let optionClosure = {(action: UIAction) in
            if action.title == "Popularity" {
                self.currentFilter = "Popularity"
                self.refresh()
            }
            else {
                self.currentFilter = "Date"
                self.refresh()
            }
        }
        viewsOrDate.menu = UIMenu(children: [
            UIAction(title : "Popularity", state: .on, handler: optionClosure),
            UIAction(title : "Date", handler: optionClosure)
        ])
        
        viewsOrDate.showsMenuAsPrimaryAction = true
        if #available(iOS 15.0, *) {
            viewsOrDate.changesSelectionAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
            print("RIP")
        }
    }
    
    @objc func refresh() {
        getData()
        
        self.responsesCollectionView.dataSource = self
        self.responsesCollectionView.delegate = self
        
        self.scrollView.refreshControl?.endRefreshing()

        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
           if segue.identifier == "addCommentSegue" {
               let popoverViewController = segue.destination
               popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
               popoverViewController.popoverPresentationController!.delegate = self
           }
       }
    
    @objc func addCommentTapped() {
        performSegue(withIdentifier: "addCommentSegue", sender: self)
    }
    

    func getData() {
        
        self.discussionComments = [String]()
        self.discussionCommentDates = [String]()
        self.discussionCommentDownvotes = [Int]()
        self.discussionCommentUpvotes = [Int]()
        self.discussionCommentUserUpvote = [String]()
        self.discussionCommentUserDownvote = [String]()
        self.discussionCommentPopularity = [Int]()
        self.discussionUsername = [String]()
        self.discussionCommentRepliesOpen = [Bool]()
        

        self.filterVals = [DiscussionCommentReply]()

        self.unsortedDiscussionComments = [DiscussionComment]()
        self.sortedDiscussionComments = [DiscussionComment]()
        self.unsortedDiscussionCommentReplies = [DiscussionCommentReply]()
        self.sortedDiscussionCommentReplies = [DiscussionCommentReply]()

        
        db.collection(conditionSelected).whereField("discussion", isEqualTo: selectedDiscussion)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        discussionDocument = document.documentID
                        print("\(document.documentID) => \(document.data())")
                        let docRefOne = self.db.collection(conditionSelected).document(document.documentID)
                        docRefOne.getDocument { (document, error) in

                            let result = Result {
                              try document?.data(as: Discussion.self)

                            }
                            print(result)
                            switch result {
                            case .success(let discussion):
                                if let discussion = discussion {
                                    // A `City` value was successfully initialized from the DocumentSnapshot.
                                    self.discussionTitleLabel.text = discussion.discussion
                                    
                                    
                                    let newDate = String(discussion.date![..<discussion.date!.index(discussion.date!.startIndex, offsetBy:10)])
                                    
                                    self.discussionDateLabel.text = newDate
                                    
                                    
                                    //self.questionLabel.text = question.question
                                    let newViews:String = String(Int(discussion.views!)! + 1)
                                    
                                    self.db.collection(conditionSelected).document(document!.documentID).updateData(["views": newViews])
                                    self.discussionViewCount.text = newViews + " views"
                                    self.discussionUsernameLabel.text = "User " + discussion.user!
                                    
                                    
                                    self.discussionComments = [String]()
                                    self.discussionCommentDates = [String]()
                                    self.discussionCommentDownvotes = [Int]()
                                    self.discussionCommentUpvotes = [Int]()
                                    self.discussionCommentUserUpvote = [String]()
                                    self.discussionCommentUserDownvote = [String]()
                                    self.discussionCommentPopularity = [Int]()
                                    
                                    self.unsortedDiscussionComments = [DiscussionComment]()
                                    self.sortedDiscussionComments = [DiscussionComment]()
                                    self.unsortedDiscussionCommentReplies = [DiscussionCommentReply]()
                                    self.sortedDiscussionCommentReplies = [DiscussionCommentReply]()

                                    
                                    self.db.collection(conditionSelected).document(discussionDocument).collection("comments").getDocuments() { (querySnapshot, err) in
                                            if let err = err {
                                                print("Error getting documents: \(err)")
                                            } else {
                                                
                                                self.documentsCount = (querySnapshot?.documents.count)!
                                                print(self.documentsCount)
                                                
                                                if self.documentsCount == 1 {
                                                    self.responsesCollectionView.isHidden = true
                                                }
                                                else {
                                                
                                                for document in querySnapshot!.documents {
                                                    var discussionCommentID = document.documentID
                                                    print("\(document.documentID) => \(document.data())")
                                                    let docRefOne = self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(discussionCommentID)
                                                    docRefOne.getDocument { [self] (document, error) in

                                                        let result = Result {
                                                          try document?.data(as: DiscussionComments.self)

                                                        }
                                                        print(result)
                                                        switch result {
                                                        case .success(let discussionComments):
                                                            if let discussionComments = discussionComments {
                                                                
                                                                
                                                                
                                                                // A `City` value was successfully initialized from the DocumentSnapshot.
                                                                if discussionCommentID == "0" {
                                                                    print("ok")
                                                                } else {
                                                                    
                                                                    var filteredCommentReplies = [DiscussionCommentReply]()

                                                                    
                                                                    
                                                                    self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(discussionCommentID).collection("replies")
                                                                        .getDocuments() { (querySnapshot, err) in
                                                                            if let err = err {
                                                                                print("Error getting documents: \(err)")
                                                                            } else {
                                                                                for document in querySnapshot!.documents {
                                                                                    print("\(document.documentID) => \(document.data())")
                                                                                    var replyDocument = document.documentID
                                                                                    
                                                                                    let docRefFour =  self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(discussionCommentID).collection("replies").document(replyDocument)

                                                                                    docRefFour.getDocument { [self] (document, error) in

                                                                                        let result = Result {
                                                                                          try document?.data(as: DiscussionResponseReplies.self)

                                                                                        }
                                                                                        print(result)
                                                                                        switch result {
                                                                                        case .success(let reply):
                                                                                            if let reply = reply {
                                                                                                // A `City` value was successfully initialized from the DocumentSnapshot.
                                                                                                
                                                                                                print("skip")
                                                                                                filterVals = [DiscussionCommentReply]()
                                                                                                if replyDocument != "0" {
                                                                                                    let newDateTwo = self.dateFormatter.date(from: reply.repliesDate!)
                                                                                                    self.unsortedDiscussionCommentReplies.append(DiscussionCommentReply.init(discussCommentTitle: reply.commentTitle!, discussionCommentReplyTitle: reply.repliesTitle!, discussionCommentReplyDate: newDateTwo!, discussionCommentReplyDownvotes: reply.repliesDownvotes!, discussionCommentReplyUpvotes: reply.repliesUpvotes!, discussionReplyUsername: reply.repliesUser!))
                                                                                                        //self.questionLabel.text = question.question
                                                                                                    print("okay")
                                                                                                    print(unsortedDiscussionCommentReplies)
                                                                                                                                                                                                        self.sortedDiscussionCommentReplies = self.unsortedDiscussionCommentReplies.sorted(by: {$0.discussionCommentReplyDate.compare($1.discussionCommentReplyDate) == .orderedDescending})
//                                                                                                    print(sortedDiscussionCommentReplies)
//                                                                                                                             self.responsesCollectionView.reloadData()
//                                                                                                                             self.responsesCollectionView.dataSource = self
//                                                                                                                             self.responsesCollectionView.delegate = self
 
                                                                                                    print(sortedDiscussionCommentReplies)
                                                                                                    
                                                                                                    var filteredCommentReplies = [DiscussionCommentReply]()
                                                                                                    
                                                                                                    filteredCommentReplies.append(sortedDiscussionCommentReplies.last!)
                                                                                                    
                                                                                                    print(filteredCommentReplies)
                                                                                                    
                                                                                                    filterVals = filteredCommentReplies
                                                                                                }
                                                                                                
                                                                                                var titles = [String]()
                                                                                                if unsortedDiscussionComments.count > 0 {
                                                                                                    var w = 0
                                                                                                    while w < unsortedDiscussionComments.count {
                                                                                                        titles.append(unsortedDiscussionComments[w].discussionsCommentTitle)
                                                                                                        w+=1
                                                                                                    }
                                                                                                }
                                                                                                
                                                                                                print(titles)
                                                                                                print(filterVals)
                                                                                                print(discussionComments.commentTitle)
                                                                                                if unsortedDiscussionComments.count > 0 && titles.contains(discussionComments.commentTitle!) && filteredCommentReplies.isEmpty {
                                                                                                    
                                                                                                    var z = 0
                                                                                                    print(unsortedDiscussionComments.count)
                                                                                                    while z < unsortedDiscussionComments.count {
                                                                                                        if unsortedDiscussionComments[z].discussionsCommentTitle == discussionComments.commentTitle! {
                                                                                                            unsortedDiscussionComments[z].commentReplies.append(contentsOf: filterVals)
                                                                                                            
                                                                                                        }
                                                                                                        z+=1
                                                                                                    }
                                                                                                }
                                                                                                else {
                                                                                                    let newDate = self.dateFormatter.date(from: discussionComments.date!)
                                                                                                    self.unsortedDiscussionComments.append(DiscussionComment.init(discussionsCommentTitle: discussionComments.commentTitle!, discussionCommentDate: newDate!, discussionCommentDownvotes: discussionComments.downvotes!, discussionCommentUpvotes: discussionComments.upvotes!, discussionCommentPopularity: discussionComments.upvotes! - discussionComments.downvotes!, discussionUsername: discussionComments.user!, discussionCommentRepliesOpen: false, commentReplies: filterVals))
                                                                                                }
                                                                                                    
                                                                                                    print(sortedDiscussionCommentReplies)
                                                                                                    print(unsortedDiscussionComments)
                                                                                                //self.questionLabel.text = question.question
                                                                                                    print(unsortedDiscussionComments.count)
                                                                                                    print(self.documentsCount)
                                                                                                
                            //                                                                    if self.unsortedDiscussionComments.count == self.documentsCount - 1 {
                                                                                                
                                                                                                if self.currentFilter == "Popularity" {
                                                                                                    
                                                                                                    self.sortedDiscussionComments = self.unsortedDiscussionComments.sorted(by: {$0.discussionCommentPopularity > $1.discussionCommentPopularity})
                                                                                                                                                                                                   }
                                                                                                else {
                                                                                                    self.sortedDiscussionComments = self.unsortedDiscussionComments.sorted(by: {$0.discussionCommentDate.compare($1.discussionCommentDate) == .orderedDescending})
                                                                                                }
                                                                                                    discussionCommentRepliesSortedList = sortedDiscussionCommentReplies
                                                                                                
                                                                                                
                                                                                                
                                                                                                self.viewInScrollViewHeightConstraint.constant = 2000
                                                                                                self.viewInScrollView.layoutIfNeeded()
                                                                                                
                                                                                                print(discussionCommentID)
                                                                                                print(documentsCount - 1)
                                                                                                print(sortedDiscussionComments)
                                                                                                if unsortedDiscussionComments.count == documentsCount - 1 {
                                                                                                    print(sortedDiscussionComments)
                                                                                                    self.responsesCollectionView.reloadData()
                                                                                                    self.responsesCollectionView.dataSource = self
                                                                                                    self.responsesCollectionView.delegate = self
                                                                                                }
                                                                                                
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
                                                                                
                                                                                if unsortedDiscussionCommentReplies.count == 1{
                                                                                    
                                                                                }
                                                                               
                                                                            }
                                                                            
                                                                            
                                                                    }
                                                                    
                                                                    
                                                                    
                                                                    
                                                             
                                                                    
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
                                                                                let docRefThree = db.collection("Users").document(Auth.auth().currentUser!.uid)
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
                                                                                            
                                                                                            var i = 0
                                                                                            while i < self.sortedDiscussionComments.map({$0.discussionsCommentTitle}).count {
                                                                                            
                                                                                                discussionCommentTitlesList.append(self.self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[i])
                                                                                                i+=1
                                                                                            }
                                                                                                                                                                                        
                                                                                            print(responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
                                                                                            
//                                                                                            self.viewInScrollViewHeightConstraint.constant = 220 + responsesCollectionView.collectionViewLayout.collectionViewContentSize.height
//                                                                                            self.viewInScrollView.layoutIfNeeded()
//
//
//
//                                                                                            self.responsesCollectionView.reloadData()
//                                                                                            self.responsesCollectionView.dataSource = self
//                                                                                            self.responsesCollectionView.delegate = self
                                                                                            
                                                                                            //self.questionLabel.text = question.question
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
                                                                                
                                                                                
                                                                                
                                                                                //self.questionLabel.text = question.question
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
                                                                    
                                                                    
                                                                    
                                                    
                                                                    
                                                                    self.discussionCommentCount.text = String(self.sortedDiscussionComments.map({$0.discussionsCommentTitle}).count)
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    

                                                                    
                                                                    
                                                                    
                                                                        
                                                                   
                                                                        print("okay")
                                                                    
//                                                                }
                                                                }
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
                                                }
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
                }
        }
        
        
        
        
            }
    
    
    
    
    
    
}
        
        
extension DiscussionPostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 350, height: 105)
        }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "responsesCell", for: indexPath) as? DiscussionCommentsCollectionViewCell{
//
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        sharedComments = sortedDiscussionComments
        
        return (self.sortedDiscussionComments.map({$0.discussionsCommentTitle}).count)
        
        
        }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "responsesCell", for: indexPath) as? DiscussionCommentsCollectionViewCell
//
//        print(indexVal)
//        print(sortedDiscussionComments.count)
//        print(indexPath.row)
//        print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row])
//        if indexVal < sortedDiscussionComments.count {
//            cell?.responseCommentsCollectionView.tag = indexPath.row
//            indexVal+=1
//            print(discussionCommentRepliesSortedList)
//            print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row])
//            print(discussionCommentRepliesSortedList.filter({$0.discussCommentTitle == self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row]}))
//            specificReplies.insert((RepliesStruct.init(commentReplies: discussionCommentRepliesSortedList.filter({$0.discussCommentTitle == self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row]}))), at: indexPath.row)
//            specificReplies.remove(at: indexPath.row + 1)
//        }
//
//
//
        
        

    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "responsesCell", for: indexPath) as? DiscussionCommentsCollectionViewCell

        cell?.responseCommentsCollectionView.reloadData()
        
        cell?.commentLabel.text = self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row]
        
        cell?.upHeartLabel.text = String(self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexPath.row])
        
        cell?.cellUsername.text = "User " + String(self.sortedDiscussionComments.map({$0.discussionUsername})[indexPath.row])
        discussionCommentRepliesIndexPath = indexPath.row
        print(sortedDiscussionComments)
        print(indexPath.row)
        print(sortedDiscussionComments[indexPath.row])
        print(self.sortedDiscussionComments.map({$0.commentReplies})[indexPath.row])
        
        if q < sortedDiscussionComments.count {
            cell?.responseCommentsCollectionView.tag = indexPath.row
            q+=1
        }
        
        sentCommentTitle = self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row]
        
        
        //
        if cell?.commentLabel.text == "Hello" {
            cell!.responseCommentsCollectionView.tag = 2

        }
        else {
            cell!.responseCommentsCollectionView.tag = 0

        }
        
        
        
//        discussionCommentRepliesFilterList.insert(contentsOf: filteredStruct, at: indexPath.row - 1)
        

        
        
        if self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexPath.row] == true {
            cell?.responseCommentsViewHeightConstraint.constant = (cell?.responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height)!
            cell?.responseCommentsView.layoutIfNeeded()

        }
        else {
            cell?.responseCommentsViewHeightConstraint.constant = 0.0
            cell?.responseCommentsView.layoutIfNeeded()
        }
//        cell?.downHeartLabel.text = String(self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexPath.row])
//
//       var displayedDate = sortedDiscussionComments.map({dateFormatter.string(from:$0.discussionCommentDate)})
//
//        cell?.commentDateLabel.text = String(displayedDate[indexPath.row][..<displayedDate[indexPath.row].index(displayedDate[indexPath.row].startIndex, offsetBy:10)])
//
//        cell?.upHeartLabel.text = String(self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexPath.row])
        
        var displayedDate = sortedDiscussionComments.map({dateFormatter.string(from:$0.discussionCommentDate)})
                
//            var dateDisplayed:String = String(self.sortedDiscussions!.map({dateFormatter!.string(from:$0.discussionDates!)!}!)!)! ?? ""

        cell?.commentDateLabel.text = String(displayedDate[indexPath.row][..<displayedDate[indexPath.row].index(displayedDate[indexPath.row].startIndex, offsetBy:10)])
        
//
        cell?.commentLabel.sizeToFit()
        cell?.commentLabel.numberOfLines = 0
        
        cell?.corneredView.layer.cornerRadius = 10
        cell?.upHeartView.layer.cornerRadius = 10
        cell?.downHeartView.layer.cornerRadius = 10
        
        print(discussionCommentUserUpvote)

        if self.discussionCommentUserUpvote.contains((cell?.commentLabel.text)!) {
            cell?.upHeartImage.image = UIImage(systemName: "arrow.up.heart.fill")
            cell?.upHeartView.backgroundColor = UIColor.white
            
        }
        else {
            cell?.upHeartImage.image = UIImage(systemName: "arrow.up.heart")
            cell?.upHeartView.backgroundColor = UIColor.systemGray6


        }
        
        print(discussionCommentUserDownvote)
        
        if self.discussionCommentUserDownvote.contains((cell?.commentLabel.text)!) {
            cell?.downHeartImage.image = UIImage(systemName: "arrow.down.heart.fill")
            cell?.downHeartView.backgroundColor = UIColor.white

        }
        else {
            cell?.downHeartImage.image = UIImage(systemName: "arrow.down.heart")
            cell?.downHeartView.backgroundColor = UIColor.systemGray6
        }

        cell?.repliesButton.addTarget(self, action: #selector(repliesButtonTapped(sender:)), for: .touchUpInside)
        cell?.repliesButton.tag = indexPath.row
        discussionCommentRepliesIndexPath = (cell?.repliesButton.tag)!
        
        
        cell?.upHeartButton.addTarget(self, action: #selector(upheartTapped(sender:)), for: .touchUpInside)
        cell?.downHeartButton.addTarget(self, action: #selector(downheartTapped(sender:)), for: .touchUpInside)
        
        cell?.upHeartButton.tag = indexPath.row
        cell?.downHeartButton.tag = indexPath.row
        cell?.upHeartImage.tag = indexPath.row
        cell?.downHeartImage.tag = indexPath.row


        
        
        
        cell?.backgroundColor = UIColor.white
        cell?.layer.cornerRadius = 10
        
        return cell!
    }
    @objc func repliesButtonTapped(sender:UIButton) {
        
        
        let indexPath2 = IndexPath(row: sender.tag, section: 0)
        
        if self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexPath2.row] == false {
            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath2.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexPath2.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexPath2.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexPath2.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexPath2.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexPath2.row], discussionCommentRepliesOpen: true, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexPath2.row]), at: indexPath2.row)
            
            print(self.sortedDiscussionComments)
            self.sortedDiscussionComments.remove(at: indexPath2.row + 1)
            print(self.sortedDiscussionComments)
            print(indexPath2.row)
            
            sentComment = [DiscussionComment]()
            sentComment.append(sortedDiscussionComments[indexPath2.row])
            print(sentComment)
            
            sentIndex = indexPath2.row

            self.responsesCollectionView.reloadData()
//            self.responsesCollectionView.dataSource = self
//            self.responsesCollectionView.delegate = self
            
            print(responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
            discussionCommentsViewHeight += 100
            
            self.viewInScrollViewHeightConstraint.constant = 2000
            self.viewInScrollView.layoutIfNeeded()
            
           

        }
        else {
            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath2.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexPath2.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexPath2.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexPath2.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexPath2.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexPath2.row], discussionCommentRepliesOpen: false, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexPath2.row]), at: indexPath2.row)
            
            print(self.sortedDiscussionComments)
            self.sortedDiscussionComments.remove(at: indexPath2.row + 1)
            print(self.sortedDiscussionComments)
            print(indexPath2.row)

            self.responsesCollectionView.reloadData()

            
            print(responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
            discussionCommentsViewHeight -= 100
            
            self.viewInScrollViewHeightConstraint.constant = 2000
            self.viewInScrollView.layoutIfNeeded()
            sentComment = [DiscussionComment]()
            
        }
        
    }
    
    @objc func upheartTapped(sender:UIButton) {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        
        if self.discussionCommentUserUpvote.contains((self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])) {
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                "upvotes": FieldValue.arrayRemove([self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row]
                                                ])])
            
            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            self.self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                "upvotes": (Int(self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row]) - 1)
                                
                                
                            ])
                            
                        }
                        
                    }
                
                    
                    self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row] - 1), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: false, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row]), at: indexpath1.row)
                    print(self.sortedDiscussionComments)
                    self.sortedDiscussionComments.remove(at: indexpath1.row + 1)
                    print(self.sortedDiscussionComments)
                    print(indexpath1.row)

                    self.responsesCollectionView.reloadData()
                    self.responsesCollectionView.dataSource = self
                    self.responsesCollectionView.delegate = self

            }
            
            var index = 0
            var i = 1
            print(discussionCommentUserUpvote.count)
            print(discussionCommentUserUpvote)
            print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
            while i < discussionCommentUserUpvote.count {
                if discussionCommentUserUpvote[i] == self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row] {
                    index = i
                }
                i+=1
            }
            
            print(index)
            discussionCommentUserUpvote.remove(at: index)
            print(discussionCommentUserUpvote)
            
            
        }
        
        else {
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["upvotes": FieldValue.arrayUnion([self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row]
                                                ])])
                
            print(discussionCommentUserUpvote)
            discussionCommentUserUpvote.append(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
            print(discussionCommentUserUpvote)
            
            
            
            
            
            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            self.self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                "upvotes": (Int(self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row]))
                            ])
                        }
                    }
            }
            

            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row] + 1), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: false, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row]), at: indexpath1.row)
            print(self.sortedDiscussionComments)
            print(self.sortedDiscussionComments)
            self.sortedDiscussionComments.remove(at: indexpath1.row + 1)
            print(self.sortedDiscussionComments)
            print(indexpath1.row)

            if self.discussionCommentUserDownvote.contains((self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])) {
                self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                    "downvotes": FieldValue.arrayRemove([self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row]
                                                        ])])
                
                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                
                                self.self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                    "downvotes": (Int(self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row])-1)
                                ])
                                
                            }
                        }
                        
                        
                        self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row] - 1, discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: false, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row]), at: indexpath1.row)
                        print(self.sortedDiscussionComments)
                        self.sortedDiscussionComments.remove(at: indexpath1.row + 1)
                        print(self.sortedDiscussionComments)

                        self.responsesCollectionView.reloadData()
                        self.responsesCollectionView.dataSource = self
                        self.responsesCollectionView.delegate = self
                        
                }
                
                var index = 0
                var i = 1
                print(discussionCommentUserDownvote.count)
                print(discussionCommentUserDownvote)
                print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
                while i < discussionCommentUserDownvote.count {
                    if discussionCommentUserDownvote[i] == self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row] {
                        index = i
                    }
                    i+=1
                }
                
                print(index)
                discussionCommentUserDownvote.remove(at: index)
                print(discussionCommentUserDownvote)
            
            
            }
            
            else {
                self.responsesCollectionView.reloadData()
                self.responsesCollectionView.dataSource = self
                self.responsesCollectionView.delegate = self
            }
               
            
        
            
        
        
     
       
        print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle}))

        
            
        
        
        
    }
    }
    
    @objc func downheartTapped(sender:UIButton) {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        
        if self.discussionCommentUserDownvote.contains((self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])) {
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                "downvotes": FieldValue.arrayRemove([self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row]
                                                ])])
            
            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            self.self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                "downvotes": (Int(self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row] - 1))
                            ])
                            
                        }
                    }
                    
                    
                    
                    self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row] - 1, discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: false, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row]), at: indexpath1.row)
                    print(self.sortedDiscussionComments)
                    self.sortedDiscussionComments.remove(at: indexpath1.row + 1)
                    print(self.sortedDiscussionComments)

                    self.responsesCollectionView.reloadData()
                    self.responsesCollectionView.dataSource = self
                    self.responsesCollectionView.delegate = self
            }
            
            var index = 0
            var i = 1
            print(discussionCommentUserDownvote.count)
            print(discussionCommentUserDownvote)
            print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
            while i < discussionCommentUserDownvote.count {
                if discussionCommentUserDownvote[i] == self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row] {
                    index = i
                }
                i+=1
            }
            
            print(index)
            discussionCommentUserDownvote.remove(at: index)
            print(discussionCommentUserDownvote)
            
            
        }
        
        else {
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["downvotes": FieldValue.arrayUnion([self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row]
                                                ])])
            
            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            self.self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                "downvotes": (Int(self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row]))
                            ])
                        }
                    }
            }
            
            
            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row] + 1, discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: false, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row]), at: indexpath1.row)
            print(self.sortedDiscussionComments)
            self.sortedDiscussionComments.remove(at: indexpath1.row + 1)
            print(self.sortedDiscussionComments)

                
            print(discussionCommentUserDownvote)
            discussionCommentUserDownvote.append(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
            print(discussionCommentUserDownvote)
            
            
            if self.discussionCommentUserUpvote.contains((self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])) {
                self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                    "upvotes": FieldValue.arrayRemove([self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row]
                                                    ])])
                
                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                
                                self.self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                    "upvotes": (Int(self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row] - 1))
                                   
                                ])
                                
                            }
                        }
                        
                        
                        self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row] - 1), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: false, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row]), at: indexpath1.row)
                        print(self.sortedDiscussionComments)
                        self.sortedDiscussionComments.remove(at: indexpath1.row + 1)
                        print(self.sortedDiscussionComments)

                        self.responsesCollectionView.reloadData()
                        self.responsesCollectionView.dataSource = self
                        self.responsesCollectionView.delegate = self
                        
                }
                
                var index = 0
                var i = 1
                print(discussionCommentUserUpvote.count)
                print(discussionCommentUserUpvote)
                print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row])
                while i < discussionCommentUserUpvote.count {
                    if discussionCommentUserUpvote[i] == self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row] {
                        index = i
                    }
                    i+=1
                }
                
                print(index)
                discussionCommentUserUpvote.remove(at: index)
                print(discussionCommentUserUpvote)
            }
            
            else {
                self.responsesCollectionView.reloadData()
                self.responsesCollectionView.dataSource = self
                self.responsesCollectionView.delegate = self
            }
                
            
        
            
        
        
     
       
        print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle}))

        
            
        
        
        
        }}

    
    
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    

