//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Frederik Skytte on 17/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import MapKit

/**
 * This view controller demonstrates the objects involved in displaying pins on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */

class MapViewController: UIViewController {
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
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
    
    func loadStudentLocationList() {
        ParseClient.getLocationList() { students, error in
            if let error = error {
                print("Error downloading student locations: \(error.localizedDescription)")
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
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
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

