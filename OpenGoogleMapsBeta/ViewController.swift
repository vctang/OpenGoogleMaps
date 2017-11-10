//
//  ViewController.swift
//  OpenGoogleMapsBeta
//
//  Created by Vicky Tang on 10/12/17.
//  Copyright © 2017 Vicky Tang. All rights reserved.
//

// Notes:
// Info.plist, open as source code.
// Added in google maps tags <LS...>

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapsButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    
    var pickedLocation: GMSPlace?
    var eventCoordinates: CLLocationCoordinate2D?
    
    // Autocomplete Controller - Location Picker
    let oldapiKey = "AIzaSyDWgrglpRDRqRVwPJMo-SkTq5xg7kJS0hk" // Interar-me
    //let oldapiKey = "AIzaSyDW25T3aCOsksT-brSC1dKEzxhc9oxv1u4" // Mine
    let apiKey = "AIzaSyDW25T3aCOsksT-brSC1dKEzxhc9oxv1u4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSPlacesClient.provideAPIKey(oldapiKey)
        GMSServices.provideAPIKey(apiKey)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // BUTTON FUNCTION: Opening Google Maps
    func getLatitude() -> CLLocationDegrees {
        if(eventCoordinates != nil){
            return (eventCoordinates?.latitude)!
        }
        
        return 32.8760930
    }
    
    func getLongitude() -> CLLocationDegrees {
        if(eventCoordinates != nil){
            return (eventCoordinates?.longitude)!
        }
        
        return -117.2354360
    }

    @IBAction func mapsButtonPressed(_ sender: Any) {
        let lat = getLatitude()
        let long = getLongitude()
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            // Latitude, Longitude
            UIApplication.shared.open(URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving")! as URL)
        } else
        {
            NSLog("Can't use com.google.maps://");
        }
    }
    
    // GOOGLE PLACES: Text field to enter in a location
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func textFieldEdited(_ sender: Any) {
        /*let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)*/
        
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        self.present(placePicker, animated: true, completion: nil)
    }
    
}

extension ViewController: GMSPlacePickerViewControllerDelegate {
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
        
        self.pickedLocation = place
        self.locationTextField.text = place.name
        self.eventCoordinates = place.coordinate
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
}

/*extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        self.pickedLocation = place
        self.locationTextField.text = place.name
        self.eventCoordinates = place.coordinate
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.ddd
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}*/

