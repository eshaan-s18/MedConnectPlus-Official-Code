//
//  ConditionsViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/11/22.
//

import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

var totalCount = 0
var conditionSelected = ""

// MARK: - Conditions Page
class ConditionsViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var conditionsData = [Condition]()
    
    var pinnedConditions = [""]
    
    @IBOutlet weak var conditionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.backButtonTitle = "345678"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = categorySelected
        
        conditionsTableView.layer.cornerRadius = 10
        conditionsTableView.delegate = self
        conditionsTableView.dataSource = self
        
        
        if #available(iOS 15.0, *) {
            conditionsTableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
            
        }

        
    }
    
    @objc func getPinned() {
        let docRef = db.collection("Users").document(Auth.auth().currentUser!.uid)
        
                docRef.getDocument { (document, error) in
        
                    let result = Result {
                      try document?.data(as: PinnedReference.self)
        
                    }
                    print(result)
                    switch result {
                    case .success(let pinned):
                        if let pinned = pinned {
                            self.pinnedConditions = pinned.pinned!
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding question: \(error)")
                        }
                    }
    }
    

}

// MARK: - Conditions TableView Setup
extension ConditionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalCount = conditionsNames.count
        return conditionsNames.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        conditionSelected = conditionsNames[indexPath.row]
        self.conditionsTableView.deselectRow(at: indexPath, animated: false)

        performSegue(withIdentifier: "toDiscussionFromConditions", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conditionsCell", for: indexPath) as! ConditionTableViewCell


        cell.titleLabel.numberOfLines = 2
        cell.titleLabel.font = UIFont(name: "Manrope", size: 18)!
        cell.titleLabel.text = conditionsNames[indexPath.row]

        
        let docRef = db.collection("Users").document(Auth.auth().currentUser!.uid)

        docRef.getDocument { (document, error) in

            let result = Result {
              try document?.data(as: PinnedReference.self)

            }
            print(result)
            switch result {
            case .success(let pinned):
                if let pinned = pinned {
                    if pinned.pinned!.contains(conditionsNames[indexPath.row]) {
                        cell.pinImage.isHidden = false
                    }
                    else {
                        cell.pinImage.isHidden = true
                    }
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding question: \(error)")
                }
            }
        
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .white
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let pin = UIContextualAction(style: .normal, title: "Pin") { action, _, _ in
            

            
            let docRef = self.db.collection("Users").document(Auth.auth().currentUser!.uid)

            docRef.getDocument { (document, error) in

                let result = Result {
                  try document?.data(as: PinnedReference.self)

                }
                print(result)
                switch result {
                case .success(let pinned):
                    if let pinned = pinned {
                        if pinned.pinned!.contains(conditionsNames[indexPath.row]) {
                            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                                "pinned": FieldValue.arrayRemove([conditionsNames[indexPath.row]])
                                ])
                            self.getPinned()
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                        else {
                            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                                "pinned": FieldValue.arrayUnion([conditionsNames[indexPath.row]])
                                ])
                            self.getPinned()
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    } else {
                        print("Document does not exist")
                    }
                case .failure(let error):
                    print("Error decoding question: \(error)")
                    }
                }
            
            print("success")
            
        }
        
        
        if pinnedConditions.contains(conditionsNames[indexPath.row]) {
            pin.backgroundColor = UIColor.systemIndigo
            pin.image = UIImage(systemName: "pin.slash.fill")
        }
        else {
            pin.backgroundColor = UIColor.systemIndigo
            pin.image = UIImage(systemName: "pin.fill")
        }
        
            
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [pin])
        
        return swipeConfiguration
    }
    }
