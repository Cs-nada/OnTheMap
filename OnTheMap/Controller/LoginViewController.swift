//
//  LoginViewController.swift
//
//  Created by Ndoo H on 16/01/2019.
//  Copyright © 2019 Ndoo H. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        LoginClient.login(un: self.emailTextField.text ?? "", pw: self.passwordTextField.text ?? "", completion: self.loginHandler(success:error:))
    }
    
    @IBAction func signUpTapped() {
        UIApplication.shared.open(LoginClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    func loginHandler(success: Bool, error: Error?){
        setLoggingIn(false)
        print("login \(success)")
        if success {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }
        else {
            self.showErrorMessage("Login Failed", msg: error?.localizedDescription ?? "Make sure Udacity credentials are ok, and that you are online")
        }
    }
    
    func setLoggingIn(_ yes: Bool){
        if yes{
             activityIndicator.startAnimating()
        }
        else{
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !yes
        passwordTextField.isEnabled = !yes
        loginButton.isEnabled = !yes
        signUpButton.isEnabled = !yes
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
