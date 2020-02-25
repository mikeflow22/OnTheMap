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
        let student = Student(firstName: "mike", lastName: "flow", latitude: 84.0000, longitude: -122.0000, mapString: "mapstring", mediaURL: "mediaURL", createdAt: "createdAt", objectId: "8ZExGR5uX8", uniqueKey: "uniqueKey", updatedAt: "updatedAt")
    
        StudentAPIs.login(with: "mrftest1", password: "password") { (success, error) in
            if success {
                print("Success in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                    
                }
            } else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
        }
//        StudentAPIs.logout { (success, error) in
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
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
    }
    
}

