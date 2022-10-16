//
//  DiscussionNewViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/24/22.
//

import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

//class Discussions {
//    var discussionsTitle:String
//    var discussionDates:String
//    var discussionViews:Int
//    var discussionComments:[String]
//
//    init(discussionsTitle: String, discussionDates:String, discussionsViews: Int, discussionComments:[String]) {
//        self.discussionsTitle = discussionsTitle
//        self.discussionDates = discussionDates
//        self.discussionViews = discussionsViews
//        self.discussionComments = discussionComments
//        }
//
//}

struct DiscussionStruct {
    var discussionsTitle:String
    var discussionsUser:String
    var discussionDates:Date
    var discussionViews:Int
    var discussionCommentCount:Int
}

var selectedDiscussion = ""



class DiscussionNewViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var db = Firestore.firestore()
    
    typealias FinishedDownload = () -> ()
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var discussionCollectionView: UICollectionView!
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    @IBOutlet weak var sortedByLabel: UILabel!
    
    @IBOutlet weak var filterButton: UIButton!
    
    var discussions = [String]()
    var discussionUsers = [String]()
    var discussionDates = [String]()
    var discussionViews = [String]()
    var discussionComments = [String]()
    var discussionSaved = [String]()
    
    var unsortedDiscussions = [DiscussionStruct]()
    var sortedDiscussions = [DiscussionStruct]()
    var savedUnsorted = [DiscussionStruct]()
    var sortedDates = [String]()
    
    var documentsCount = ""
    
    var dateFormatter = DateFormatter()
    
    var completionNumber = 0
    
    var currentFilter = "Views"
    
    var searchedDiscussion = [String]()
    
    @IBOutlet weak var noDataLabel: UILabel!

//    let test1 = DiscussionStruct(discussionsTitle: "title1", discussionDates: "titleDate1", discussionViews: 3, discussionComments: ["comment1", "comment2"])
//
//    let test2 = DiscussionStruct(discussionsTitle: "title2", discussionDates: "titleDate2", discussionViews: 2, discussionComments: ["comment1", "comment2"])
//
//    let test3 = DiscussionStruct(discussionsTitle: "title3", discussionDates: "titleDate3", discussionViews: 1, discussionComments: ["comment1", "comment2"])
//
    
    var testString = "07/08/2022 18:43"
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        // Do any additional setup after loading the view.
//        getDiscussionData()
//
//        collectionView.reloadData()
        //let testCases = [test1, test2, test3]
        
        searchCollectionView.alwaysBounceVertical = true
        
        searchBar.delegate = self
        
        searchCollectionView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        searchBar.layer.borderWidth = 0
        searchBar.layer.borderColor = UIColor.systemGray6.cgColor
        searchBar.backgroundImage = UIImage()
        
            
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        discussionCollectionView.refreshControl = refreshControl
        
        navigationItem.title = conditionSelected
        
        print("test")
        print("****************EVERYTHING BELOW IS DISCUSSION PAGE ***************")
        
        getDiscussionData()
       

        setPopupButton()
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
           if segue.identifier == "addDiscussionSegue" {
               let popoverViewController = segue.destination
               popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
               popoverViewController.popoverPresentationController!.delegate = self
           }
       }
    
    
    func setPopupButton(){
        let optionClosure = {(action: UIAction) in
            if action.title == "Views" {
                self.currentFilter = "Views"
                self.refresh()
            }
            else {
                self.currentFilter = "Date Posted"
                self.refresh()
            }
        }
        filterButton.menu = UIMenu(children: [
            UIAction(title : "Views", state: .on, handler: optionClosure),
            UIAction(title : "Date Posted", handler: optionClosure)
        ])
        
        filterButton.showsMenuAsPrimaryAction = true
        if #available(iOS 15.0, *) {
            filterButton.changesSelectionAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
            print("RIP")
        }
    }
    
    @objc func refresh() {
        getDiscussionData()
        

        
        self.discussionCollectionView.refreshControl?.endRefreshing()

        
    }
    

    @objc func getDiscussionData() {
        documentsCount = ""
        completionNumber = 0
        
        self.discussions = [String]()
        self.discussionDates = [String]()
        self.discussionViews = [String]()
        self.discussionComments = [String]()
        self.discussionSaved = [String]()
        self.discussionUsers = [String]()
        self.unsortedDiscussions = [DiscussionStruct]()
        self.sortedDiscussions = [DiscussionStruct]()
        self.savedUnsorted = [DiscussionStruct]()
        self.sortedDates = [String]()
        
        db.collection(conditionSelected).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.documentsCount = String((querySnapshot?.documents.count)!)
                print(self.documentsCount)
                
                
                if self.documentsCount == "1" {
                    self.noDataLabel.isHidden = false
                    self.discussionCollectionView.isHidden = true
                }
                else {
                    self.noDataLabel.isHidden = true
                    self.discussionCollectionView.isHidden = false
                    print(querySnapshot!.documents.count)
                    for document in querySnapshot!.documents {
                        let docRefOne = self.db.collection(conditionSelected).document(document.documentID)

                        docRefOne.getDocument { (document, error) in

                            let result = Result {
                              try document?.data(as: Discussion.self)

                            }
                            print(result)
                            switch result {
                            case .success(let discussion):
                                if let discussion = discussion {
                                    var discussionDocument = document?.documentID
                                    if document?.documentID == "0" {
                                        print("okay")
                                    }
                                    else {
                                    // A `City` value was successfully initialized from the DocumentSnapshot.
                                        
                                        let docRefOne = self.db.collection("Users").document(Auth.auth().currentUser!.uid)

                                        docRefOne.getDocument { (document, error) in

                                            let result = Result {
                                              try document?.data(as: SavedReference.self)

                                            }
                                            print(result)
                                            switch result {
                                            case .success(let saved):
                                                if let saved = saved {
                                                    // A `City` value was successfully initialized from the DocumentSnapshot.
                                                    let newDate = self.dateFormatter.date(from: discussion.date!)
                                                    self.discussionSaved = saved.saved!
                                                    print(self.discussionSaved)
                                                    
                                                    print(discussionDocument)
                                                    
                                                    self.db.collection(conditionSelected).document(discussionDocument!).collection("comments")
                                                        .getDocuments() { (querySnapshot, err) in
                                                            if let err = err {
                                                                print("Error getting documents: \(err)")
                                                            } else {
                                                                print(querySnapshot!.documents.count)
                                                                
                                                                                    
                                                                    self.unsortedDiscussions.append(DiscussionStruct.init(discussionsTitle: discussion.discussion!, discussionsUser: discussion.user!, discussionDates: newDate!, discussionViews: Int(discussion.views!)!, discussionCommentCount: (querySnapshot!.documents.count-1)))
                                                                
                                                            
                                                                    
                                                                    
                                                                    
                                                                   
                                                                    print(self.unsortedDiscussions)
                                                                    
                                                                    self.savedUnsorted = self.unsortedDiscussions
                            //                                        self.discussions.append()
                            //                                        self.discussionDates.append()
                            //                                        self.discussionViews.append()
                            //                                        self.discussionComments.append()
                                                                //self.questionLabel.text = question.question
                                                                    print(self.unsortedDiscussions.count)
                                                                    print(self.documentsCount)
                                                    
                                                                    if self.unsortedDiscussions.count == Int(self.documentsCount)! - 1 {
                                                                        print("reloading"...)
                                                                        if self.currentFilter == "Views" {
                                                                            self.sortedDiscussions = self.unsortedDiscussions.sorted(by: {$0.discussionViews > $1.discussionViews})
                                                                            print(self.sortedDiscussions.map({$0.discussionsTitle}))
                                                                            self.completionNumber = 1
                                                                        }
                                                                        else {
                                                                            self.sortedDiscussions = self.unsortedDiscussions.sorted(by: {$0.discussionDates.compare($1.discussionDates) == .orderedDescending})
                                                                            print(self.sortedDiscussions.map({$0.discussionsTitle}))
                                                                            self.completionNumber = 1
                                                                        }
                                                                        
                                                                        var i = 0
                                                                        
                                                                        while i < self.sortedDiscussions.count {
                                                                            if self.sortedDiscussions.map({$0.discussionsTitle})[i] == " " {
                                                                                self.sortedDiscussions.remove(at: i)
                                                                                i = -1
                                                                            }
                                                                            i += 1
                                                                            
                                                                        }
                                                                        
                                                                        
                                                            
                                                                        self.discussionCollectionView.reloadData()
                                                                        
                                                                        self.discussionCollectionView.dataSource = self
                                                                        self.discussionCollectionView.delegate = self
                                                                        
                                                                        self.activityIndicator.stopAnimating()
                                                                    }
                                                                    //self.questionLabel.text = question.question
                                                                    print("okay")
                                                            }
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
                        print("\(document.documentID) => \(document.data())")
                        
                    }
            }
        }

        }
        
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        let controller = AddDiscussionViewController()
        controller.delegate = self
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let addDiscussionViewController = storyBoard.instantiateViewController(withIdentifier: "addDiscussionViewController") as! AddDiscussionViewController
        addDiscussionViewController.delegate = self
        
        addDiscussionViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        addDiscussionViewController.popoverPresentationController!.delegate = self
        
        self.present(addDiscussionViewController, animated:true, completion:nil)
        
        
        present(controller, animated: true, completion: nil)
        //performSegue(withIdentifier: "addDiscussionSegue", sender: self)
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller
    }
    */
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }

}

extension DiscussionNewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case searchCollectionView:
            return CGSize(width: 80, height: 175)
        case discussionCollectionView:
            return CGSize(width: 80, height: 175)
        default:
            return CGSize(width: 80, height: 175)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case searchCollectionView:
            return searchedDiscussion.count
        case discussionCollectionView:
            return self.sortedDiscussions.map({$0.discussionsTitle}).count
        default:
            return 1
        }
        print("Discussions Count = " + String(discussions.count))
        return self.sortedDiscussions.map({$0.discussionsTitle}).count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case searchCollectionView:
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchDiscussionCell", for: indexPath) as? SearchDiscussionCollectionViewCell
            cell?.discussionLabel.text = searchedDiscussion[indexPath.row]
            
            cell?.backgroundColor = UIColor.white
            
            cell?.layer.cornerRadius = 10
            return cell!
            
            
        case discussionCollectionView:
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discussionCell", for: indexPath) as? DiscussionNewCollectionViewCell
        
            var displayedDate = sortedDiscussions.map({dateFormatter.string(from:$0.discussionDates)})
                    
//            var dateDisplayed:String = String(self.sortedDiscussions!.map({dateFormatter!.string(from:$0.discussionDates!)!}!)!)! ?? ""
            print(String(testString[..<testString.index(testString.startIndex, offsetBy:10)]))

            cell?.discussionLabel.text = self.sortedDiscussions.map({$0.discussionsTitle})[indexPath.row]
            cell?.discussionNewDate.text = String(displayedDate[indexPath.row][..<displayedDate[indexPath.row].index(displayedDate[indexPath.row].startIndex, offsetBy:10)])
            
            cell?.discussionNewViews.text = self.sortedDiscussions.map({String($0.discussionViews)})[indexPath.row] + " views"
            cell?.discussionNewComments.text = self.sortedDiscussions.map({String($0.discussionCommentCount)})[indexPath.row]
            
            print(cell?.discussionLabel.text)
            print(discussionSaved)
            if self.discussionSaved.contains((cell?.discussionLabel.text)!) {
                cell?.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                
            }
            else {
                cell?.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                
            }
            
            cell?.bookmarkButton.addTarget(self, action: #selector(bookmarkTapped(sender:)), for: .touchUpInside)
            
            cell?.bookmarkButton.tag = indexPath.row
            
            
            cell?.backgroundColor = UIColor.white
            
            cell?.layer.cornerRadius = 10
            
            
            
            
            return cell!
        default:
            var cell = UICollectionViewCell()
            print("error")
            return cell
        
        
        
    }
    }
    
    @objc func fillBookmarkTapped(sender:UIButton) {
        
        
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
       
       
        print(self.sortedDiscussions.map({$0.discussionsTitle}))
        
        
        
    }
    @objc func bookmarkTapped(sender:UIButton) {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        
        if self.discussionSaved.contains((self.sortedDiscussions.map({$0.discussionsTitle})[indexpath1.row])) {
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                "saved": FieldValue.arrayRemove([self.sortedDiscussions.map({$0.discussionsTitle})[indexpath1.row]
                                                ])])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("savedDiscussions").whereField("savedDiscussionTitle", isEqualTo: self.sortedDiscussions.map({$0.discussionsTitle})[indexpath1.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("savedDiscussions").document(document.documentID).updateData(["savedDiscussionTitle": " "])
                            
                        }
                    }
            }
            
            
            var index = 0
            var i = 1
            print(discussionSaved.count)
            print(discussionSaved)
            print(self.sortedDiscussions.map({$0.discussionsTitle})[indexpath1.row])
            while i < discussionSaved.count {
                if discussionSaved[i] == self.sortedDiscussions.map({$0.discussionsTitle})[indexpath1.row] {
                    index = i
                }
                i+=1
            }
            
            print(index)
            discussionSaved.remove(at: index)
            print(discussionSaved)
            
            discussionCollectionView.reloadData()
        }
        
        else {
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["saved": FieldValue.arrayUnion([self.sortedDiscussions.map({$0.discussionsTitle})[indexpath1.row]
                                                ])])
            
            db.collection("Users").document(Auth.auth().currentUser!.uid).collection("savedDiscussions").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let discussionsCreatedDocumentCount = querySnapshot!.documents.count
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                    let date = Date()
                    
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("savedDiscussions").document(String(discussionsCreatedDocumentCount)).setData(["savedDiscussionTitle": self.sortedDiscussions.map({$0.discussionsTitle})[indexpath1.row], "savedDiscussionDate": dateFormatter.string(from: self.sortedDiscussions.map({$0.discussionDates})[indexpath1.row]), "savedDiscussionSavedDate": dateFormatter.string(from: date), "conditionSelected": conditionSelected])
                    
                }
            }
                
            print(discussionSaved)
            discussionSaved.append(self.sortedDiscussions.map({$0.discussionsTitle})[indexpath1.row])
            print(discussionSaved)
            discussionCollectionView.reloadData()
            
        }
            
        
        
     
       
        print(self.sortedDiscussions.map({$0.discussionsTitle}))

        
            
        
        
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideKeyboard()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView{
        case searchCollectionView:
            selectedDiscussion = searchedDiscussion[indexPath.row]
            performSegue(withIdentifier: "toDiscussionPost", sender: self)
            
        case discussionCollectionView:
            selectedDiscussion = self.sortedDiscussions.map({$0.discussionsTitle})[indexPath.row]
            performSegue(withIdentifier: "toDiscussionPost", sender: self)
            
        default:
            print("error")
        }
        
        print(selectedDiscussion)

        
        
    }
    
 
    
    
    
}

extension DiscussionNewViewController: AddDiscussionDelegate {
    func addDiscussion() {
        
        getDiscussionData()


    }
}


extension DiscussionNewViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedDiscussion = self.sortedDiscussions.map({$0.discussionsTitle}).flatMap({ $0 }).filter ({
            $0.lowercased().contains(searchText.lowercased())})
        searchCollectionView.isHidden = false
        
        searchCollectionView.reloadData()
        if searchBar.text == "" {
            searchCollectionView.isHidden = true
        }
    }
    

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
        searchBar.text = ""
        searchCollectionView.reloadData()
        searchCollectionView.isHidden = true
    }
}

