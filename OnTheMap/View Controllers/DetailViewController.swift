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
        guard let coordinate = coordinate, let mediaURL = mediaURL, let addressString = addressString else {
                   print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                   return
               }
        let student = Student(firstName: "Hottest", lastName: "guy ever", longitude: coordinate.longitude, latitude: coordinate.latitude, mapString: addressString, mediaURL: mediaURL, uniqueKey: "7122294624", objectId: "00000001", createdAt: Date().stringFromDate(), updatedAt: Date().stringFromDate())
        
        NetworkController.shared.postStudentLocation(student: student) { (success, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                return
            }
            
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension Date {
    func stringFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self)
    }
}
