//
//  MapViewController.swift
//  Go_Health_Application
//
//  Created by Donghyun kim on 1/10/19.
//  Copyright © 2019 Donghyun kim. All rights reserved.
//


// Todo: To get a destination name on the screen
// I need to get StreetName and number component
// and print it on the screen
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    // Zoomed distance on Mapview
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
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
            startTracingUserLocation()
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
    
    // Make it simple to read and understand
    func startTracingUserLocation(){
        // Little Blue that
        // Which is user position
        mapView.showsUserLocation = true
        centernViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCurrentLocation(for: mapView)
    }
    
    // Taking center Longitude and Latitude
    func getCurrentLocation(for mapView: MKMapView) -> CLLocation{
        let longitude = mapView.centerCoordinate.longitude
        let latitude = mapView.centerCoordinate.latitude
        
        return CLLocation(latitude: latitude , longitude: longitude)
    }
}


extension MapViewController: CLLocationManagerDelegate{
    
    // Update User Location
    // Can make history of location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        guard let location = locations.last else { return }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
        
        
    }
    
    // Change Authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       checkLocationAuthorization()
    }
    
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCurrentLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        // Getting Center location
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placeMarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                // Todo: Show alter message
                return
            }
            
            guard let placeMark = placeMarks?.first else{
                // Tod: user Alter message
                return
            }
            
            let streetNumber = placeMark.subThoroughfare ?? ""
            let streetName = placeMark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetName) \(streetNumber)"
            }
            
        }
    }
}


