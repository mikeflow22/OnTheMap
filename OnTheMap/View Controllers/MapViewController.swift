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
            guard let students = students else {
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
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMap), name: .postedStudentLocation, object: nil)
    }
    @objc func refreshMap(){
        self.mapView.removeAnnotations(self.annotations)
        
        get100Students()
    }
    
    func get100Students(){
       NetworkController.shared.orderStudentsInList { (error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                return
            }
            //if this worked then we should have students in network controller
            self.students = NetworkController.shared.orderedStudents
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
        
    @IBAction func logout(_ sender: UIBarButtonItem) {
        NetworkController.shared.logout(completion: self.handleLogoutResponse(success:error:))
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
    
