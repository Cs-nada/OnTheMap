//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Frederik Skytte on 17/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if StudentsModel.studentLocations.count == 0 {
            loadStudentLocationList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStudentLocationPins()
    }
    
    @IBAction func reloadDataTapped(_ sender: Any) {
        loadStudentLocationList()
    }
    
    func loadStudentLocationList() {
        ParseClient.getLocationList() { students, error in
            if let error = error {
                self.showErrorMessage("Error downloading student locations", msg: error.localizedDescription)
            }
            else{
                print("Downloaded \(students.count) student locations successfully")
                StudentsModel.studentLocations = students
                self.updateStudentLocationPins()
            }
        }
    }
    
    func updateStudentLocationPins(){
        
        var annotations = [MKPointAnnotation]()
        
        for studLoc in StudentsModel.studentLocations {
            guard let lat = studLoc.latitude, let lon = studLoc.longitude else {
                break
            }

            let latitude = CLLocationDegrees(lat)
            let longitude = CLLocationDegrees(lon)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = studLoc.getFullName()
            annotation.subtitle = studLoc.getUrlString()
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we reset the annotations for the map.
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = view.annotation?.subtitle!, let studentUrl = URL(string: url) {
                UIApplication.shared.open(studentUrl, options: [:], completionHandler: nil)
            }
            else {
                showUrlFailure()
            }
        }
    }
}

