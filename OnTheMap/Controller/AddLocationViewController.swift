//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Ndoo H on 16/01/2019.
//  Copyright © 2019 Ndoo H. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var addLocButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    lazy var geocoder = CLGeocoder()
    var enteredLocation: StudentLocation?
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addLocationTapped(_ sender: Any) {
        getAddress()

    }
    
    private func getAddress() {
        guard let loc = locationTextField.text, !loc.isEmpty else {
            showErrorMessage("Validation", msg: "You must enter your location")
            return
        }
        guard let link = linkTextField.text, !link.isEmpty else {
            showErrorMessage("Validation", msg: "You must enter a link")
            return
        }
        
        updateView(isBusy: true)
        
        // Geocode location String
        geocoder.geocodeAddressString(loc, completionHandler: self.processResponse(placemarks:error:))
    }
    
    private func processResponse(placemarks: [CLPlacemark]?, error: Error?) {
        updateView(isBusy: false)
        
        if let error = error {
            print("Unable to get Geocode Address (\(error))")
            showErrorMessage("Error Finding Location", msg: "Error: \(error)")
        }
        else {
            
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                print("Found coordinates \(coordinate.latitude), \(coordinate.longitude)")
                enteredLocation = StudentLocation(
                    createdAt: nil,
                    firstName: "Frederik",
                    lastName: "Skytte",
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    mapString: locationTextField.text,
                    mediaURL: linkTextField.text,
                    objectId: nil,
                    uniqueKey: nil,
                    updatedAt: nil)
                performSegue(withIdentifier: "showMapSegue", sender: nil)
            } else {
                showErrorMessage("Problem Finding Location", msg: "No Matching Location Found")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMapSegue" {
            let showLocVC = segue.destination as! ShowLocationViewController
            showLocVC.userLocation = enteredLocation
        }
    }
    
    func updateView(isBusy: Bool){
        // Update View
        addLocButton.isEnabled = !isBusy
        if isBusy {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
    }
}
