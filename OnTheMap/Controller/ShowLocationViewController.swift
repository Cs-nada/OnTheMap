//
//  ShowLocationViewController.swift
//  OnTheMap
//
//  Created by Ndoo H on 16/01/2019.
//  Copyright © 2019 Ndoo H. All rights reserved.
//

import Foundation
import MapKit

class ShowLocationViewController: UIViewController {
    
    var userLocation: StudentLocation!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showEnteredLocation()
    }
    
    func showEnteredLocation() {
        
        var annotations = [MKPointAnnotation]()
        
        let coordinate = CLLocationCoordinate2D(latitude: userLocation.latitude!, longitude: userLocation.longitude!)
            
        // Create the annotation and show user location string
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = userLocation.mapString
        annotations.append(annotation)
        
        self.mapView.addAnnotations(annotations)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        updateView(isBusy: true)
        ParseClient.sendLocation(userLocation: userLocation, completion: self.locationSentHandler(success:error:))
    }
    
    func locationSentHandler(success: Bool, error: Error?){
        updateView(isBusy: false)
        print("send location \(success)")
        if success {
            dismiss(animated: false, completion: nil)
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else {
            self.showErrorMessage("Error sending location", msg: error?.localizedDescription ?? "Make sure you are online and try again")
        }
    }
    
    func updateView(isBusy: Bool){
        // Update View
        sendButton.isEnabled = !isBusy
        if isBusy {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
    }
}

extension ShowLocationViewController: MKMapViewDelegate {
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView.canShowCallout = true
        pinView.pinTintColor = .blue
        pinView.annotation = annotation
        return pinView
    }
}

