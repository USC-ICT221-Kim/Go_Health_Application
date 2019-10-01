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
    
    // Zoomed distance on Mapview
    let regionInMeters: Double = 100000
    
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
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
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
            centernViewOnUserLocation()
            locationManager.startUpdatingLocation()
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
    // Can make history of location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        
    }
    
    // Change Authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       checkLocationAuthorization()
    }
    
}


