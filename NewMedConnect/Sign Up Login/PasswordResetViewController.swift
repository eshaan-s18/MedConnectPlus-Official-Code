//
//  PasswordResetViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/2/22.
//

import UIKit
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        resetButton.layer.cornerRadius = 10
        
        loading.hidesWhenStopped = true
    }
    @objc private func errorVibration() {
        HapticsManager.shared.vibrate(for: .error)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        self.resetButton.frame.origin.y = UIScreen.main.fixedCoordinateSpace.bounds.height - 170
        self.errorMessage.frame.origin.y = UIScreen.main.fixedCoordinateSpace.bounds.height - 215
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            //let bottomSpace = self.view.frame.height - (nextButton.frame.origin.y + nextButton.frame.height)
            
            self.resetButton.frame.origin.y -= keyboardHeight
            self.errorMessage.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide() {
        self.resetButton.frame.origin.y = UIScreen.main.fixedCoordinateSpace.bounds.height - 170
        self.errorMessage.frame.origin.y = UIScreen.main.fixedCoordinateSpace.bounds.height - 215
    }
        
    
    func checkEmail(completion:@escaping((Bool) -> () )) {
        db.collection("Users").whereField("email", isEqualTo: emailTextField.text!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("DNE")
                completion(false)
            }
            else {
                if (querySnapshot!.count > 0){
                    print("Exists")
                    completion(false)
                } else {
                    print("DNE")
                    completion(true)
                }
                
                
            }
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        if emailTextField.text!.count >= 1 {
            loading.startAnimating()
            checkEmail { result in
                if (result == false) {
                    self.errorMessage.isHidden = true
                    self.loading.stopAnimating()
                    Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!) { (error) in
                        if let error = error {
                            print("Error")
                            let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        let alert = Service.createAlertController(title: "Success", message: "A password reset email has been sent. Please check your junk/spam folder if you did not receive an email. ")
                        self.present(alert, animated: true, completion: nil)
                        
                    }

                }
                else {
                    self.loading.stopAnimating()
                    self.errorMessage.text = "Email address not found."
                    self.errorMessage.isHidden = false
                    self.errorVibration()
                    
                }
            }
        } else {
            self.errorMessage.text = "Please type in your email address."
            self.errorMessage.isHidden = false
            self.errorVibration()
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
