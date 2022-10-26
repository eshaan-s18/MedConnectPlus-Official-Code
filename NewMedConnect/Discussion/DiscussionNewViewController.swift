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

struct DiscussionStruct {
    var discussionsTitle:String
    var discussionsUser:String
    var discussionDates:Date
    var discussionViews:Int
    var discussionCommentCount:Int
}

var selectedDiscussion = ""

// MARK: - Discussions Page
class DiscussionNewViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var db = Firestore.firestore()
        
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var discussionCollectionView: UICollectionView!
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    @IBOutlet weak var sortedByLabel: UILabel!
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
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
    
    var taskCompletionIndicator = 0
    
    var currentFilter = "Views"
    
    var searchedDiscussion = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true

        searchCollectionView.alwaysBounceVertical = true
        searchCollectionView.isHidden = true
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = conditionSelected
        
        searchBar.layer.borderWidth = 0
        searchBar.layer.borderColor = UIColor.systemGray6.cgColor
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        discussionCollectionView.refreshControl = refreshControl

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
        }
    }
    
    @objc func refresh() {
        getDiscussionData()
        
        self.discussionCollectionView.refreshControl?.endRefreshing()
        
    }
    

    @objc func getDiscussionData() {
        documentsCount = ""
        taskCompletionIndicator = 0
        
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
                
                if self.documentsCount == "1" {
                    self.noDataLabel.isHidden = false
                    self.discussionCollectionView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    
                }
                else {
                    self.noDataLabel.isHidden = true
                    self.discussionCollectionView.isHidden = false
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
                                        print("Skipped Document")
                                    }
                                    else {
                                        let docRefOne = self.db.collection("Users").document(Auth.auth().currentUser!.uid)

                                        docRefOne.getDocument { (document, error) in

                                            let result = Result {
                                              try document?.data(as: SavedReference.self)

                                            }
                                            print(result)
                                            switch result {
                                            case .success(let saved):
                                                if let saved = saved {
                                                    let newDate = self.dateFormatter.date(from: discussion.date!)
                                                    self.discussionSaved = saved.saved!
                                                    
                                                    self.db.collection(conditionSelected).document(discussionDocument!).collection("comments")
                                                        .getDocuments() { (querySnapshot, err) in
                                                            if let err = err {
                                                                print("Error getting documents: \(err)")
                                                            } else {
                                                                                    
                                                                    self.unsortedDiscussions.append(DiscussionStruct.init(discussionsTitle: discussion.discussion!, discussionsUser: discussion.user!, discussionDates: newDate!, discussionViews: Int(discussion.views!)!, discussionCommentCount: (querySnapshot!.documents.count-1)))
                                                                                                                                    
                                                                    self.savedUnsorted = self.unsortedDiscussions
                                                                        
                                                                    if self.unsortedDiscussions.count == Int(self.documentsCount)! - 1 {
                                                                        print("reloading"...)
                                                                        if self.currentFilter == "Views" {
                                                                            self.sortedDiscussions = self.unsortedDiscussions.sorted(by: {$0.discussionViews > $1.discussionViews})
                                                                            print(self.sortedDiscussions.map({$0.discussionsTitle}))
                                                                            self.taskCompletionIndicator = 1
                                                                        }
                                                                        else {
                                                                            self.sortedDiscussions = self.unsortedDiscussions.sorted(by: {$0.discussionDates.compare($1.discussionDates) == .orderedDescending})
                                                                            self.taskCompletionIndicator = 1
                                                                        }
                                                                        
                                                                        var i = 0
                                                                        
                                                                        while i < self.sortedDiscussions.count {
                                                                            if self.sortedDiscussions.map({$0.discussionsTitle})[i] == " " {
                                                                                self.sortedDiscussions.remove(at: i)
                                                                                i = -1
                                                                            }
                                                                            i += 1
                                                                            
                                                                        }
                                                                        
                                                                        if self.sortedDiscussions.count == 0 {
                                                                            self.noDataLabel.isHidden = false
                                                                            self.discussionCollectionView.isHidden = true
                                                                            self.activityIndicator.stopAnimating()
                                                                        }
                                                                        
                                                                            self.discussionCollectionView.reloadData()
                                                                            self.discussionCollectionView.dataSource = self
                                                                            self.discussionCollectionView.delegate = self
                                                                        
                                                                        self.activityIndicator.stopAnimating()
                                                                    }
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
                                } else {
                                    print("Document does not exist")
                                }
                            case .failure(let error):
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
    }
    
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }

}

// MARK: - Discussions and Search Discussions CollectionView Setup
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
                    
            cell?.discussionLabel.text = self.sortedDiscussions.map({$0.discussionsTitle})[indexPath.row]
            cell?.discussionNewDate.text = String(displayedDate[indexPath.row][..<displayedDate[indexPath.row].index(displayedDate[indexPath.row].startIndex, offsetBy:10)])
            
            cell?.discussionNewViews.text = self.sortedDiscussions.map({String($0.discussionViews)})[indexPath.row] + " views"
            cell?.discussionNewComments.text = self.sortedDiscussions.map({String($0.discussionCommentCount)})[indexPath.row]
            
            
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
            while i < discussionSaved.count {
                if discussionSaved[i] == self.sortedDiscussions.map({$0.discussionsTitle})[indexpath1.row] {
                    index = i
                }
                i+=1
            }
            
            discussionSaved.remove(at: index)
            
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
                
            discussionSaved.append(self.sortedDiscussions.map({$0.discussionsTitle})[indexpath1.row])
            discussionCollectionView.reloadData()
            
        }
         
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

