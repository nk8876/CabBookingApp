//
//  BaseViewController.swift
//  CabBookingApp
//
//  Created by Dheeraj Arora on 24/09/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import CoreLocation

class HomeViewController: UIViewController{
    
    //MARK -: Properties
    var countryCode = ""
    var message: String?
    var menuController: MenuViewController!
    private let locationManager = CLLocationManager()
    private var marker = GMSMarker()
    var autoComplete : GMSAutocompleteViewController!
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var addressContainer: UIView!
    @IBOutlet weak var txtPicupAddress: UITextField!
    @IBOutlet weak var txtDropAddress: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        menuController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
        swipGestureAction()
       
    }
    //MARK  -: Handles
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        // hide the default back buttons
        self.navigationItem.hidesBackButton = true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    func setUpViews() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        googleMap.delegate = self
        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardTappedOutside()
        self.addressContainer.layer.cornerRadius = 20
        self.addressContainer.clipsToBounds = true
        txtPicupAddress.attributedPlaceholder = NSAttributedString(string: " Where From ?",attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        txtDropAddress.attributedPlaceholder = NSAttributedString(string: " Drop Where ? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
    }
    func swipGestureAction()  {
        let swipRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipRight)

    }
    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer){
        switch gesture.direction {
        case  .right:
            //show menu
            showMenu()
        case  .left:
            closeOnSwip()
        default:
            break
        }
    }
    
    @IBAction func openCloseMenuAction(_ sender: UIButton) {
        if AppDelegate.menu_bool{
            //show menu
            showMenu()
        }else{
            //close menu
            closeMenu()
        }
    }
    
//    @IBAction func menuAction(_ sender: UIBarButtonItem) {
//        if AppDelegate.menu_bool{
//            //show menu
//            showMenu()
//        }else{
//            //close menu
//            closeMenu()
//        }
//
//    }
    func closeOnSwip()  {
        if AppDelegate.menu_bool{
            //show menu
            //showMenu()
        }else{
            //close menu
            closeMenu()
        }
    }
    
    func showMenu() {
        UIView.animate(withDuration: 0.3) { ()-> Void in
            self.menuController.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.menuController.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
            self.addChild(self.menuController)
            self.view.addSubview(self.menuController.view)
            AppDelegate.menu_bool = false
        }
    }
    
    func closeMenu() {
        UIView.animate(withDuration: 0.3, animations: { ()-> Void in
            self.menuController.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (finished) in
            self.menuController.view.removeFromSuperview()
        }
        
        AppDelegate.menu_bool = true
    }

    @objc func keyboardWillChange(notification:Notification)
    {
        guard let heightRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification
        {
            view.frame.origin.y = -heightRect.height + 250
        }else{
            view.frame.origin.y = 0
        }
        
    }
    deinit {
        //stop listening for keyboard hide/show events
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
   
    // Present the Autocomplete view controller when the textField is tapped.
    
    @IBAction func openAutoCompleteAction(_ sender: UITextField) {
        txtDropAddress.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func btnRideNowAction(_ sender: UIButton) {
       let rideDetails = self.storyboard!.instantiateViewController(withIdentifier: "RideRequestDetailVC") as! RideRequestDetailVC
        self.navigationController?.pushViewController(rideDetails, animated: true)
    }
    
    @IBAction func btnRideLaterAction(_ sender: UIButton) {
        let rideLater = self.storyboard?.instantiateViewController(withIdentifier: "UpcommingRideVC") as! UpcommingRideVC
        self.navigationController?.pushViewController(rideLater, animated: true)
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
    
            let geocoder = GMSGeocoder()
            self.txtPicupAddress.unlock()
            geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
                guard let address = response?.firstResult(), let lines = address.lines else {
                    return
                }
    
                self.txtPicupAddress.text = lines.joined(separator: "\n")
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
    
            }
        }
    
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
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
        
        let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 16.0, bearing: 0, viewingAngle: 0)
        //this is our map view
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.googleMap.addSubview(mapView)
        self.googleMap.isMyLocationEnabled = true
        
        //change map location
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.title = ""
        marker.map = googleMap
        self.googleMap.animate(to: camera)
        
        print("Latitude :- \(location.coordinate.latitude)")
        print("Longitude :-\(location.coordinate.longitude)")
        locationManager.stopUpdatingLocation()
    }
    
}
// MARK: - GMSMapViewDelegate
extension HomeViewController: GMSMapViewDelegate {
    
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            googleMap.isMyLocationEnabled = true
            //self.txtPicupAddress.unlock()
            reverseGeocodeCoordinate(position.target)
        }
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            googleMap.isMyLocationEnabled = true
            //txtPicupAddress.lock()
            if gesture {
                mapView.selectedMarker = nil
            }
        }
    
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            googleMap.isMyLocationEnabled = true
            return false
        }
    
        func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
            googleMap.isMyLocationEnabled = true
            googleMap.selectedMarker = nil
            return false
    
        }
        func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location:
            CLLocationCoordinate2D) {
            marker.snippet = "\(location.latitude), \(location.longitude)"
            marker.position = location
            marker.title = name
            marker.opacity = 0
            marker.infoWindowAnchor.y = 1
            marker.map = mapView
            googleMap.selectedMarker = marker
            //print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        }
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            marker.position = position.target
            //print("\(marker.position)")
        }
}
// MARK -: GMS Auto Complete Delegate, for Auto Complete Search location

extension HomeViewController: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        txtDropAddress.text = place.formattedAddress
        print("Place name: \(place.coordinate.latitude)")
        print("Place ID: \(place.coordinate.longitude)")
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
        print("Place attributions: \(String(describing: place.attributions))")
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
        
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error : \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
