//
//  ViewController.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/22/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonProperties: UIButton!
    @IBOutlet weak var signupButtonProperties: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    //MARK: - Methods
    private func unwrapTextFields(emailTextField: UITextField, passwordTextField: UITextField) -> (emailTF: String, pwTF: String){
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return ("","")
        }
        return (email, password)
    }
    
    func triggerSegue(){
        self.performSegue(withIdentifier: "tabBarSegue", sender: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error? /*ErrorStruct?*/){
        if success {
            print("This is the sessionID: \(String(describing: NetworkController.Auth.sessionId))")
            print("Success in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            DispatchQueue.main.async {
                //segue
                self.triggerSegue()
            }
        } else {
            if let realError = error as? ErrorStruct {
                DispatchQueue.main.async {
                    self.failureAlert(title: "Login Failure", message: realError.localizedDescription + "\(#function)")
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.failureAlert(title: "Login Failure", message: error.localizedDescription + "\(#function)")
                }
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
       let loginInfo = unwrapTextFields(emailTextField: emailTextField, passwordTextField: passwordTextField)
        NetworkController.shared.login(with: loginInfo.emailTF, password: loginInfo.pwTF, completion: self.handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let loginInfo = unwrapTextFields(emailTextField: emailTextField, passwordTextField: passwordTextField)
        NetworkController.shared.login(with: loginInfo.emailTF, password: loginInfo.pwTF, completion: self.handleLoginResponse(success:error:))
    }
    
}

