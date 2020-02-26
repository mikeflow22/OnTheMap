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
    
    
    func unwrapTextFields(emailTextField: UITextField, passwordTextField: UITextField) -> (emailTF: String, pwTF: String){
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return ("","")
        }
        return (email, password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let student = Student(firstName: "John", lastName: "Doe", latitude: 37.322998, longitude: -122.032182, mapString: "Cupertino, CA", mediaURL: "https://udacity.com", createdAt: "createdAt", objectId: "8ZExGR5uX8", uniqueKey: "3903878747", updatedAt: "updatedAt")
    
//        StudentAPIs.getUserData(student: student) { (success, error) in
//            if success {
//                print("Success in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
//                DispatchQueue.main.async {
//
//                }
//            } else {
//                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
//                return
//            }
//        }
        
     
        
//                StudentAPIs.updateStudentLocation(student: student) { (success, error) in
//
//                    if success {
//                        print("Success in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
//                        DispatchQueue.main.async {
//
//                        }
//                    } else {
//                        print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
//                        return
//                    }
//                }
     
        
//        StudentAPIs.postStudentLocation(student: student) { (success, error) in
//            if success {
//                print("Success in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
//                DispatchQueue.main.async {
//
//                }
//            } else {
//                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
//                return
//            }
//        }
     
//        StudentAPIs.getStudentsWithALimit(studentLimit: 10) { (students, error) in
//        
//                }
    }

    
    //MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
       let loginInfo = unwrapTextFields(emailTextField: emailTextField, passwordTextField: passwordTextField)
        
        StudentAPIs.login(with: loginInfo.emailTF, password: loginInfo.pwTF) { (success, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                return
            }
            
               if success {
                   print("Success in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                   DispatchQueue.main.async {

                   }
               } else {
                   print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                   return
               }
           }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        StudentAPIs.login(with: "junkboxemail22@yahoo.com", password: "Udacity22") { (success, error) in
                 if success {
                     print("Success in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                     DispatchQueue.main.async {

                     }
                 } else {
                     print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                     return
                 }
             }
    }
    
}

