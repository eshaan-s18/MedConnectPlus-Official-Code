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
        
        
        conditionsTableView.layer.cornerRadius = 10

        
        conditionsTableView.delegate = self
        conditionsTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        navigationItem.title = categorySelected
        
        
        if #available(iOS 15.0, *) {
            conditionsTableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
            
        }
        
        //getPinned()

//        
//        for condition in conditionsNames {
//            db.collection(condition).document("0").setData(["discussion" : "no discussion"])
//        }
        

        
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
                            // A `City` value was successfully initialized from the DocumentSnapshot.
                            
                            self.pinnedConditions = pinned.pinned!
                            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConditionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalCount = conditionsNames.count
        print("*******************TOTALCOUNT******************* =  " + String(totalCount))
        return conditionsNames.count
        
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return conditionsData[section].conditionCategory
//
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        conditionSelected = conditionsNames[indexPath.row]
        self.conditionsTableView.deselectRow(at: indexPath, animated: false)

        performSegue(withIdentifier: "toDiscussionFromConditions", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conditionsCell", for: indexPath) as! ConditionTableViewCell

//
        cell.titleLabel.numberOfLines = 2
        cell.titleLabel.font = UIFont(name: "Manrope", size: 18)!
        cell.titleLabel.text = conditionsNames[indexPath.row]
//
//        cell.subtitleLabel.numberOfLines = 1
//        cell.subtitleLabel.font = UIFont(name: "Manrope", size: 12)!
//        cell.subtitleLabel.text = conditionsNames[indexPath.row]
//
        
        let docRef = db.collection("Users").document(Auth.auth().currentUser!.uid)

        docRef.getDocument { (document, error) in

            let result = Result {
              try document?.data(as: PinnedReference.self)

            }
            print(result)
            switch result {
            case .success(let pinned):
                if let pinned = pinned {
                    // A `City` value was successfully initialized from the DocumentSnapshot.
                    if pinned.pinned!.contains(conditionsNames[indexPath.row]) {
                        cell.pinImage.isHidden = false
                    }
                    else {
                        cell.pinImage.isHidden = true
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
        
    
        
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//
//        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//
//                var content = header.defaultContentConfiguration()
//        //
//        //        content.text = conditionsArray[indexPath.row]
//        //        content.textProperties.numberOfLines = 2
//        //        content.secondaryText = conditionsSubtitlesArray[indexPath.row]
//        //        content.secondaryTextProperties.font = UIFont(name: "Manrope", size: 12)!
//        //        content.secondaryTextProperties.color = UIColor.darkGray
//        //        content.secondaryTextProperties.numberOfLines = 1
//        //        content.textProperties.font = UIFont(name: "Manrope", size: 18)!
//        //        cell.contentConfiguration = content
//
//        content.textProperties.font = UIFont(name: "Manrope", size: 14)!
//
//
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .white
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
//
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let pin = UIContextualAction(style: .normal, title: "Pin") { _, _, _ in
//            print("Pinned")
//        }
//        pin.backgroundColor = UIColor.systemIndigo
//        pin.image = UIImage(systemName: "pin.fill")
//
//        let swipeConfiguration = UISwipeActionsConfiguration(actions: [pin])
//
//        return swipeConfiguration
//    }
    
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "conditionsCell", for: indexPath) as! ConditionTableViewCell
        
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
                        // A `City` value was successfully initialized from the DocumentSnapshot.
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
            
            print("success")
            
        }
        
//        let docRef = db.collection("Users").document(Auth.auth().currentUser!.uid)
//
//        docRef.getDocument { (document, error) in
//
//            let result = Result {
//              try document?.data(as: PinnedReference.self)
//
//            }
//            print(result)
//            switch result {
//            case .success(let pinned):
//                if let pinned = pinned {
//                    // A `City` value was successfully initialized from the DocumentSnapshot.
//                    if pinned.pinned!.contains() {
//                        pin.backgroundColor = UIColor.systemIndigo
//                        pin.image = UIImage(systemName: "pin.slash.fill")
//                    }
//                    else {
//                        pin.backgroundColor = UIColor.systemIndigo
//                        pin.image = UIImage(systemName: "pin.fill")
//                    }
//                    //self.questionLabel.text = question.question
//                    print("okay")
//                } else {
//                    // A nil value was successfully initialized from the DocumentSnapshot,
//                    // or the DocumentSnapshot was nil.
//                    print("Document does not exist")
//                }
//            case .failure(let error):
//                // A `City` value could not be initialized from the DocumentSnapshot.
//                print("Error decoding question: \(error)")
//                }
//            }
        
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
