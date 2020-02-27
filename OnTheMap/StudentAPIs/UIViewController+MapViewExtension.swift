//
//  UIViewController+MapViewExtension.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/27/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation
import MapKit
extension UIViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
               
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
           
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
               if control == view.rightCalloutAccessoryView {
                   let app = UIApplication.shared
                   if let toOpen = view.annotation?.subtitle! {
                       app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                   }
               }
           }
}

