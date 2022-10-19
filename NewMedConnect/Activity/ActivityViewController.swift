//
//  ActivityViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 10/18/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct NotificationStruct {
    var notificationTitle:String
    var notificationBody:String
    var notificationDate:String
    var notificationCondition:String
    var notificationDiscussion:String
}

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var activityTableView: UITableView!
    
    @IBOutlet weak var noNotiLabel: UILabel!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    
    var notificationsArray = [NotificationStruct]()
    
    var db = Firestore.firestore()
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loading.hidesWhenStopped = true
        loading.startAnimating()
        
        navigationItem.title = "Activity"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.backgroundColor = UIColor.systemGray6
        
        activityTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        
        getData()
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh() {
        getData()
        activityTableView.reloadData()
        self.activityTableView.refreshControl?.endRefreshing()
    }
    
    func getData() {
        notificationsArray = [NotificationStruct]()
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("notifications").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let totalDocCount = querySnapshot!.documents.count
                for document in querySnapshot!.documents {
                    let docID = document.documentID
                    
                    if docID == "0" {
                        print("skip")
                        self.noNotiLabel.isHidden = false
                        self.loading.stopAnimating()
                    }
                    else {
                        self.activityTableView.isHidden = false
                        self.noNotiLabel.isHidden = true
                        let docRefTwo = self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("notifications").document(docID)
                        
                        docRefTwo.getDocument { (document, error) in
                            
                            let result = Result {
                                try document?.data(as: NotificationReference.self)
                                
                            }
                            print(result)
                            switch result {
                            case .success(let notification):
                                if let notification = notification {
                                    // A `City` value was successfully initialized from the DocumentSnapshot.
                                    //                                let notificationDate = notification.notificationDate?.prefix(10)
                                    
                                    
                                    self.notificationsArray.append(NotificationStruct(notificationTitle: notification.notificationTitle!, notificationBody: notification.notificationBody!, notificationDate: notification.notificationDate!, notificationCondition: notification.notificationCondition!, notificationDiscussion: notification.notificationDiscussion!))
                                    
                                    if self.notificationsArray.count == totalDocCount - 1{
                                        self.notificationsArray = self.notificationsArray.sorted(by: {$0.notificationDate > $1.notificationDate})
                                        self.loading.stopAnimating()
                                        self.activityTableView.dataSource = self
                                        self.activityTableView.delegate = self
                                        self.activityTableView.reloadData()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        
        cell.notificationTitleLabel.text = notificationsArray.map({$0.notificationTitle})[indexPath.row]
        cell.notificationBodyLabel.text = notificationsArray.map({$0.notificationBody})[indexPath.row]
        let notificationDate = notificationsArray.map({$0.notificationDate})[indexPath.row]
        cell.notificationDateLabel.text = String(notificationDate.prefix(10))
        
        
        
        
        
        cell.backgroundColor = UIColor.systemGray6
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        conditionSelected = notificationsArray.map({$0.notificationCondition})[indexPath.row]
        selectedDiscussion = notificationsArray.map({$0.notificationDiscussion})[indexPath.row]
        
        
        var discussionPostVC = UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "DiscussionPostViewController")
        
        if let sheet = discussionPostVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
        self.present(discussionPostVC, animated: true, completion: nil)
    }
}
