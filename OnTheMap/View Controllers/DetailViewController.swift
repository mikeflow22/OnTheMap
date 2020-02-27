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
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func finishButtonTapped(_ sender: UIButton) {
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

extension DetailViewController: MKMapViewDelegate {
    
}
