//
//  HomeViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/2/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct YourDiscussionStruct {
    var yourDiscussionTitle:String
    var yourDiscussionDate:String
    var conditionSelected:String
}

struct SavedDiscussionStruct {
    var savedDiscussionTitle:String
    var savedDiscussionDate:String
    var savedDiscussionSavedDate:String
    var conditionSelected:String
}

// MARK: - Home Page
class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var createdDiscussionsCollected = 0
    
    let refreshControl = UIRefreshControl()
    
    var yourDiscussions = [YourDiscussionStruct]()
    
    var savedDiscussions = [SavedDiscussionStruct]()
    
    @IBOutlet weak var greeting: UILabel!
    
    @IBOutlet weak var welcomeView: UIView!
    
    @IBOutlet weak var yourDiscussionsCollectionView: UICollectionView!
    
    @IBOutlet weak var savedDiscussionsCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollControl: UIPageControl!
    
    @IBOutlet weak var savedScrollControl: UIPageControl!
    
    @IBOutlet weak var yourDiscussionsView: UIView!
    
    @IBOutlet weak var savedDiscussionsView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var savedLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noCreatedDiscussions: UILabel!
    
    @IBOutlet weak var noSavedDiscussions: UILabel!
    
    var skippedDocs = 0
    var savedSkippedDocs = 0
    
    var currentIndex = 0
    var savedCurrentIndex = 0
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authAndConfig()
        
        yourDiscussionsView.layer.cornerRadius = 25
        savedDiscussionsView.layer.cornerRadius = 25
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.backgroundColor = UIColor.systemGray6
        navigationItem.hidesBackButton = true
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationItem.backButtonDisplayMode = .minimal
        
        tabBarController?.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        savedLoadingIndicator.hidesWhenStopped = true
        savedLoadingIndicator.startAnimating()
        
        welcomeView.layer.cornerRadius = 25
        
        scrollControl.isHidden = true
        savedScrollControl.isHidden = true
        
    }
    
    @objc func refresh() {
        getData()
        self.scrollView.refreshControl?.endRefreshing()
        
    }
    
    @IBAction func acknowledgementsTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Acknowledgements", message: "Special thanks to Daniel Cohen Gindi & Philipp Jahoda for Charts | Special thanks to Firebase", preferredStyle: .alert)
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
    
    func getData() {
        createdDiscussionsCollected = 0
        currentIndex = 0
        savedCurrentIndex = 0
        yourDiscussions = [YourDiscussionStruct]()
        skippedDocs = 0
        savedSkippedDocs = 0
        savedDiscussions = [SavedDiscussionStruct]()
        
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("discussions").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let discussionsCreatedDocumentCount = querySnapshot!.documents.count
                
                for document in querySnapshot!.documents {
                    let documentID = document.documentID
                    
                    if documentID == "" {
                        print("skip")
                    }
                    else {
                        
                        let docRef = self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("discussions").document(documentID)
                        
                        docRef.getDocument { (document, error) in
                            
                            let result = Result {
                                try document?.data(as: YourDiscussionReference.self)
                                
                            }
                            print(result)
                            switch result {
                            case .success(let discussion):
                                if let discussion = discussion {
                                    
                                    if documentID != "0" {
                                        if discussion.yourDiscussionTitle!.prefix(1) == " " {
                                            self.skippedDocs += 1
                                        }
                                        else {
                                            self.yourDiscussions.append(YourDiscussionStruct(yourDiscussionTitle: discussion.yourDiscussionTitle!, yourDiscussionDate: discussion.yourDiscussionDate!, conditionSelected: discussion.conditionSelected!))
                                        }
                                    }
                                    
                                    if self.skippedDocs == (querySnapshot?.documents.count)! - 1 {
                                        self.yourDiscussionsCollectionView.isHidden = true
                                        self.noCreatedDiscussions.isHidden = false
                                        self.yourDiscussionsView.isHidden = false
                                        self.loadingIndicator.stopAnimating()
                                    }
                                    else if self.skippedDocs < (querySnapshot?.documents.count)! - 1{
                                        self.yourDiscussionsCollectionView.isHidden = false
                                        self.noCreatedDiscussions.isHidden = true
                                        self.yourDiscussionsView.isHidden = true
                                    }
                                    
                                    self.createdDiscussionsCollected += 1
                                    if self.yourDiscussions.count == discussionsCreatedDocumentCount - 1 - self.skippedDocs && self.createdDiscussionsCollected == discussionsCreatedDocumentCount {
                                        
                                        self.yourDiscussions = self.yourDiscussions.sorted(by: {$0.yourDiscussionDate.compare($1.yourDiscussionDate) == .orderedDescending})
                                        
                                        self.savedSkippedDocs = 0
                                        
                                        self.yourDiscussionsCollectionView.reloadData()
                                        self.yourDiscussionsCollectionView.delegate = self
                                        self.yourDiscussionsCollectionView.dataSource = self
                                        
                                        self.scrollControl.numberOfPages = self.yourDiscussions.count
                                        self.loadingIndicator.stopAnimating()
                                        self.scrollControl.isHidden = false
                                        
                                        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("savedDiscussions").getDocuments() { (querySnapshot, err) in
                                            if let err = err {
                                                print("Error getting documents: \(err)")
                                            } else {
                                                let savedDiscussionsDocumentCount = querySnapshot!.documents.count
                                                
                                                for document in querySnapshot!.documents {
                                                    let savedDocumentID = document.documentID
                                                                                                        
                                                    if savedDocumentID == "" {
                                                        print("skip")
                                                    }
                                                    
                                                    
                                                    else {
                                                        
                                                        let docRef2 = self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("savedDiscussions").document(savedDocumentID)
                                                        
                                                        docRef2.getDocument { (document, error) in
                                                            
                                                            let result = Result {
                                                                try document?.data(as: SavedDiscussionReference.self)
                                                                
                                                            }
                                                            print(result)
                                                            switch result {
                                                            case .success(let savedDiscussion):
                                                                if let savedDiscussion = savedDiscussion {
                                                                    if savedDiscussion.savedDiscussionTitle!.prefix(1) == " " {
                                                                        self.savedSkippedDocs += 1
                                                                        
                                                                    }
                                                                    else {
                                                                        self.savedDiscussions.append(SavedDiscussionStruct(savedDiscussionTitle: savedDiscussion.savedDiscussionTitle!, savedDiscussionDate: savedDiscussion.savedDiscussionDate!, savedDiscussionSavedDate: savedDiscussion.savedDiscussionSavedDate!, conditionSelected: savedDiscussion.conditionSelected!))
                                                                    }
                                                                    
                                                                    if self.savedSkippedDocs == (querySnapshot?.documents.count)! - 1 {
                                                                        self.savedDiscussionsCollectionView.isHidden = true
                                                                        self.noSavedDiscussions.isHidden = false
                                                                        self.savedDiscussionsView.isHidden = false
                                                                        self.savedLoadingIndicator.stopAnimating()
                                                                    }
                                                                    else if self.savedSkippedDocs < (querySnapshot?.documents.count)! - 1{
                                                                        self.savedDiscussionsCollectionView.isHidden = false
                                                                        self.noSavedDiscussions.isHidden = true
                                                                        self.savedDiscussionsView.isHidden = true
                                                                    }
                                                                    if self.savedDiscussions.count == savedDiscussionsDocumentCount - 1 - self.savedSkippedDocs {
                                                                        
                                                                        self.savedDiscussions = self.savedDiscussions.sorted(by: {$0.savedDiscussionSavedDate.compare($1.savedDiscussionSavedDate) == .orderedDescending})
                                                                        
                                                                        
                                                                        
                                                                        self.savedDiscussionsCollectionView.reloadData()
                                                                        self.savedDiscussionsCollectionView.delegate = self
                                                                        self.savedDiscussionsCollectionView.dataSource = self
                                                                        
                                                                        self.savedScrollControl.numberOfPages = self.savedDiscussions.count
                                                                        self.savedLoadingIndicator.stopAnimating()
                                                                        self.savedScrollControl.isHidden = false
                                                                        
                                                                    }
                                                                    
                                                                    
                                                                    print("okay")
                                                                } else {
                                                                    print("Document does not exist")
                                                                }
                                                            case .failure(let error):
                                                                print("Error decoding question: \(error)")
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                    
                                    print("okay")
                                } else {
                                    print("Document does not exist")
                                }
                            case .failure(let error):
                                print("Error decoding question: \(error)")
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func howToUseButtonTapped(_ sender: Any) {
        var howToUseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HowToUseViewController")
        if let sheet = howToUseVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 10
            
        }
        
        self.present(howToUseVC, animated: true, completion: nil)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    
    @objc func handleSignOut() {
        let alert = Service.createAlertController(title: "Log Out", message: "Are you sure you want to log out?")
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toLoginPageSegue", sender: self)
        } catch let error {
            let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func authAndConfig() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toLoginPageSegue", sender: self)
            }
        }
        else{
            getData()
            
        }
    }
    
    
    @IBAction func logOutTapped(_ sender: Any) {
        handleSignOut()
        
    }
    
    @IBAction func yourInformationTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "popoverSegue", sender: self)
    }
    
}

// MARK: - Your Discussions and Saved Discussions CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case yourDiscussionsCollectionView:
            return yourDiscussions.count
        case savedDiscussionsCollectionView:
            return savedDiscussions.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case yourDiscussionsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourDiscussionsCell", for: indexPath) as? YourDiscussionsCollectionViewCell
            
            cell?.yourDiscussionTitle.text = yourDiscussions.map({$0.yourDiscussionTitle})[indexPath.row]
            let displayedDate = yourDiscussions.map({$0.yourDiscussionDate})
            
            cell?.yourDiscussionDate.text = String(displayedDate[indexPath.row][..<displayedDate[indexPath.row].index(displayedDate[indexPath.row].startIndex, offsetBy:10)])
            
            
            cell?.layer.cornerRadius = 25
            return cell!
        case savedDiscussionsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedDiscussionsCollectionViewCell", for: indexPath) as? SavedDiscussionsCollectionViewCell
            
            cell?.savedDiscussionTitle.text = savedDiscussions.map({$0.savedDiscussionTitle})[indexPath.row]
            let savedDisplayedDate = savedDiscussions.map({$0.savedDiscussionDate})
            
            
            cell?.savedDiscussionDate.text = savedDisplayedDate[indexPath.row]
            
            
            cell?.layer.cornerRadius = 25
            return cell!
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedDiscussionsCollectionViewCell", for: indexPath) as? SavedDiscussionsCollectionViewCell
            return cell!
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width-40, height: collectionView.frame.height)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case yourDiscussionsCollectionView:
            conditionSelected = yourDiscussions.map({$0.conditionSelected})[indexPath.row]
            selectedDiscussion = yourDiscussions.map({$0.yourDiscussionTitle})[indexPath.row]
            
            
            var discussionPostVC = UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "DiscussionPostViewController")
            
            if let sheet = discussionPostVC.sheetPresentationController {
                sheet.prefersGrabberVisible = true
                
            }
            
            self.present(discussionPostVC, animated: true, completion: nil)
        case savedDiscussionsCollectionView:
            conditionSelected = savedDiscussions.map({$0.conditionSelected})[indexPath.row]
            selectedDiscussion = savedDiscussions.map({$0.savedDiscussionTitle})[indexPath.row]
            
            
            var discussionPostVC = UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "DiscussionPostViewController")
            
            if let sheet = discussionPostVC.sheetPresentationController {
                sheet.prefersGrabberVisible = true
                
            }
            
            self.present(discussionPostVC, animated: true, completion: nil)
        default:
            print("error")
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView{
        case savedDiscussionsCollectionView:
            savedCurrentIndex = Int(scrollView.contentOffset.x / savedDiscussionsCollectionView.frame.size.width)
            savedScrollControl.currentPage = savedCurrentIndex
        case yourDiscussionsCollectionView:
            currentIndex = Int(scrollView.contentOffset.x / yourDiscussionsCollectionView.frame.size.width)
            scrollControl.currentPage = currentIndex
        default:
            print("error")
        }
        
        
        
    }
    
}
