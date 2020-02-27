//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/26/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var students: [Student]? {
        didSet {
            guard let students =  students else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            createAnnotations(forStudents: students)
        }
    }
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        get100Students()
        
    }
    
    func get100Students(){
        StudentAPIs.getStudentsWithALimit(studentLimit: 100) { (students, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                return
            }
            
            guard let returnedStudents = students  else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            DispatchQueue.main.async {
                self.students = returnedStudents
            }
        }
    }
    
   private func createAnnotations(forStudents students: [Student]){
        for student in students {
            let coordinate = student.coordinate
            let mediaString = student.mediaURL
            let fullName = student.fullName
            
            //create annotation to append to the array above
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = fullName
            annotation.subtitle = mediaString
            
            //append newly created annotation to the annotation array above
            self.annotations.append(annotation)
        }
        //add annotations to mapview
        self.mapView.addAnnotations(self.annotations)
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    private func handleLogoutResponse(success: Bool, error: ErrorStruct?){
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
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        StudentAPIs.logout(completion: self.handleLogoutResponse(success:error:))
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        //clear annotations
        self.mapView.removeAnnotations(self.annotations)
        
        //network call to retrieve students
        get100Students()
    }
    
    @IBAction func addStudentLocation(_ sender: UIBarButtonItem) {
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

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

          let reuseId = "pin"

          var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

          if pinView == nil {
              pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
              pinView!.canShowCallout = true
              pinView!.pinTintColor = .orange
              pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
          }
          else {
              pinView!.annotation = annotation
          }
          return pinView
      }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
          if control == view.rightCalloutAccessoryView {
              let app = UIApplication.shared
              if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
              }
          }
      }
}
