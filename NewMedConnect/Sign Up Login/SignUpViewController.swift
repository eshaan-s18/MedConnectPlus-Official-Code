//
//  SignUpViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 5/29/22.
//

import UIKit
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

var sharedEmail = ""
var sharedPassword = ""

var sharedUserID = ""

class SignUpViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordError: UILabel!
    
    @IBOutlet weak var finalError: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var tempNextLocation = 0.0
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempNextLocation = self.nextButton.frame.origin.y
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        // Do any additional setup after loading the view.
        nextButton.layer.cornerRadius = 10.0
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        passwordTextField.addTarget(self, action: #selector(showPasswordError), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(removePasswordError), for: .editingDidBegin)
        
        
        emailTextField.autocorrectionType = .no
        
        loading.hidesWhenStopped = true
        
        let alert = UIAlertController(title: "Reminder", message: "Signing up for an account involves using a valid email. MedConnect allows you to remain completely anonymous while using the app. Your email will only be used for logging in and only be visible to you.", preferredStyle: .alert)
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
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
      
      var returnValue = true
      let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
      
      do {
          let regex = try NSRegularExpression(pattern: emailRegEx)
          let nsString = emailAddressString as NSString
          let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
          
          if results.count == 0
          {
              returnValue = false
          }
          
      } catch let error as NSError {
          print("invalid regex: \(error.localizedDescription)")
          returnValue = false
      }
      
      return  returnValue
  }
    
    @objc private func removePasswordError() {
        passwordError.isHidden = true
    }
    
    @objc private func showPasswordError() {
        if passwordTextField.text!.count >= 1{
            if passwordTextField.text!.count < 8 {
                passwordError.isHidden = false }
            else {
                passwordError.isHidden = true
            }
        }
    }
    
    @objc private func errorVibration() {
        HapticsManager.shared.vibrate(for: .error)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        self.nextButton.frame.origin.y = UIScreen.main.fixedCoordinateSpace.bounds.height - 170
        self.finalError.frame.origin.y = UIScreen.main.fixedCoordinateSpace.bounds.height - 215
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            //let bottomSpace = self.view.frame.height - (nextButton.frame.origin.y + nextButton.frame.height)
            
            self.nextButton.frame.origin.y -= keyboardHeight
            self.finalError.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide() {
        self.nextButton.frame.origin.y = UIScreen.main.fixedCoordinateSpace.bounds.height - 170
        self.finalError.frame.origin.y = UIScreen.main.fixedCoordinateSpace.bounds.height - 215
    }
    
    func checkEmail(completion:@escaping((Bool) -> () )) {
        db.collection("Users").whereField("email", isEqualTo: emailTextField.text!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("DNE")
                let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
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
    
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if emailTextField.text!.count == 0 && passwordTextField.text!.count == 0 {
            finalError.text = "Please enter your email and create a password."
            finalError.isHidden = false
            errorVibration()
        }
        else if emailTextField.text!.count == 0 && passwordTextField.text!.count > 0 {
            finalError.text = "Please enter your email."
            finalError.isHidden = false
            errorVibration()
        }
        else if emailTextField.text!.count > 0 && passwordTextField.text!.count == 0 {
            finalError.text = "Please create a password."
            finalError.isHidden = false
            errorVibration()
        }
        else if emailTextField.text!.count > 0 && passwordTextField.text!.count > 0{
            if isValidEmailAddress(emailAddressString: emailTextField.text!) {
                if passwordTextField.text!.count >= 8 {
                    loading.startAnimating()
                    checkEmail { result in
                        if (result == true) {
                            self.handleSignUp()
                            self.finalError.isHidden = true
                            self.loading.stopAnimating()
                        }
                        else {
                            self.finalError.text = "An account with this email already exists."
                            self.finalError.isHidden = false
                            self.errorVibration()
                            self.loading.stopAnimating()
                        }
                    }
                    
                    }
                else {
                    finalError.text = "Please create a password that is at least 8 characters."
                    finalError.isHidden = false
                    errorVibration()
                }
            }
        
        else {
                finalError.text = "Please enter a valid email."
                finalError.isHidden = false
                errorVibration()
            }
        }
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        sharedEmail = email
        sharedPassword = password
        
        self.performSegue(withIdentifier: "fromSignUpSegue", sender: self)

        
        //createUser(withEmail: email, password: password)
    }
    
    
    func createUser(withEmail email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                print("failed sign up")
                return
            }
            
            
            let emailValues = ["email": email]
            let uidValues = ["userID": sharedUserID]
            
            guard let uid = result?.user.uid else { return }
            
            sharedUserID = uid
            
            print(uid)
            
            self.db.collection("Users").document(sharedUserID).setData(emailValues)
            self.db.collection("Users").document(sharedUserID).setData(uidValues)
            

//            Database.database().reference().child("Users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
//                if let error = error {
//                    print("failed sign up")
//                    return
//                }
//
//                print("success")
//            })
            
            
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



