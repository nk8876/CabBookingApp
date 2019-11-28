//
//  RideRequestDetailVC.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 20/08/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON

class RideRequestDetailVC: UIViewController {

    private let locationManager = CLLocationManager()
    private var marker = GMSMarker()
    @IBOutlet weak var googleMap: GMSMapView!
    var destinationLat : Double = 0.0
    var destinationLog : Double = 0.0
    var sourceLat : Double = 0.0
    var sourceLog : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupViews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //self.navigationController!.navigationBar.tintColor = UIColor.black
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

    func setupViews() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        let start = CLLocationCoordinate2D(latitude: self.sourceLat, longitude: self.sourceLog)
        let end = CLLocationCoordinate2D(latitude: self.destinationLat, longitude: self.destinationLog)
        drawRideRoute(from: start, to: end)
        
    }
    func drawRideRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude)&destination=\(destination.latitude)&sensor=true&mode=driving&key=AIzaSyCHM6JNwqWZ5lFXP34QLQRkBAelM8xbVRs")!
        
        //Rrequesting Alamofire and SwiftyJSON
        Alamofire.request(url).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result)   // result of response serialization
            do {
                let json =  try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeColor = UIColor.blue
                    polyline.strokeWidth = 2
                    polyline.map = self.googleMap
                }
            } catch let error {
                print(error)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension RideRequestDetailVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        googleMap.isMyLocationEnabled = true
        googleMap.settings.compassButton = true
      
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        googleMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
        
        //change map location
        marker.position = center
        marker.title = ""
        marker.map = googleMap
        self.googleMap.animate(toLocation: center)
        
        print("Latitude :- \(center.latitude)")
        print("Longitude :-\(center.longitude)")
        locationManager.stopUpdatingLocation()
    }
}
