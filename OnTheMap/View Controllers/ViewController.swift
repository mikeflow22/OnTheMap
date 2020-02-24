//
//  ViewController.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/22/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        StudentAPIs.getStudentsWithALimit(studentLimit: 1) { (students, error) in
//
//        }
        let student = Student(firstName: "mike", lastName: "flow", latitude: 84.0000, longitude: -122.0000, mapString: "mapstring", mediaURL: "mediaURL", createdAt: "createdAt", objectId: "8ZExGR5uX8", uniqueKey: "uniqueKey", updatedAt: "updatedAt")
        
        StudentAPIs.updateStudentLocation(student: student) { (success, error) in
            
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

