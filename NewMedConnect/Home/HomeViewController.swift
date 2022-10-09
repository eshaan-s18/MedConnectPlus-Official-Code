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

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    
    var yourDiscussions = [YourDiscussionStruct]()
    
    var savedDiscussions = [SavedDiscussionStruct]()

    @IBOutlet weak var greeting: UILabel!
    
    @IBOutlet weak var welcomeView: UIView!
    
    @IBOutlet weak var yourDiscussionsCollectionView: UICollectionView!
    
    @IBOutlet weak var savedDiscussionsCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollControl: UIPageControl!
    
    @IBOutlet weak var savedScrollControl: UIPageControl!
    
    
    let refreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var savedLoadingIndicator: UIActivityIndicatorView!
    
    var skippedDocs = 0
    
    var savedSkippedDocs = 0
    
    
    var currentIndex = 0
    var savedCurrentIndex = 0

    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.hidesBackButton = true
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        scrollView.refreshControl = refreshControl

        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        savedLoadingIndicator.hidesWhenStopped = true
        savedLoadingIndicator.startAnimating()
        
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        
        navigationItem.backButtonDisplayMode = .minimal
        
        welcomeView.layer.cornerRadius = 25

        scrollControl.isHidden = true
        savedScrollControl.isHidden = true
        getData()
      
        
    }
    
    @objc func refresh() {
        getData()
        self.scrollView.refreshControl?.endRefreshing()

        
    }
    
    func getData() {
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
                    
                    if documentID == "0" {
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
                                    // A `City` value was successfully initialized from the DocumentSnapshot.
                                    
                                    if discussion.yourDiscussionTitle!.prefix(1) == " " {
                                        self.skippedDocs += 1
                                    }
                                    else {
                                        self.yourDiscussions.append(YourDiscussionStruct(yourDiscussionTitle: discussion.yourDiscussionTitle!, yourDiscussionDate: discussion.yourDiscussionDate!, conditionSelected: discussion.conditionSelected!))
                                    }
                                        print(self.yourDiscussions)
                                        print(discussionsCreatedDocumentCount)
                                        if self.yourDiscussions.count == discussionsCreatedDocumentCount - 1 - self.skippedDocs {
                                            
                                            self.yourDiscussions = self.yourDiscussions.sorted(by: {$0.yourDiscussionDate.compare($1.yourDiscussionDate) == .orderedDescending})
                                            
                                            print(self.yourDiscussions)
                                            print(self.yourDiscussions.map({$0.yourDiscussionTitle}))
                                            
                                            
                                            
                                            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("savedDiscussions").getDocuments() { (querySnapshot, err) in
                                                if let err = err {
                                                    print("Error getting documents: \(err)")
                                                } else {
                                                    let savedDiscussionsDocumentCount = querySnapshot!.documents.count
                                                    
                                                    for document in querySnapshot!.documents {
                                                        let savedDocumentID = document.documentID
                                                        
                                                        if savedDocumentID == "0" {
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
                                                                        // A `City` value was successfully initialized from the DocumentSnapshot.
                                                                        
                                                                        if savedDiscussion.savedDiscussionTitle!.prefix(1) == " " {
                                                                            self.savedSkippedDocs += 1
                                                                        }
                                                                        else {
                                                                            self.savedDiscussions.append(SavedDiscussionStruct(savedDiscussionTitle: savedDiscussion.savedDiscussionTitle!, savedDiscussionDate: savedDiscussion.savedDiscussionDate!, savedDiscussionSavedDate: savedDiscussion.savedDiscussionSavedDate!, conditionSelected: savedDiscussion.conditionSelected!))
                                                                        }
                                                                            print(self.savedDiscussions.count)
                                                                            print(savedDiscussionsDocumentCount)
                                                                            print(self.savedSkippedDocs)
                                                                            print(savedDiscussionsDocumentCount - 1 - self.savedSkippedDocs)
                                                                            if self.savedDiscussions.count == savedDiscussionsDocumentCount - 1 - self.savedSkippedDocs {
                                                                                
                                                                                self.savedDiscussions = self.savedDiscussions.sorted(by: {$0.savedDiscussionSavedDate.compare($1.savedDiscussionSavedDate) == .orderedDescending})
                                                                                
                                                                          
                                                                                
                                                                                self.yourDiscussionsCollectionView.reloadData()
                                                                                self.yourDiscussionsCollectionView.delegate = self
                                                                                self.yourDiscussionsCollectionView.dataSource = self
                                                                                
                                                                                self.scrollControl.numberOfPages = self.yourDiscussions.count
                                                                                self.loadingIndicator.stopAnimating()
                                                                                self.scrollControl.isHidden = false
                                                                                
                                                                                self.savedDiscussionsCollectionView.reloadData()
                                                                                self.savedDiscussionsCollectionView.delegate = self
                                                                                self.savedDiscussionsCollectionView.dataSource = self
                                                                                
                                                                                self.savedScrollControl.numberOfPages = self.savedDiscussions.count
                                                                                self.savedLoadingIndicator.stopAnimating()
                                                                                self.savedScrollControl.isHidden = false
                                                                                
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
                                                        }
                                                    }
                                                }
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
                    }
                }
            }
        }
        
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        authAndConfig()
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
    }
    
    
    @IBAction func logOutTapped(_ sender: Any) {
        handleSignOut()

    }
    
    @IBAction func yourInformationTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "popoverSegue", sender: self)
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
            
            print(yourDiscussions.map({$0.yourDiscussionTitle}))
            cell?.yourDiscussionTitle.text = yourDiscussions.map({$0.yourDiscussionTitle})[indexPath.row]
            let displayedDate = yourDiscussions.map({$0.yourDiscussionDate})

            cell?.yourDiscussionDate.text = String(displayedDate[indexPath.row][..<displayedDate[indexPath.row].index(displayedDate[indexPath.row].startIndex, offsetBy:10)])

            
            cell?.layer.cornerRadius = 25
            return cell!
        case savedDiscussionsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedDiscussionsCollectionViewCell", for: indexPath) as? SavedDiscussionsCollectionViewCell
            
            cell?.savedDiscussionTitle.text = savedDiscussions.map({$0.savedDiscussionTitle})[indexPath.row]
            let savedDisplayedDate = savedDiscussions.map({$0.savedDiscussionDate})
            
            cell?.savedDiscussionDate.text = String(savedDisplayedDate[indexPath.row][..<savedDisplayedDate[indexPath.row].index(savedDisplayedDate[indexPath.row].startIndex, offsetBy:10)])
            
            cell?.layer.cornerRadius = 25
            return cell!
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedDiscussionsCollectionViewCell", for: indexPath) as? SavedDiscussionsCollectionViewCell
            return cell!
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.width)
        print(collectionView.frame.height)
//        return CGSize(width: 350, height: 300)
        return CGSize(width: collectionView.frame.width-40, height: collectionView.frame.height)
        //return CGSize(width: 50, height: 20)
        
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
