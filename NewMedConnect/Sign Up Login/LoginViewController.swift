//
//  LoginViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 5/29/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!

    


    override func viewDidLoad() {
        super.viewDidLoad()

        if deletedUser == true {
            do {
                
                try Auth.auth().currentUser?.delete()
                deletedUser = false
                print(deletedUser)
            } catch let error {
                let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                
            
            }
        }
        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 10.0
        signUpButton.layer.cornerRadius = 10.0
//
        //navigationController?.navigationBar.barTintColor = UIColor.blue
        
        navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.backgroundColor = UIColor.white
        
        tabBarController?.tabBar.isHidden = true
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        loginTextField.addTarget(self, action: #selector(enableLogin), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(enableLogin), for: .editingChanged)
        
        
        activityIndicator.hidesWhenStopped = true
        navigationController?.navigationBar.prefersLargeTitles = false
        
        

        navigationItem.hidesBackButton = true
        
       
                
    }
    
 
    
    @objc private func enableLogin() {
        
        if loginTextField.text!.count >= 1 && passwordTextField.text!.count >= 1 {
                loginButton.isEnabled = true
                loginButton.backgroundColor = UIColor.red
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.lightGray
        }
    
    }
    
    @objc private func errorVibration() {
        HapticsManager.shared.vibrate(for: .error)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        performSegue(withIdentifier: "toPasswordReset", sender: self)
    }
    

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = loginTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("not enough info")
            return
        }
        errorMessage.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                strongSelf.showCreateAccount()
                return
            }
            print("Signed In")
            print(Auth.auth().currentUser!.uid)
            
            self!.performSegue(withIdentifier: "loginSegue", sender: self)
            self!.activityIndicator.stopAnimating()
        })
        
                
    }
    
    
    func showCreateAccount() {
        errorVibration()
        activityIndicator.stopAnimating()
        errorMessage.isHidden = false
        errorMessage.text = "Login failed. Please try again."
        
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
