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

