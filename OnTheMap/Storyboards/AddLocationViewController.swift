//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/27/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    var coordinate: CLLocationCoordinate2D? {
        didSet {
            self.performSegue(withIdentifier: "toDetailVC", sender: self)
        }
    }
    var mediaURL: String?
    var addressString: String?
    var country = ""
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTexField: UITextField!
    @IBOutlet weak var findLocationButtonProperties: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func reverseGeoCodeString(fromLocation location: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                return
            }
            
            // the closure returns an array of places matching the address from the string
            guard let placeLocation = placemarks?.first, let lat = placeLocation.location?.coordinate.latitude, let long = placeLocation.location?.coordinate.longitude, let country = placeLocation.country else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            DispatchQueue.main.async {
                self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                self.country = country
            }
        }
    }
    
    @IBAction func findLocation(_ sender: UIButton) {
       guard let location = locationTextField.text, !location.isEmpty, let link = mediaURLTexField.text, !link.isEmpty else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        self.mediaURL = link
        self.addressString = location
        
        reverseGeoCodeString(fromLocation: location)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let destinationVC = segue.destination as? DetailViewController, let coordinate = self.coordinate, let mediaURL = self.mediaURL, let address =  self.addressString else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            
            destinationVC.coordinate = coordinate
            destinationVC.mediaURL = mediaURL
            destinationVC.addressString = "\(address), \(country)"
        }
    }
}
