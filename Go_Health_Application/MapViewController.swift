//
//  MapViewController.swift
//  Go_Health_Application
//
//  Created by Donghyun kim on 1/10/19.
//  Copyright © 2019 Donghyun kim. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationService()

    }
    func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func centernViewOnUserLocation(){
        if  let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
            print("CheckLocationService")
        }else {
            // Show alter message to user turn on the authorization
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Little Blue that
            // Which is user position
            mapView.showsUserLocation = true
            break
        case .denied:
            
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show Alter message
            break
        case .authorizedAlways:
            break
    }
    
}
}


extension MapViewController: CLLocationManagerDelegate{
    
    // Update User Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // We will be back
        
    }
    
    // Change Authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Late
    }
    
}


