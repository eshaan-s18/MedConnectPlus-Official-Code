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

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    

    @IBOutlet weak var greeting: UILabel!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.hidesBackButton = true
        
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        
        navigationItem.backButtonDisplayMode = .minimal

        
      
        
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
