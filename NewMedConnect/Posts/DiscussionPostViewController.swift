//
//  DiscussionPostViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 7/4/22.
//


import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore
import BLTNBoard

var sharedDiscussionUser = ""

var replyIndex = 0

var countNum = -1

var whichTextField = ""

var reportedPost = "Nil"
var reportedDiscussion = ""
var reportedDiscussionReply = ""

var discussionDocument = ""
var discussionCommentDocument = ""

var discussionCommentTitlesList = [String]()
var discussionCommentReplyReferenceComment = ""
var discussionCommentRepliesIndexPath = 0

var selectedTextFieldCount = 0

var repliesCollectionHeight = 0

var replyTextFieldVal = ""

var sharedDiscussionCommentUserRace:String = ""
var sharedDiscussionCommentUserBirthday:String = ""
var sharedDiscussionCommentUserCountry:String = ""
var sharedDiscussionCommentUserGender:String = ""
var sharedDiscussionCommentUserAge:Int = 0







var pointX:CGFloat = 0.00
var pointY:CGFloat = 0.00

struct DiscussionCommentReply {
    var discussCommentTitle:String
    var discussionCommentReplyTitle:String
    var discussionCommentReplyDate:Date
    var discussionCommentReplyDownvotes:Int
    var discussionCommentReplyUpvotes:Int
    var discussionReplyUsername:String
    var discussionReplyButtonTapped:Bool
    var discussionReplyCancelorPost:String
    
    var discussionReplyGenderUpvotes:[Int]
    var discussionReplyAgeUpvotes:[Int]
    var discussionReplyRaceUpvotes:[Int]
    var discussionReplyCountry:[String]
    var discussionReplyCountryUpvotes:[Int]
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
    var discussionReplyButtonTapped:Bool
    var discussionReplyCancelOrPost:String
    
    var discussionCommentGenderUpvotes:[Int]
    var discussionCommentAgeUpvotes:[Int]
    var discussionCommentRaceUpvotes:[Int]
    var discussionCommentCountry:[String]
    var discussionCommentCountryUpvotes:[Int]
}


var discussionCommentRepliesSortedList = [DiscussionCommentReply]()
var filteredStruct = [DiscussionCommentReply]()

var sharedComments = [DiscussionComment]()

var sentCommentTitle = ""
var sentComment = [DiscussionComment]()
var sentIndex = 0

var mutatedTitle = NSMutableAttributedString()


class DiscussionPostViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var q = 0
    var filterVals = [DiscussionCommentReply]()

    var commentsCount = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewInScrollView: UIView!
    
    @IBOutlet weak var viewInScrollViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sortedByLabel: UILabel!
    
    @IBOutlet weak var noResponsesLabel: UILabel!
    
    @IBOutlet weak var discussionTitleLabel: UILabel!
    
    @IBOutlet weak var discussionViewCount: UILabel!
    
    @IBOutlet weak var discussionCommentCount: UILabel!
    
    @IBOutlet weak var discussionDateLabel: UILabel!
    
    @IBOutlet weak var discussionUsernameLabel: UILabel!
    
    
    @IBOutlet weak var discussionView: UIView!
    
    @IBOutlet weak var informationView: UIView!
    
    @IBOutlet weak var responsesCollectionView: UICollectionView!
    
    @IBOutlet weak var responseRepliesCollectionView: UICollectionView!
    
    @IBOutlet weak var responsesCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewInScrollViewHeight = 0
    
    var unsortedDiscussionComments = [DiscussionComment]()
    var sortedDiscussionComments = [DiscussionComment]()
    var unsortedDiscussionCommentReplies = [DiscussionCommentReply]()
    var sortedDiscussionCommentReplies = [DiscussionCommentReply]()
    
    @IBOutlet weak var viewsOrDate: UIButton!
    
    
    @IBOutlet weak var deleteOrFlag: UIButton!
    
    
    var currentFilter = "Popularity"
    
    var closeRepliesView = false
    
    
    lazy var addCommentButton = UIBarButtonItem(image: UIImage(systemName: "plus.bubble"), style: .plain, target: self, action: #selector(addCommentTapped))
    
    let refreshControl = UIRefreshControl()
    
    var db = Firestore.firestore()
    
    var discussionComments = [String]()
    var discussionCommentDates = [String]()
    var discussionCommentDownvotes = [Int]()
    var discussionCommentUpvotes = [Int]()
    
    var discussionCommentUserUpvote = [String]()
    var discussionCommentUserDownvote = [String]()
    
    var discussionCommentUserRace:String = ""
    var discussionCommentUserBirthday:String = ""
    var discussionCommentUserCountry:String = ""
    var discussionCommentUserGender:String = ""
    var discussionCommentUserAge:Int = 0

    
    
    
    var discussionCommentPopularity = [Int]()
    var discussionUsername = [String]()
    var discussionCommentRepliesOpen = [Bool]()
    var discussionReplyButtonTapped = [Bool]()
    var discussionReplyCancelOrPost = [String]()
    
    var discussionCommentGenderUpvotes = [[Int]]()
    var discussionCommentAgeUpvotes = [[Int]]()
    var discussionCommentRaceUpvotes = [[Int]]()
    var discussionCommentCountry = [[String]]()
    var discussionCommentCountryUpvotes = [[Int]]()

    var discussionCommentsViewHeight = 0

    var cancelKeyboardIndicator = false

    var iCount = 0
    
    var keyboardHeight = 0.00


    var dateFormatter = DateFormatter()

    var documentsCount = 0
    

    
    var totalScroll = 295
    
    var replyOpenCount = 0
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noResponsesLabel.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))


        getData()
        
        
        // Do any additional setup after loading the view.
        
        discussionTitleLabel.text = selectedDiscussion
        
        self.navigationItem.rightBarButtonItem = addCommentButton
        
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor.systemGray6
        discussionView.layer.cornerRadius = 10
        informationView.layer.cornerRadius = 10
        
        discussionTitleLabel.sizeToFit()
        
        print(responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
        
//        self.viewInScrollViewHeightConstraint.constant = 220
//        self.viewInScrollView.layoutIfNeeded()
//
                
        navigationItem.title = "Posts"
        
        setPopupButton()
        
//        responsesCollectionViewHeightConstraint.constant = responsesCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        
        deleteOrFlag.showsMenuAsPrimaryAction = true
        
        
    }
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    @objc func reportCommentButtonTapped() {
        var reportResponseVC = UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "ReportResponseViewController")
        if let sheet = reportResponseVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 25
            
        }

        self.present(reportResponseVC, animated: true, completion: nil)

    }
    
   
    
    
    @objc private func hideKeyboard() {
        print(keyboardHeight)
        self.viewInScrollViewHeightConstraint.constant -= keyboardHeight

        self.view.endEditing(true)
        
      
//        self.viewInScrollViewHeightConstraint.constant += 50
        //self.scrollView.contentOffset.y = 200
//        self.view.frame.origin.y = -256
//        print(viewInScrollView.frame.height)
//        let initial = -(self.discussionView.bounds.size.height + self.informationView.bounds.size.height + 84 + responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
//        print(self.discussionView.bounds.size.height + self.informationView.bounds.size.height + 84 + responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
//        print((selectedTextFieldCount * 115) - totalScroll)
//        scrollView.setContentOffset(CGPoint(x: 0, y:initial + (13 * 115) - 31), animated: true)

        
        
//        self.viewInScrollViewHeightConstraint.constant = self.discussionView.bounds.size.height + self.informationView.bounds.size.height + 84 + responsesCollectionView.collectionViewLayout.collectionViewContentSize.height
//        self.view.frame.origin.y = 0
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
                }
        
        cancelKeyboardIndicator = true
        
//        self.viewInScrollViewHeightConstraint.constant += 50
        //self.scrollView.contentOffset.y = 200
//        self.view.frame.origin.y = -256
//        print(viewInScrollView.frame.height)
//        let initial = -(self.discussionView.bounds.size.height + self.informationView.bounds.size.height + 84 + responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
//        print(self.discussionView.bounds.size.height + self.informationView.bounds.size.height + 84 + responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
//        print((selectedTextFieldCount * 115) - totalScroll)
//        scrollView.setContentOffset(CGPoint(x: 0, y:initial + (13 * 115) - 31), animated: true)

        print(keyboardHeight)
        
        self.viewInScrollViewHeightConstraint.constant += keyboardHeight
        
        
//        //UNCOMMENT THIS
//        if whichTextField == "comment" {
//
//            let totalHeight = (viewInScrollView.window?.windowScene?.screen.bounds.height)!
//            let navHeight = navigationController?.navigationBar.frame.size.height
//            print(pointY)
//            scrollView.setContentOffset(CGPoint(x: 0, y: pointY - 375), animated: true)
//            print(viewInScrollView.window?.windowScene?.screen.bounds.height)
//            print(keyboardHeight)        }
//        else if whichTextField == "commentReply" {
//            let commentDisplacement = 140 * (replyIndex + 1)
//            var offset = 0
//            if replyIndex+1 != 1{
//                offset = 20 * (replyIndex+1)
//            }
//            scrollView.setContentOffset(CGPoint(x: 0, y: Int(pointY) - 375 + commentDisplacement + 30 - offset), animated: true)
//


            
            //scrollView.setContentOffset(CGPoint(x: 0, y: pointY), animated: true)




        
        


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
            print("Version Error")
        }
    }
    
    @objc func refresh() {
        viewInScrollViewHeight = 0
        
        iCount = 0
        getData()
        
        self.responsesCollectionView.dataSource = self
        self.responsesCollectionView.delegate = self
        
        self.scrollView.refreshControl?.endRefreshing()
        
        self.view.frame.origin.y = 0

        
        
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
        commentsCount = 0
        self.discussionComments = [String]()
        self.discussionCommentDates = [String]()
        self.discussionCommentDownvotes = [Int]()
        self.discussionCommentUpvotes = [Int]()
        self.discussionCommentUserUpvote = [String]()
        self.discussionCommentUserDownvote = [String]()
        self.discussionCommentPopularity = [Int]()
        self.discussionUsername = [String]()
        self.discussionCommentRepliesOpen = [Bool]()
        self.discussionReplyButtonTapped = [Bool]()
        self.discussionReplyCancelOrPost = [String]()
        
        self.discussionCommentGenderUpvotes = [[Int]]()
        self.discussionCommentAgeUpvotes = [[Int]]()
        self.discussionCommentRaceUpvotes = [[Int]]()
        self.discussionCommentCountry = [[String]]()
        self.discussionCommentCountryUpvotes = [[Int]]()
        

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
                    if querySnapshot!.documents.count == 0 {
                        self.navigationController?.popViewController(animated: true)


                        let alert = UIAlertController(title: "Error: Discussion post not found", message: "Please refresh discussion page", preferredStyle: .alert)
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
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
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
                                    
                                    sharedDiscussionUser = discussion.user!
                                    
                                    self.discussionUsernameLabel.text = "User " + discussion.user!
                                    
                                    
                                    var delimeter = " "
                                    var usernameLabel = self.discussionUsernameLabel.text
                                    let newUsernameLabel = usernameLabel?.components(separatedBy: delimeter)
                                    print(newUsernameLabel![1])
                                    
                                    self.deleteOrFlag.showsMenuAsPrimaryAction = true
                                    
                                    if newUsernameLabel![1] == Auth.auth().currentUser!.uid {
                                        self.deleteOrFlag.menu = UIMenu(children: [
                                            UIAction(title: "Delete Response",image: UIImage(systemName: "trash"), handler: { action in
                                                self.db.collection(conditionSelected).whereField("discussion", isEqualTo: selectedDiscussion).getDocuments() { (querySnapshot, err) in
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
                                                        
                                                        self.present(alert, animated: true, completion: nil)
                                                    } else {
                                                        for document in querySnapshot!.documents {
                                                            

                                                            print("\(document.documentID) => \(document.data())")

                                                            self.db.collection(conditionSelected).document(document.documentID).updateData(["discussion" : " "])
                                                            
                                                            print(selectedDiscussion)
                                                            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("discussions").whereField("yourDiscussionTitle", isEqualTo: selectedDiscussion)
                                                                .getDocuments() { (querySnapshot, err) in
                                                                    if let err = err {
                                                                        print("Error getting documents: \(err)")
                                                                    } else {
                                                                        for document in querySnapshot!.documents {
                                                                            print("\(document.documentID) => \(document.data())")
                                                                            
                                                                            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("discussions").document(document.documentID).updateData(["yourDiscussionTitle": " "])
                                                                            
                                                                            let alert = UIAlertController(title: "Successfully Deleted🗑", message: "Please refresh discussion page", preferredStyle: .alert)
                                                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                                                switch action.style{
                                                                                    case .default:
                                                                                    print("default")
                                                                                    self.navigationController?.popViewController(animated: true)



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
                                                    }
                                            }
                                            
                                        })
                                    ])
                                }
                                else {
                                    self.deleteOrFlag.menu = UIMenu(children: [
                                        
                                        UIAction(title: "Report Post",image: UIImage(systemName: "flag"), handler: { action in
                                            reportedPost = selectedDiscussion

                                            reportedDiscussion = "Nil"
                                            reportedDiscussionReply = "Nil"

                                            self.reportCommentButtonTapped()
                                            
                                        })
                                    ])
                                }
                                    
                                    
                                    
                                    self.discussionComments = [String]()
                                    self.discussionCommentDates = [String]()
                                    self.discussionCommentDownvotes = [Int]()
                                    self.discussionCommentUpvotes = [Int]()
                                    self.discussionCommentUserUpvote = [String]()
                                    self.discussionCommentUserDownvote = [String]()
                                    self.discussionCommentPopularity = [Int]()
                                    self.discussionUsername = [String]()
                                    self.discussionCommentRepliesOpen = [Bool]()
                                    self.discussionReplyButtonTapped = [Bool]()
                                    self.discussionReplyCancelOrPost = [String]()
                                                                        
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
                                                    self.noResponsesLabel.isHidden = false
                                                    self.viewsOrDate.isHidden = true
                                                    self.sortedByLabel.isHidden = true
                                                    self.activityIndicator.stopAnimating()

                                                    
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
                                                                                print(querySnapshot?.documents.count)
                                        
                                                                                commentsCount+=(querySnapshot?.documents.count)!
                                                                                for document in querySnapshot!.documents {
                                                                                    
                                                                                    print("\(document.documentID) => \(document.data())")
                                                                                    var replyDocument = document.documentID
                                                                                    
                                                                                    print(replyDocument)
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
                                                                                                print(reply.repliesTitle)
                                                                                                print("skip")
                                                                                                filterVals = [DiscussionCommentReply]()
                                                                                                if replyDocument != "0" {
                                                                                                    let newDateTwo = self.dateFormatter.date(from: reply.repliesDate!)
                                                                                                    self.unsortedDiscussionCommentReplies.append(DiscussionCommentReply.init(discussCommentTitle: reply.commentTitle!, discussionCommentReplyTitle: reply.repliesTitle!, discussionCommentReplyDate: newDateTwo!, discussionCommentReplyDownvotes: reply.repliesDownvotes!, discussionCommentReplyUpvotes: reply.repliesUpvotes!, discussionReplyUsername: reply.repliesUser!, discussionReplyButtonTapped: false, discussionReplyCancelorPost: "", discussionReplyGenderUpvotes: reply.genderUpvotes!, discussionReplyAgeUpvotes: reply.ageUpvotes!, discussionReplyRaceUpvotes: reply.raceUpvotes!, discussionReplyCountry: reply.country!, discussionReplyCountryUpvotes: reply.countryUpvotes!))
                                                                                                        //self.questionLabel.text = question.question
                                                                                                    print("okay")
                                                                                                    print(unsortedDiscussionCommentReplies)
                                                                                                                                                                                                        

 
                                                                                                    print(sortedDiscussionCommentReplies)
                                                                                                    
                                                                                                    var filteredCommentReplies = [DiscussionCommentReply]()
                                                                                                    
                                                                                                    filteredCommentReplies.append(unsortedDiscussionCommentReplies.last!)
                                                                                                    
                                                                                                    self.sortedDiscussionCommentReplies = self.unsortedDiscussionCommentReplies.sorted(by: {$0.discussionCommentReplyDate.compare($1.discussionCommentReplyDate) == .orderedDescending})
                                                                                                    
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
                                                                                                    
                                                                                                    print(unsortedDiscussionComments)
                                                                                                    let newDate = self.dateFormatter.date(from: discussionComments.date!)
                                                                                                    self.unsortedDiscussionComments.append(DiscussionComment.init(discussionsCommentTitle: discussionComments.commentTitle!, discussionCommentDate: newDate!, discussionCommentDownvotes: discussionComments.downvotes!, discussionCommentUpvotes: discussionComments.upvotes!, discussionCommentPopularity: discussionComments.upvotes! - discussionComments.downvotes!, discussionUsername: discussionComments.user!, discussionCommentRepliesOpen: false, commentReplies: filterVals, discussionReplyButtonTapped: false, discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: discussionComments.genderUpvotes!, discussionCommentAgeUpvotes: discussionComments.ageUpvotes!, discussionCommentRaceUpvotes: discussionComments.raceUpvotes!, discussionCommentCountry: discussionComments.country!, discussionCommentCountryUpvotes: discussionComments.countryUpvotes!))
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
                                                                                                
                                                                                                
                                                                                                
                                                                                                

                                                                                                //+ responsesCollectionView.collectionViewLayout.collectionViewContentSize.height
                                                                                                self.viewInScrollView.layoutIfNeeded()
                                                                                                
                                                                                                print(discussionCommentID)
                                                                                                print(documentsCount - 1)
                                                                                                print(sortedDiscussionComments)
                                                                                                var total = 0
                                                                                                var num = 0
                                                                                                while num < unsortedDiscussionComments.count {
                                                                                                    total += self.unsortedDiscussionComments.map({$0.commentReplies})[num].count
                                                                                                    num+=1
                                                                        
                                                                                                }
                                                                                                
//                                                                                                var total2 = 0
//                                                                                                var num2 = 0
//                                                                                                while num2<unsortedDiscussionComments.count {
//                                                                                                    total2 += self.unsortedDiscussionComment
//                                                                                                }
//
                                                                                                print(total)
                                                                                                print(commentsCount - (documentsCount - 1))
                                                                                                print(unsortedDiscussionComments.count)
                                                                                                print(documentsCount)
                                                                                                
                                                                                                if total == commentsCount - (documentsCount - 1) && unsortedDiscussionComments.count == (documentsCount - 1) {
                                                                                                    print(unsortedDiscussionComments)
                                                                                                    print(sortedDiscussionComments)
                                                                                                    
                                                                                                    var i = 0

                                                                                                    
                                                                                                    countNum = -1
                                                                                                    print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle}))
                                                                                                    while i < (self.sortedDiscussionComments.map({$0.discussionsCommentTitle}).count) {
                                                                                                        print(i)
                                                                                                        print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[i])
                                                                                                        if self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[i].prefix(1) == " " {
                                                                                                        
                                                                                                            
                                                                                                            self.sortedDiscussionComments.remove(at: i)
                                                                                                            i = -1
                                                                                                            

                                                                                                        }
                                                                                                        
                                                                                                         
                                                                                                                                                                                                            
                                                                                                        i+=1
                                                                                                    }
                                                                                                    
                                                                                                    i = 0
                                                                                                    while i < (self.sortedDiscussionComments.map({$0.discussionsCommentTitle}).count) {
                                                                                                        
                                                                                                        var k = 0
                                                                                                        print(self.sortedDiscussionComments.map({$0.commentReplies})[i])
                                                                                                        while k < self.sortedDiscussionComments.map({$0.commentReplies})[i].map({$0.discussionCommentReplyTitle}).count {
                                                                                                            if self.sortedDiscussionComments.map({$0.commentReplies})[i].map({$0.discussionCommentReplyTitle})[k] == " " {
                                                                                                                print(self.sortedDiscussionComments.map({$0.commentReplies})[i].map({$0.discussionCommentReplyTitle})[k])
                                                                                                                self.sortedDiscussionComments[i].commentReplies.remove(at: k)
                                                                                                                k = -1
                                                                                                            }
                                                                                                            k += 1
                                                                                                        }
                                                                                                        
                                                                                                        i+=1
                                                                                                    }
                                                                                                    
                                                                                                    discussionCommentCount.text = String(sortedDiscussionComments.count)
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    self.responsesCollectionView.layoutIfNeeded()
                                                                                                    self.responsesCollectionView.reloadData()
                                                                                                    self.responsesCollectionView.dataSource = self
                                                                                                    self.responsesCollectionView.delegate = self
                                                                                                    
                                                                                                    activityIndicator.stopAnimating()
                                                                                                }
                                                                                                
                                                                                                
                                                                                                    
                                                                                                    
//                                                                                                if unsortedDiscussionComments.count == documentsCount - 1 {
//                                                                                                    print(sortedDiscussionComments)
//
//                                                                                                    self.view.layoutIfNeeded()

//
//                                                                                                }
                                                                                                
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
                                                                                            
                                                                                            let docRefOne = db.collection("Users").document(Auth.auth().currentUser!.uid)

                                                                                            docRefOne.getDocument { (document, error) in

                                                                                                let result = Result {
                                                                                                  try document?.data(as: UserReference.self)

                                                                                                }
                                                                                                print(result)
                                                                                                switch result {
                                                                                                case .success(let user):
                                                                                                    if let user = user {
                                                                                                        // A `City` value was successfully initialized from the DocumentSnapshot.
                                                                                                        self.discussionCommentUserRace = user.race!
                                                                                                        self.discussionCommentUserBirthday = user.birthday!
                                                                                                        self.discussionCommentUserAge = calcAge(birthday: user.birthday!)
                                                                                                        self.discussionCommentUserCountry = user.country!
                                                                                                        self.discussionCommentUserGender = user.gender!
                                                                                                        
                                                                                                        sharedDiscussionCommentUserRace = discussionCommentUserRace
                                                                                                        sharedDiscussionCommentUserBirthday = discussionCommentUserBirthday
                                                                                                        sharedDiscussionCommentUserAge = discussionCommentUserAge
                                                                                                        sharedDiscussionCommentUserCountry = discussionCommentUserCountry
                                                                                                        sharedDiscussionCommentUserGender = discussionCommentUserGender
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
                                                                    
                                                                    
                                                                    
                                                    
                                                                    
//                                                                    self.discussionCommentCount.text = String(self.sortedDiscussionComments.map({$0.discussionsCommentTitle}).count)
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    

                                                                    
                                                                    
                                                                    
                                                                        
                                                                   
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
        
        
extension DiscussionPostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    
    

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
        print(sharedComments)

//        if iCount == 0 {
//            print(self.sortedDiscussionComments)
//            print(self.sortedDiscussionComments.count)
//            self.viewInScrollViewHeightConstraint.constant = self.discussionView.bounds.size.height + self.informationView.bounds.size.height + 84 + CGFloat((115*self.sortedDiscussionComments.count)) + 35
//            iCount+=1
//        }
        print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle}).count)
        return (self.sortedDiscussionComments.map({$0.discussionsCommentTitle}).count)
        
        
        }

    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "responsesCell", for: indexPath) as? DiscussionCommentsCollectionViewCell
        
        //self.viewInScrollViewHeightConstraint.constant = self.discussionView.bounds.size.height + self.informationView.bounds.size.height + 84 + responsesCollectionView.collectionViewLayout.collectionViewContentSize.height + 35

        
        print(responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
        
        
        if indexPath.row == sortedDiscussionComments.count - 1 {
            if viewInScrollViewHeight == 0 {
                
                viewInScrollViewHeight = Int(self.discussionView.bounds.size.height + self.informationView.bounds.size.height + 84 + responsesCollectionView.collectionViewLayout.collectionViewContentSize.height + 45)
                print(viewInScrollViewHeight)
                self.viewInScrollViewHeightConstraint.constant = CGFloat(viewInScrollViewHeight)

            }
        }
        


        var delimeter = "-"
        var commentTitle = self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row]
        var newCommentTitle = commentTitle.components(separatedBy: delimeter)
        cell?.commentLabel.text = newCommentTitle[0]

        
        cell?.commentLabel.sizeToFit()
        cell?.commentLabel.numberOfLines = 0

        
        
        cell?.responseCommentsCollectionView.reloadData()
        
        
        var displayedDate = sortedDiscussionComments.map({dateFormatter.string(from:$0.discussionCommentDate)})

     
        

        
        
        cell?.deleteOrFlag.showsMenuAsPrimaryAction = true
        
        if self.sortedDiscussionComments.map({$0.discussionUsername})[indexPath.row] == Auth.auth().currentUser!.uid {
            cell?.deleteOrFlag.menu = UIMenu(children: [
                UIAction(title: "Delete Response",image: UIImage(systemName: "trash"), handler: { action in
                    
                    
                    self.db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row]).whereField("date", isEqualTo: displayedDate[indexPath.row]).whereField("user", isEqualTo: self.sortedDiscussionComments.map({$0.discussionUsername})[indexPath.row])
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
                                
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                for document in querySnapshot!.documents {
                                    print("\(document.documentID) => \(document.data())")
                                    
                                    self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData(["commentTitle" : " - " + document.documentID])
                                    
                                    
                                    
                                    
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
                                    self.present(alert, animated: true, completion: nil)
                                
                                    self.getData()
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                            }
                    }
                    
                })
            ])
        }
        else {
            cell?.deleteOrFlag.menu = UIMenu(children: [
                
                UIAction(title: "Report Post",image: UIImage(systemName: "flag"), handler: { action in
                    reportedDiscussion = (self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row])
                    reportedDiscussionReply = "Nil"

                    self.reportCommentButtonTapped()
                    
                })
            ])
        }
        
        
        
        
        print(cell?.commentLabel.text)
        
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
        
        print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row])
        print(self.sortedDiscussionComments.map({$0.commentReplies})[indexPath.row].count)

        if self.sortedDiscussionComments.map({$0.commentReplies})[indexPath.row].count == 0 {
            cell?.repliesButton.isHidden = true
            cell?.repliesButtonWidth.constant = 0
        }
        else {
            cell?.repliesButton.isHidden = false
            cell?.repliesButtonWidth.constant = 70
        }
        
        sentCommentTitle = self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row]
        
        
        //
//        if cell?.commentLabel.text == "Hello" {
//            cell!.responseCommentsCollectionView.tag = 2
//
//        }
//        else {
//            cell!.responseCommentsCollectionView.tag = 0
//
//        }
//
        
//        discussionCommentRepliesFilterList.insert(contentsOf: filteredStruct, at: indexPath.row - 1)
        
        

        
        if self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexPath.row] == true {
            
            viewInScrollViewHeight = Int(self.discussionView.bounds.size.height + self.informationView.bounds.size.height + 84 + responsesCollectionView.collectionViewLayout.collectionViewContentSize.height + 45)
            print(viewInScrollViewHeight)
            self.viewInScrollViewHeightConstraint.constant = CGFloat(viewInScrollViewHeight)
            
            
            
            print(cell?.responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height)
            whichTextField = "comment"
            //
     
            

            print((cell?.responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height)! + 60)
            
            
            
            if cell?.responseCommentsViewHeightConstraint.constant != (cell?.responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height)! + 65 {
                print(cell?.responseCommentsViewHeightConstraint.constant)
                cell?.responseCommentsViewHeightConstraint.constant += (cell?.responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height)! + 65
                
                print(cell?.responseCommentsViewHeightConstraint.constant)
                //TEMPORARY SOLUTION NEED TO FIX
                
                
                for reply in sortedDiscussionComments.map({$0.commentReplies})[indexPath.row].map({$0.discussionCommentReplyTitle}) {

                    var count = reply.count

                    while count > 35 {
                        cell?.responseCommentsViewHeightConstraint.constant += 25
                        self.viewInScrollViewHeightConstraint.constant += 25
                        count -= 35
                    }


                }
                
                self.viewInScrollViewHeightConstraint.constant += (cell?.responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height)! + 65
                
                cell?.responseCommentsView.layoutIfNeeded()

                print(cell?.responseCommentsViewHeightConstraint.constant)
                
                print(viewInScrollViewHeightConstraint.constant)

            }
            
            cell?.repliesButton.setImage(UIImage(systemName: "chevron.up", withConfiguration: .none), for: .normal)
            
            print(viewInScrollViewHeightConstraint.constant)
            print((cell?.responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height)! + 60)
         

            pointX = (cell?.convert((cell?.replyTextField.frame.origin)!, to: viewInScrollView).x)!
            pointY = (cell?.convert((cell?.replyTextField.frame.origin)!, to: viewInScrollView).y)!

        }
        else {
            
            cell?.repliesButton.setImage(UIImage(systemName: "chevron.down", withConfiguration: .none), for: .normal)
            
            print(cell?.responseCommentsViewHeightConstraint.constant)
            print((cell?.responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height)! + 65)
            
            cell?.responseCommentsViewHeightConstraint.constant = 0
            cell?.responseCommentsView.layoutIfNeeded()
            
            
            if (cell?.responseCommentsViewHeightConstraint.constant)! == (cell?.responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height)! + 65{
                
                //TEMPORARY SOLUTION NEED TO FIX
                //*********************************
                
//                cell?.responseCommentsViewHeightConstraint.constant -= (cell?.responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height)! + 65
//
//                self.viewInScrollViewHeightConstraint.constant -= (cell?.responseCommentsCollectionView.collectionViewLayout.collectionViewContentSize.height)! + 65
//
//                for reply in sortedDiscussionComments.map({$0.commentReplies})[indexPath.row].map({$0.discussionCommentReplyTitle}) {
//
//                    var count = reply.count
//
//                    while count > 35 {
//                        cell?.responseCommentsViewHeightConstraint.constant -= 25
//                        self.viewInScrollViewHeightConstraint.constant -= 25
//                        count -= 35
//                    }
//
//
//                }
//
//                cell?.responseCommentsView.layoutIfNeeded()
//
//                print(cell?.responseCommentsViewHeightConstraint.constant)
//
//                print(viewInScrollViewHeightConstraint.constant)
//
//                closeRepliesView = false

            }
            
            else {
                
            }
            
            

        }
        let check = self.sortedDiscussionComments.map({$0.discussionReplyCancelOrPost})[indexPath.row]
        if check == "Post" {
            
            let replyTitle = cell?.replyTextField.text
            print(replyTextFieldVal)
            var docCount = 0
            let discussionComment = self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row]
            
            db.collection(conditionSelected).document(discussionDocument).collection("comments").whereField("commentTitle", isEqualTo: discussionComment)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).collection("replies").getDocuments() { (querySnapshot, err) in
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
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    
                                    
                                } else {
                                    docCount = querySnapshot!.documents.count
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                                    let date = Date()
                                    
                                    let replyTitle = cell?.replyTextField.text
                                        
                                    self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).collection("replies").document("\(docCount)").setData(["commentTitle" : discussionComment, "repliesTitle" : replyTextFieldVal, "repliesDate": dateFormatter.string(from: date), "repliesDownvotes": 0, "repliesUpvotes": 0, "repliesUser": Auth.auth().currentUser!.uid, "gender": ["Male", "Female", "Other"], "genderUpvotes": [0,0,0], "race": ["White", "Black or African American", "American Indian or Alaska Native", "Asian", "Native Hawaiian or Other Pacific Islander"], "raceUpvotes": [0,0,0,0,0], "age": ["0-10","10-20", "20-30", "30-40", "40-50", "50-60", "60-70", "70-80", "80+"], "ageUpvotes": [0,0,0,0,0,0,0,0,0], "country": [""], "countryUpvotes": [0]])
                                    
                                    let docRefFour = self.db.collection("Users").document(self.sortedDiscussionComments.map({$0.discussionUsername})[indexPath.row])

                                    docRefFour.getDocument { (document, error) in

                                        let result = Result {
                                          try document?.data(as: DeviceTokenReference.self)

                                        }
                                        print(result)
                                        switch result {
                                        case .success(let deviceToken):
                                            if let deviceToken = deviceToken {
                                                // A `City` value was successfully initialized from the DocumentSnapshot.
                                                
                                                print(deviceToken.deviceToken!)
                                                let sender = PushNotificationSender()
                                                let response = cell?.commentLabel!.text!
                                            
                                                sender.sendPushNotification(to: deviceToken.deviceToken!, title: "MedConnect", body: "💬 Someone replied to your response: \(response!)")
                                                
                                                
                                                var delimeter = " "
                                                var user = cell?.cellUsername.text
                                                var newUser = user!.components(separatedBy: delimeter)
                                                print(newUser[1])
                                                
                                                print(cell?.cellUsername.text)
                                                self.db.collection("Users").document(newUser[1]).collection("notifications").getDocuments() { (querySnapshot, err) in
                                                        if let err = err {
                                                            print("Error getting documents: \(err)")
                                                        } else {
                                                            let totalDocCount = querySnapshot!.documents.count
                                                            
                                                            let dateFormatter = DateFormatter()
                                                            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                                                            let date = Date()
                                                            
                                                            
                                                            
                                                            self.db.collection("Users").document(newUser[1]).collection("notifications").document("\(totalDocCount)").setData(["notificationTitle": "💬 New Reply", "notificationBody": "Someone replied to your response: \(response!)", "notificationCondition": conditionSelected, "notificationDiscussion": selectedDiscussion, "notificationDate": dateFormatter.string(from: date)])
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
                                    
                                    let alert = UIAlertController(title: "Success‼️✅", message: "Please Refresh", preferredStyle: .alert)
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
                                    self.present(alert, animated: true, completion: nil)
                                
                                    self.getData()
                                    
                                    
                        }
                    }
            }
            
            
            
//
//                    cell?.postReplyViewHeightConstraint.constant = 0.0
//                    cell?.postReplyView.layoutIfNeeded()
//
//                    cell?.replyTextField.isHidden = true
//
//                    cell?.replyCancelSendButton.isHidden = true
//                    cell?.replyCancelSendButton.isEnabled = false
                    
                    
                }
            }
        }
        else {
            if self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexPath.row] == true {
                self.viewInScrollView.layoutIfNeeded()

                whichTextField = "comment"
                cell?.replyTextField.text = ""
                cell?.replyTextField.isHidden = false

                cell?.postReplyViewHeightConstraint.constant = 31
                cell?.postReplyView.layoutIfNeeded()
                cell?.replyCancelSendButton.isHidden = false
                cell?.replyCancelSendButton.isEnabled = true
                
                pointX = (cell?.convert((cell?.replyTextField.frame.origin)!, to: viewInScrollView).x)!
                pointY = (cell?.convert((cell?.replyTextField.frame.origin)!, to: viewInScrollView).y)!

                                


            }
            else {
                
                
                cell?.postReplyViewHeightConstraint.constant = 0.0
                cell?.postReplyView.layoutIfNeeded()

                cell?.replyTextField.isHidden = true

                cell?.replyCancelSendButton.isHidden = true
                cell?.replyCancelSendButton.isEnabled = false
            }
        }
            
            
        
        
//
//
//        cell?.downHeartLabel.text = String(self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexPath.row])
//
//       var displayedDate = sortedDiscussionComments.map({dateFormatter.string(from:$0.discussionCommentDate)})
//
//        cell?.commentDateLabel.text = String(displayedDate[indexPath.row][..<displayedDate[indexPath.row].index(displayedDate[indexPath.row].startIndex, offsetBy:10)])
//
//        cell?.upHeartLabel.text = String(self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexPath.row])
        
                
//            var dateDisplayed:String = String(self.sortedDiscussions!.map({dateFormatter!.string(from:$0.discussionDates!)!}!)!)! ?? ""

        cell?.commentDateLabel.text = String(displayedDate[indexPath.row][..<displayedDate[indexPath.row].index(displayedDate[indexPath.row].startIndex, offsetBy:10)])
        
//
        cell?.corneredView.layer.cornerRadius = 10
        cell?.upHeartView.layer.cornerRadius = 10
        cell?.downHeartView.layer.cornerRadius = 10
        
        print(discussionCommentUserUpvote)

        if self.discussionCommentUserUpvote.contains((self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row])) {
            cell?.upHeartImage.image = UIImage(systemName: "arrow.up.heart.fill")
            cell?.upHeartView.backgroundColor = UIColor.white
            
        }
        else {
            cell?.upHeartImage.image = UIImage(systemName: "arrow.up.heart")
            cell?.upHeartView.backgroundColor = UIColor.systemGray6


        }
        
    
        
        print(discussionCommentUserDownvote)
        
        if self.discussionCommentUserDownvote.contains((self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row])) {
            cell?.downHeartImage.image = UIImage(systemName: "arrow.down.heart.fill")
            cell?.downHeartView.backgroundColor = UIColor.white
        }
        else {
            cell?.downHeartImage.image = UIImage(systemName: "arrow.down.heart")
            cell?.downHeartView.backgroundColor = UIColor.systemGray6
        }
        

//        cell?.replyTextField.addTarget(self, action: #selector(replyTextFieldEditingBegin(sender:)), for: .editingDidBegin)
        
        cell?.replyCancelSendButton.addTarget(self, action: #selector(sendOrCancelButton(sender:)), for: .touchUpInside)
        cell?.repliesButton.addTarget(self, action: #selector(repliesButtonTapped(sender:)), for: .touchUpInside)
        cell?.repliesButton.tag = indexPath.row
        discussionCommentRepliesIndexPath = (cell?.repliesButton.tag)!
        
        cell?.replyButton.addTarget(self, action: #selector(replyButtonTapped(sender:)), for: .touchUpInside)
        
        cell?.upHeartButton.addTarget(self, action: #selector(upheartTapped(sender:)), for: .touchUpInside)
        cell?.downHeartButton.addTarget(self, action: #selector(downheartTapped(sender:)), for: .touchUpInside)
        
        
     //   cell?.pieChartButton.addTarget(self, action: #selector(pieChartButtonTapped(sender:)), for: .touchUpInside)
        
        cell?.pieChartButton.addTarget(self, action: #selector(pieChartButtonTapped(sender:)), for: .touchUpInside)

//        UIAction(title: "Report Post",image: UIImage(systemName: "flag"), handler: { action in
//            reportedDiscussion = (self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath.row])
//            reportedDiscussionReply = "Nil"
//
//            self.reportCommentButtonTapped()
//
//        })
        cell?.pieChartButton.tag = indexPath.row
        cell?.replyCancelSendButton.tag = indexPath.row
        cell?.replyTextField.tag = indexPath.row
        cell?.upHeartButton.tag = indexPath.row
        cell?.downHeartButton.tag = indexPath.row
        cell?.upHeartImage.tag = indexPath.row
        cell?.replyButton.tag = indexPath.row
        
        cell?.downHeartImage.tag = indexPath.row
        
        cell?.responseCommentsCollectionView.collectionViewLayout.collectionView?.cellForItem(at: indexPath)
        
        cell?.replyButton.layer.cornerRadius = 10

        
//        cell?.replyTextField.layer.cornerRadius = 10
//        cell?.replyTextField.layer.borderColor = UIColor.clear.cgColor
    
        
       cell?.replyTextFieldHeightConstraint.constant = 31
        
        cell?.backgroundColor = UIColor.white
        cell?.layer.cornerRadius = 10
        
//        print(cell?.replyTextField.)
        print(cell?.frame.origin)
        
        print(cell?.convert((cell?.replyTextField.frame)!, to: self.view))
        
        
        
//        cell?.postCommentReplyView.layer.borderColor = UIColor.systemGray5.cgColor
//        cell?.postCommentReplyView.layer.borderWidth = 1
//        cell?.postCommentReplyView.layer.cornerRadius = 10
//        cell?.postCommentReplyViewHeightConstraint.constant = 0
 
        return cell!
    
    }
    
//    @objc func reportCommentButtonTapped() {
//        var reportResponseVC = UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "ReportResponseViewController")
//        if let sheet = reportResponseVC.sheetPresentationController {
//            sheet.detents = [.medium()]
//            sheet.prefersGrabberVisible = true
//            sheet.preferredCornerRadius = 25
//
//        }
//
//        self.present(reportResponseVC, animated: true, completion: nil)
//
//    }
    
    
    @objc func pieChartButtonTapped(sender:UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        print(indexpath.row)
        
        var delimeter = "-"
        var commentTitle = self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath.row]
        var newCommentTitle = commentTitle.components(separatedBy: delimeter)
        
        selectedPieChartResponse = newCommentTitle[0]
        
        selectedGenderVotes = self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath.row]
        selectedRaceVotes = self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath.row]
        selectedAgeVotes = self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath.row]
        selectedCountry = self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath.row]
        selectedCountryVotes = self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath.row]
        
        sharedDiscussionCommentUserRace = discussionCommentUserRace
        sharedDiscussionCommentUserBirthday = discussionCommentUserBirthday
        sharedDiscussionCommentUserAge = discussionCommentUserAge
        sharedDiscussionCommentUserCountry = discussionCommentUserCountry
        sharedDiscussionCommentUserGender = discussionCommentUserGender
        
        var pieChartVC = UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "PieChartViewController")
        
        if let sheet = pieChartVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            
        }

        self.present(pieChartVC, animated: true, completion: nil)
    }
    
    

    @objc func sendOrCancelButton(sender:UIButton) {
        let indexpath4 = IndexPath(row: sender.tag, section: 0)
        if sender.titleLabel?.text == "Cancel" {
            
            if cancelKeyboardIndicator == true {
                self.viewInScrollViewHeightConstraint.constant -= keyboardHeight

                self.view.endEditing(true)
                cancelKeyboardIndicator = false
            }
            
            print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath4.row])
            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath4.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath4.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath4.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath4.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath4.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath4.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath4.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath4.row], discussionReplyButtonTapped: false, discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath4.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath4.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath4.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath4.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath4.row]), at: indexpath4.row)
            
            self.sortedDiscussionComments.remove(at: indexpath4.row + 1)
            self.view.endEditing(true)
            

            
            self.responsesCollectionView.reloadData()

        } else {
            print("Post")
            print(self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath4.row])
            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath4.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath4.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath4.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath4.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath4.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath4.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath4.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath4.row], discussionReplyButtonTapped: false, discussionReplyCancelOrPost: "Post", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath4.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath4.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath4.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath4.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath4.row]), at: indexpath4.row)
            
            
            
            self.sortedDiscussionComments.remove(at: indexpath4.row + 1)
            self.view.endEditing(true)

            self.responsesCollectionView.reloadData()

            
        }
    }
    
    
    
    @objc func replyTextFieldEditingBegin(sender:UITextField) {
        sender.delegate = self
        sender.becomeFirstResponder()
        let indexpath4 = IndexPath(row: sender.tag, section: 0)
        if sender.text!.count > 0 {
                self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath4.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath4.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath4.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath4.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath4.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath4.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath4.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath4.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath4.row], discussionReplyCancelOrPost: "Post", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath4.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath4.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath4.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath4.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath4.row]), at: indexpath4.row)
                
                self.sortedDiscussionComments.remove(at: indexpath4.row + 1)
                
                self.responsesCollectionView.reloadData()
        }
        
    
        else {
            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath4.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath4.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath4.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath4.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath4.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath4.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath4.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath4.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath4.row], discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath4.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath4.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath4.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath4.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath4.row]), at: indexpath4.row)
            
            self.sortedDiscussionComments.remove(at: indexpath4.row + 1)
            
            self.responsesCollectionView.reloadData()
        }
    }
    
    
    @objc func replyButtonTapped(sender:UIButton) {
        countNum = -1
        let indexPath3 = IndexPath(row: sender.tag, section: 0)
        
        if self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexPath3.row] == false {
            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath3.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexPath3.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexPath3.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexPath3.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexPath3.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexPath3.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexPath3.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexPath3.row], discussionReplyButtonTapped: true, discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexPath3.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexPath3.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexPath3.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexPath3.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexPath3.row]), at: indexPath3.row)
            
            self.sortedDiscussionComments.remove(at: indexPath3.row + 1)
            
            var i = 0
            
            
           
            
            var collapseRepliesSubtract = 0
            while i < sortedDiscussionComments.count {
                if i != indexPath3.row {
                    if self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[i] == true {
                        collapseRepliesSubtract += self.sortedDiscussionComments.map({$0.commentReplies})[i].count
                    }
                    self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[i], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[i], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[i], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[i]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[i], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[i], discussionCommentRepliesOpen: false, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[i], discussionReplyButtonTapped: false, discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[i], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[i], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[i], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[i], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[i]), at: i)
                    
                    self.sortedDiscussionComments.remove(at: i + 1)
                }
                i+=1
            }
            
            print(collapseRepliesSubtract)
//            self.viewInScrollViewHeightConstraint.constant -= CGFloat(110 * collapseRepliesSubtract)
            self.responsesCollectionView.layoutIfNeeded()
            self.responsesCollectionView.reloadData()
            self.responsesCollectionView.dataSource = self
            self.responsesCollectionView.delegate = self
            replyOpenCount += 1
        }
        }
      
    
    
    @objc func repliesButtonTapped(sender:UIButton) {
        
        
        
        let indexPath2 = IndexPath(row: sender.tag, section: 0)
        
        if self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexPath2.row] == false {
            sortedDiscussionComments = sharedComments

            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath2.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexPath2.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexPath2.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexPath2.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexPath2.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexPath2.row], discussionCommentRepliesOpen: true, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexPath2.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexPath2.row], discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexPath2.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexPath2.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexPath2.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexPath2.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexPath2.row]), at: indexPath2.row)
            
            print(self.sortedDiscussionComments)
            self.sortedDiscussionComments.remove(at: indexPath2.row + 1)
            print(self.sortedDiscussionComments)
            print(indexPath2.row)
            
            sentComment = [DiscussionComment]()
            sentComment.append(sortedDiscussionComments[indexPath2.row])
            print(sentComment)
            
            sentIndex = indexPath2.row

            countNum = -1
            
            var i = 0
            var totalCommentsSubtract = 0
            while i < sortedDiscussionComments.count {
                if i != indexPath2.row {
                    if self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[i] == true {
                        totalCommentsSubtract += self.sortedDiscussionComments.map({$0.commentReplies})[i].count
                        print(totalCommentsSubtract)
                    }
                    self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[i], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[i], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[i], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[i]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[i], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[i], discussionCommentRepliesOpen: false, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[i], discussionReplyButtonTapped: false, discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[i], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[i], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[i], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[i], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[i]), at: i)
                    
                    self.sortedDiscussionComments.remove(at: i + 1)
                }
                i+=1
            }
            
            
            
            
            
            
            
            var commentRepliesCountAdd = 0
            
            commentRepliesCountAdd = self.sortedDiscussionComments.map({$0.commentReplies})[indexPath2.row].count
            
            print(commentRepliesCountAdd)
            
            print(viewInScrollViewHeightConstraint.constant)
            print(commentRepliesCountAdd)
//            self.viewInScrollViewHeightConstraint.constant -= CGFloat(110 * totalCommentsSubtract) + 60
//
//            self.viewInScrollViewHeightConstraint.constant += CGFloat(110 * commentRepliesCountAdd) + 60
            print(viewInScrollViewHeightConstraint.constant)
            
            closeRepliesView = true

            self.viewInScrollView.layoutIfNeeded()
            
        

            
            self.responsesCollectionView.reloadData()
            
            
//            self.responsesCollectionView.dataSource = self
//            self.responsesCollectionView.delegate = self
            
            print(responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
            discussionCommentsViewHeight += 100
            
           
            


           

        }
        else {
            sortedDiscussionComments = sharedComments

            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexPath2.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexPath2.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexPath2.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexPath2.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexPath2.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexPath2.row], discussionCommentRepliesOpen: false, commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexPath2.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexPath2.row], discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexPath2.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexPath2.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexPath2.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexPath2.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexPath2.row]), at: indexPath2.row)
            
            print(self.sortedDiscussionComments)
            self.sortedDiscussionComments.remove(at: indexPath2.row + 1)
            print(self.sortedDiscussionComments)
            print(indexPath2.row)
            countNum = -1
            

            self.responsesCollectionView.reloadData()

            
            print(responsesCollectionView.collectionViewLayout.collectionViewContentSize.height)
            var commentRepliesCountSubtract = 0
            commentRepliesCountSubtract = self.sortedDiscussionComments.map({$0.commentReplies})[indexPath2.row].count
//
            //self.viewInScrollViewHeightConstraint.constant = self.discussionView.bounds.size.height + self.informationView.bounds.size.height + 84 + CGFloat((115*self.sortedDiscussionComments.count)) + 35
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
                            
                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                "upvotes": (Int(self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row]))
                                
                                
                            ])
                            
                            
                            
                            if self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row].contains(self.discussionCommentUserCountry) {
                                print(self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row])
                                
                                let countryIndex = self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row].firstIndex(of: self.discussionCommentUserCountry)
                                
                                
                                
                                self.sortedDiscussionComments[indexpath1.row].discussionCommentCountryUpvotes[countryIndex!] -= 1
                                
                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                    "countryUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath1.row]])
                                
                                
                            }
                            
                            print(self.discussionCommentUserGender)
                            var genderIndex = 0
                            if self.discussionCommentUserGender == "Male" {
                                genderIndex = 0
                            }
                            else if self.discussionCommentUserGender == "Female" {
                                genderIndex = 1
                                
                            }
                            else if self.discussionCommentUserGender == "Other" {
                                genderIndex = 2
                                
                            }
                            
                            self.sortedDiscussionComments[indexpath1.row].discussionCommentGenderUpvotes[genderIndex] -= 1

                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                "genderUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath1.row]])
                            
                            print(self.discussionCommentUserRace)
                            
                            var raceIndex = 0
                            if self.discussionCommentUserRace == "White" {
                                raceIndex = 0
                            }
                            else if self.discussionCommentUserRace == "Black or African American" {
                                raceIndex = 1
                                
                            }
                            else if self.discussionCommentUserRace == "American Indian or Alaska Native" {
                                raceIndex = 2
                                
                            }
                            else if self.discussionCommentUserRace == "Asian" {
                                raceIndex = 3
                                
                            }
                            else if self.discussionCommentUserRace == "Native Hawaiian or Other Pacific Islander" {
                                raceIndex = 4
                                
                            }
                            
                            
                            self.sortedDiscussionComments[indexpath1.row].discussionCommentRaceUpvotes[raceIndex] -= 1

                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                "raceUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath1.row]])
                            
                            
                            print(self.discussionCommentUserAge)

                            var ageIndex = 0
                            if self.discussionCommentUserAge > 0 && self.discussionCommentUserAge <= 10 {
                                ageIndex = 0
                            }
                            else if self.discussionCommentUserAge > 10 && self.discussionCommentUserAge <= 20 {
                                ageIndex = 1
                            }
                            else if self.discussionCommentUserAge > 20 && self.discussionCommentUserAge <= 30 {
                                ageIndex = 2
                            }
                            else if self.discussionCommentUserAge > 30 && self.discussionCommentUserAge <= 40 {
                                ageIndex = 3
                            }
                            else if self.discussionCommentUserAge > 40 && self.discussionCommentUserAge <= 50 {
                                ageIndex = 4
                            }
                            else if self.discussionCommentUserAge > 50 && self.discussionCommentUserAge <= 60 {
                                ageIndex = 5
                            }
                            else if self.discussionCommentUserAge > 60 && self.discussionCommentUserAge <= 70 {
                                ageIndex = 6
                            }
                            else if self.discussionCommentUserAge > 70 && self.discussionCommentUserAge <= 80 {
                                ageIndex = 7
                            }
                            else if self.discussionCommentUserAge > 80 {
                                ageIndex = 8
                            }
                            
                            
                            self.sortedDiscussionComments[indexpath1.row].discussionCommentAgeUpvotes[ageIndex] -= 1

                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                "ageUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath1.row]])
                            
                            
                            
                            
                            
                        }
                        
                    }}
                
                    
                    self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row] - 1), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath1.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath1.row], discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath1.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath1.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath1.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath1.row]), at: indexpath1.row)
                    print(self.sortedDiscussionComments)
                    self.sortedDiscussionComments.remove(at: indexpath1.row + 1)
                    print(self.sortedDiscussionComments)
                    print(indexpath1.row)

                    
            
            
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
            
            self.responsesCollectionView.reloadData()
            self.responsesCollectionView.dataSource = self
            self.responsesCollectionView.delegate = self
            
            
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
                            
                            
                            let docRefFour = self.db.collection("Users").document(self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row])

                            docRefFour.getDocument { (document, error) in

                                let result = Result {
                                  try document?.data(as: DeviceTokenReference.self)

                                }
                                print(result)
                                switch result {
                                case .success(let deviceToken):
                                    if let deviceToken = deviceToken {
                                        // A `City` value was successfully initialized from the DocumentSnapshot.
                                        
                                        print(deviceToken.deviceToken!)
                                        let sender = PushNotificationSender()
                                        
                                        var delimeter = "-"
                                        var responseLabel = self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row]
                                        let newResponseLabel = responseLabel.components(separatedBy: delimeter)
                                        print(newResponseLabel[1])
                                        sender.sendPushNotification(to: deviceToken.deviceToken!, title: "MedConnect", body: "♥️⬆️ Someone upvoted your response: \(newResponseLabel[0])")
                                        
                                        self.db.collection("Users").document(self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row]).collection("notifications").getDocuments() { (querySnapshot, err) in
                                                if let err = err {
                                                    print("Error getting documents: \(err)")
                                                } else {
                                                    let totalDocCount = querySnapshot!.documents.count
                                                    
                                                    let dateFormatter = DateFormatter()
                                                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                                                    let date = Date()
                                                    
                                                    
                                                    
                                                    self.db.collection("Users").document(self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row]).collection("notifications").document("\(totalDocCount)").setData(["notificationTitle": "♥️⬆️ New Upheart", "notificationBody": "Someone upvoted your response: \(newResponseLabel[0])", "notificationCondition": conditionSelected, "notificationDiscussion": selectedDiscussion, "notificationDate": dateFormatter.string(from: date)])
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
                            
                            
                            
                            
                                                        if self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row].contains(self.discussionCommentUserCountry) {
                                                            print(self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row])
                            
                                                            var countryIndex = self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row].firstIndex(of: self.discussionCommentUserCountry)
                            
                                                            print(self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row])
                            
                                                            self.sortedDiscussionComments[indexpath1.row].discussionCommentCountryUpvotes[countryIndex!] += 1
                            
                                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                                                "countryUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath1.row]])
                            
                            
                                                        }
                                                        else {
                                                            print(self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row])
                            
                                                            self.sortedDiscussionComments[indexpath1.row].discussionCommentCountry.append(self.discussionCommentUserCountry)
                            
                                                            print(self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row])
                            
                                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                                                "country": self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row]
                                                            ])
                                                            
                                                            
                                                            self.sortedDiscussionComments[indexpath1.row].discussionCommentCountryUpvotes.append(1)
                                                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                                                "countryUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath1.row]
                                                            ])
                            
                            
                                                        }
                            
                            
                            print(self.discussionCommentUserGender)
                            var genderIndex = 0
                            if self.discussionCommentUserGender == "Male" {
                                genderIndex = 0
                            }
                            else if self.discussionCommentUserGender == "Female" {
                                genderIndex = 1
                                
                            }
                            else if self.discussionCommentUserGender == "Other" {
                                genderIndex = 2
                                
                            }
                            
                            self.sortedDiscussionComments[indexpath1.row].discussionCommentGenderUpvotes[genderIndex] += 1

                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                "genderUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath1.row]])
                            
                            print(self.discussionCommentUserRace)
                            
                            var raceIndex = 0
                            if self.discussionCommentUserRace == "White" {
                                raceIndex = 0
                            }
                            else if self.discussionCommentUserRace == "Black or African American" {
                                raceIndex = 1
                                
                            }
                            else if self.discussionCommentUserRace == "American Indian or Alaska Native" {
                                raceIndex = 2
                                
                            }
                            else if self.discussionCommentUserRace == "Asian" {
                                raceIndex = 3
                                
                            }
                            else if self.discussionCommentUserRace == "Native Hawaiian or Other Pacific Islander" {
                                raceIndex = 4
                                
                            }
                            
                            
                            self.sortedDiscussionComments[indexpath1.row].discussionCommentRaceUpvotes[raceIndex] += 1

                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                "raceUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath1.row]])
                            
                            
                            print(self.discussionCommentUserAge)

                            var ageIndex = 0
                            if self.discussionCommentUserAge > 0 && self.discussionCommentUserAge <= 10 {
                                ageIndex = 0
                            }
                            else if self.discussionCommentUserAge > 10 && self.discussionCommentUserAge <= 20 {
                                ageIndex = 1
                            }
                            else if self.discussionCommentUserAge > 20 && self.discussionCommentUserAge <= 30 {
                                ageIndex = 2
                            }
                            else if self.discussionCommentUserAge > 30 && self.discussionCommentUserAge <= 40 {
                                ageIndex = 3
                            }
                            else if self.discussionCommentUserAge > 40 && self.discussionCommentUserAge <= 50 {
                                ageIndex = 4
                            }
                            else if self.discussionCommentUserAge > 50 && self.discussionCommentUserAge <= 60 {
                                ageIndex = 5
                            }
                            else if self.discussionCommentUserAge > 60 && self.discussionCommentUserAge <= 70 {
                                ageIndex = 6
                            }
                            else if self.discussionCommentUserAge > 70 && self.discussionCommentUserAge <= 80 {
                                ageIndex = 7
                            }
                            else if self.discussionCommentUserAge > 80 {
                                ageIndex = 8
                            }
                            
                            
                            self.sortedDiscussionComments[indexpath1.row].discussionCommentAgeUpvotes[ageIndex] += 1

                            self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                "ageUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath1.row]])
                            
                            
                        }
                    }
            }
            

            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row] + 1), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath1.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath1.row], discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath1.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath1.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath1.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath1.row]), at: indexpath1.row)
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
                        
                        
                        self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row] - 1, discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath1.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath1.row], discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath1.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath1.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath1.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath1.row]), at: indexpath1.row)
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
                    
                    
                    
                    self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row] - 1, discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath1.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath1.row], discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath1.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath1.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath1.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath1.row]), at: indexpath1.row)
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
            
            
            self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row] + 1, discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row]), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath1.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath1.row], discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath1.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath1.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath1.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath1.row]), at: indexpath1.row)
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
                                
                                if self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row].contains(self.discussionCommentUserCountry) {
                                    print(self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row])
                                    
                                    let countryIndex = self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row].firstIndex(of: self.discussionCommentUserCountry)
                                    
                                    
                                    
                                    self.sortedDiscussionComments[indexpath1.row].discussionCommentCountryUpvotes[countryIndex!] -= 1
                                    
                                    self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                        "countryUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath1.row]])
                                    
                                    
                                }
                                
                                print(self.discussionCommentUserGender)
                                var genderIndex = 0
                                if self.discussionCommentUserGender == "Male" {
                                    genderIndex = 0
                                }
                                else if self.discussionCommentUserGender == "Female" {
                                    genderIndex = 1
                                    
                                }
                                else if self.discussionCommentUserGender == "Other" {
                                    genderIndex = 2
                                    
                                }
                                
                                self.sortedDiscussionComments[indexpath1.row].discussionCommentGenderUpvotes[genderIndex] -= 1

                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                    "genderUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath1.row]])
                                
                                print(self.discussionCommentUserRace)
                                
                                var raceIndex = 0
                                if self.discussionCommentUserRace == "White" {
                                    raceIndex = 0
                                }
                                else if self.discussionCommentUserRace == "Black or African American" {
                                    raceIndex = 1
                                    
                                }
                                else if self.discussionCommentUserRace == "American Indian or Alaska Native" {
                                    raceIndex = 2
                                    
                                }
                                else if self.discussionCommentUserRace == "Asian" {
                                    raceIndex = 3
                                    
                                }
                                else if self.discussionCommentUserRace == "Native Hawaiian or Other Pacific Islander" {
                                    raceIndex = 4
                                    
                                }
                                
                                
                                self.sortedDiscussionComments[indexpath1.row].discussionCommentRaceUpvotes[raceIndex] -= 1

                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                    "raceUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath1.row]])
                                
                                
                                print(self.discussionCommentUserAge)

                                var ageIndex = 0
                                if self.discussionCommentUserAge > 0 && self.discussionCommentUserAge <= 10 {
                                    ageIndex = 0
                                }
                                else if self.discussionCommentUserAge > 10 && self.discussionCommentUserAge <= 20 {
                                    ageIndex = 1
                                }
                                else if self.discussionCommentUserAge > 20 && self.discussionCommentUserAge <= 30 {
                                    ageIndex = 2
                                }
                                else if self.discussionCommentUserAge > 30 && self.discussionCommentUserAge <= 40 {
                                    ageIndex = 3
                                }
                                else if self.discussionCommentUserAge > 40 && self.discussionCommentUserAge <= 50 {
                                    ageIndex = 4
                                }
                                else if self.discussionCommentUserAge > 50 && self.discussionCommentUserAge <= 60 {
                                    ageIndex = 5
                                }
                                else if self.discussionCommentUserAge > 60 && self.discussionCommentUserAge <= 70 {
                                    ageIndex = 6
                                }
                                else if self.discussionCommentUserAge > 70 && self.discussionCommentUserAge <= 80 {
                                    ageIndex = 7
                                }
                                else if self.discussionCommentUserAge > 80 {
                                    ageIndex = 8
                                }
                                
                                
                                self.sortedDiscussionComments[indexpath1.row].discussionCommentAgeUpvotes[ageIndex] -= 1

                                self.db.collection(conditionSelected).document(discussionDocument).collection("comments").document(document.documentID).updateData([
                                    "ageUpvotes": self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath1.row]])
                                
                            }
                        }
                        
                        
                        self.sortedDiscussionComments.insert(DiscussionComment(discussionsCommentTitle: self.sortedDiscussionComments.map({$0.discussionsCommentTitle})[indexpath1.row], discussionCommentDate: self.sortedDiscussionComments.map({$0.discussionCommentDate})[indexpath1.row], discussionCommentDownvotes: self.sortedDiscussionComments.map({$0.discussionCommentDownvotes})[indexpath1.row], discussionCommentUpvotes: (self.sortedDiscussionComments.map({$0.discussionCommentUpvotes})[indexpath1.row] - 1), discussionCommentPopularity: self.sortedDiscussionComments.map({$0.discussionCommentPopularity})[indexpath1.row], discussionUsername: self.sortedDiscussionComments.map({$0.discussionUsername})[indexpath1.row], discussionCommentRepliesOpen: self.sortedDiscussionComments.map({$0.discussionCommentRepliesOpen})[indexpath1.row], commentReplies: self.sortedDiscussionComments.map({$0.commentReplies})[indexpath1.row], discussionReplyButtonTapped: self.sortedDiscussionComments.map({$0.discussionReplyButtonTapped})[indexpath1.row], discussionReplyCancelOrPost: "", discussionCommentGenderUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentGenderUpvotes})[indexpath1.row], discussionCommentAgeUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentAgeUpvotes})[indexpath1.row], discussionCommentRaceUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentRaceUpvotes})[indexpath1.row], discussionCommentCountry: self.sortedDiscussionComments.map({$0.discussionCommentCountry})[indexpath1.row], discussionCommentCountryUpvotes: self.sortedDiscussionComments.map({$0.discussionCommentCountryUpvotes})[indexpath1.row]), at: indexpath1.row)
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


    
