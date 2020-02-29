//
//  ViewController+Extension.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/26/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

extension UIViewController {
    func failureAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: "title", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func handleLogoutResponse(success: Bool, error: Error?){
        if success {
            print("Success in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            if let realError = error as? ErrorStruct {
                DispatchQueue.main.async {
                    self.failureAlert(title: "Logout Failure", message: realError.localizedDescription + "\(#function)")
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.failureAlert(title: "Logout Failure", message: error.localizedDescription + "\(#function)")
                }
            }
            return
        }
    }
    
    func connectionFailed(){
        NetworkController.shared.logout { (success, error) in
            if success {
                print("Success in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                     self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
        }
    }
}


