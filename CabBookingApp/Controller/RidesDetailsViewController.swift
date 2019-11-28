//
//  RidesDetailsViewController.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 10/09/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
class RidesDetailsViewController: UIViewController {

    private let locationManager = CLLocationManager()
    private var marker = GMSMarker()
   @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var paymentThrough: UILabel!
    @IBOutlet weak var totalFare: UILabel!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var driverRating: UILabel!
    @IBOutlet weak var driverPhoto: UIImageView!
    var dateTimes = ""
     var fare = ""
     var car = ""
     var rating = ""
     var payment = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         configureUI()
         setupViews()
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationItem.title = "Ride Detail"
        navigationController?.navigationBar.barStyle = .black
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_ios_white_24pt_1x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
    }
    @objc func handleDismiss()
    {
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    func setupViews()  {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        mapView.delegate = self
        
        paymentThrough.text = payment
        totalFare.text = fare
        carType.text = car
        dateTime.text = dateTimes
        
    // let fullName = UserDefaults.standard.object(forKey: "username")
    //driverRating.text = "You rated \(String(describing: fullName!)): \(rating)"
        
        
        driverPhoto.layer.borderWidth = 1
        driverPhoto.layer.masksToBounds = false
        driverPhoto.layer.borderColor = UIColor.black.cgColor
        driverPhoto.layer.cornerRadius = driverPhoto.frame.height/2
        driverPhoto.clipsToBounds = true
    }

}
// MARK: - CLLocationManagerDelegate

extension RidesDetailsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 16.0, bearing: 0, viewingAngle: 0)
        //this is our map view
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.addSubview(mapView)
        self.mapView.isMyLocationEnabled = true
        
        //change map location
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.title = ""
        marker.map = mapView
        self.mapView.animate(to: camera)
        
        print("Latitude :- \(location.coordinate.latitude)")
        print("Longitude :-\(location.coordinate.longitude)")
        locationManager.stopUpdatingLocation()
    }
    
}
// MARK: - GMSMapViewDelegate
extension RidesDetailsViewController: GMSMapViewDelegate {
    
    //    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    //        googleMap.isMyLocationEnabled = true
    //        //self.txtPickupAddress.unlock()
    //        reverseGeocodeCoordinate(position.target)
    //    }
    //    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    //        googleMap.isMyLocationEnabled = true
    //       // txtPickupAddress.lock()
    //        if gesture {
    //            mapView.selectedMarker = nil
    //        }
    //    }
    //
    //    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    //        googleMap.isMyLocationEnabled = true
    //        return false
    //    }
    //
    //    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    //        print("COORDINATE : \(coordinate)")
    //    }
    //
    //    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
    //        googleMap.isMyLocationEnabled = true
    //        googleMap.selectedMarker = nil
    //        return false
    //
    //    }
    //    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location:
    //        CLLocationCoordinate2D) {
    //        marker.snippet = "\(location.latitude), \(location.longitude)"
    //        marker.position = location
    //        marker.title = name
    //        marker.opacity = 0
    //        marker.infoWindowAnchor.y = 1
    //        marker.map = mapView
    //        googleMap.selectedMarker = marker
    //        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
    //    }
    //    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    //        marker.position = position.target
    //        print("\(marker.position)")
    //    }
}
