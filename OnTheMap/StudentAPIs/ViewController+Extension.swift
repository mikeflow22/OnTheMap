//
//  ViewController+Extension.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/26/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

extension UIViewController {
    func showLoginFailure(message: String) {
           let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           show(alertVC, sender: nil)
       }
       
     func handleLogoutResponse(success: Bool, error: ErrorStruct?){
        if success {
            print("Success in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            DispatchQueue.main.async {
                self.showLoginFailure(message: error?.localizedDescription ?? "logout attempted failed!")
            }
            return
        }
    }
}


