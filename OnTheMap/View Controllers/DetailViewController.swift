//
//  DetailViewController.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/27/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    var coordinate: CLLocationCoordinate2D?
    var mediaURL: String?
    var addressString: String?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupViews()
    }
    
    func setupViews(){
        guard let coordinate = coordinate, let _ = mediaURL, let addressString = addressString else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        createAnnotationWith(coordinate: coordinate, address: addressString)
    }
    
    func createAnnotationWith(coordinate: CLLocationCoordinate2D, address: String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = address
        
        //set region
        let span = MKCoordinateSpan(latitudeDelta: 0.75, longitudeDelta: 0.75)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
        //add annotation to mapView
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        //post to server
        getUserInfo()
    }
    
    func post(firstName: String, lastName: String, coordinate: CLLocationCoordinate2D, mapString: String, mediaURL: String){
        
        let student = Student(firstName: firstName, lastName: lastName, longitude: coordinate.longitude, latitude: coordinate.latitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: NetworkController.Auth.accountKey, objectId: nil, createdAt: nil, updatedAt: nil)
        
        NetworkController.shared.postStudentLocation(student: student) { (success, error) in
            if success {
                print("Success in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .postedStudentLocation, object: nil)
                    self.dismiss(animated: true, completion: nil)
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
    }
    
    func getUserInfo(){
        var firstNameTextField: UITextField?
        var lastNameTextField: UITextField?
        
        let alert = UIAlertController(title: "Enter Information", message: nil, preferredStyle: .alert)
        alert.addTextField { (firstTextField) in
            firstTextField.placeholder = "First Name"
            firstTextField.keyboardType = .alphabet
            firstTextField.keyboardAppearance = .dark
            firstNameTextField = firstTextField
        }
        alert.addTextField { (lastTextField) in
            lastTextField.placeholder = "Last Name"
            lastTextField.keyboardType = .alphabet
            lastTextField.keyboardAppearance = .dark
            lastNameTextField = lastTextField
        }
        
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            //make sure there's text in both textfields
            guard let firstName = firstNameTextField?.text, !firstName.isEmpty, let lastName = lastNameTextField?.text, !lastName.isEmpty else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            guard let coordinate = self.coordinate, let mediaURL = self.mediaURL, let addressString = self.addressString else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            
            DispatchQueue.main.async {
                self.post(firstName: firstName, lastName: lastName, coordinate: coordinate, mapString: addressString, mediaURL: mediaURL)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submit)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

extension Date {
    func stringFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self)
    }
}
