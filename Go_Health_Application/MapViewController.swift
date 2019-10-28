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
    var directionsArray: [MKDirections] = []
    
    var calorieBurnRate: Double = 1000
    var newHeartrate: Double = 10
    var weightInPounds: Double = 39
    var userAge: Double = 20
    var Men: Double = 17.8
    var Women: Double = 16.9
    
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
    
    func getDirection(){
        guard let location = locationManager.location?.coordinate else {
            // Todo: Inform user we do not have their current location
            return
        }
        
        let request = createDirectionRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        // Draw route
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else { return }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                // Calculate ETA Time
//                let etaTravelTime = route.expectedTravelTime
//                print("Estimated Time (in mins): " , etaTravelTime / 60)
//                print("Draw the route")
            }
        }
    }

    // Calulation equation to findout burned calories
    func  calculateCalories(){
        Men; calorieBurnRate = abs(((0.6309, newHeartrate) + (0.09036, weightInPounds) + (0.2017 * userAge) - 55.0969) / 4.184);

        Women; calorieBurnRate = abs(((0.4472, newHeartrate) - (0.05741, weightInPounds) + (0.074 * userAge) - 20.4022) / 4.184);
    }
    
    
    // Get location
    func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request{
        
        let destinationCoordinate = getCurrentLocation(for: mapView).coordinate
        // user current location
        let startingLocation = MKPlacemark(coordinate: coordinate)
        // Center location
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        return request
    }

    func resetMapView(withNew directions: MKDirections) {
           mapView.removeOverlays(mapView.overlays)
           directionsArray.append(directions)
           let _ = directionsArray.map { $0.cancel() }
       }
       
    
    // A button allows to user to move to the direction
    @IBAction func getDirectionButtonTapped(_ sender: Any) {
        getDirection()
        print("Button Clicked")
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .green
        
        return renderer
    }
    
}


