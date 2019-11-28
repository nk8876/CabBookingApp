//
//  UserDashboard.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 30/07/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import FacebookCore
import FacebookLogin
import GooglePlacePicker

class UserDashboard: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var sideMenuBar: UITableView!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var tableLeadingConstrains: NSLayoutConstraint!
    @IBOutlet weak var viewLeading: NSLayoutConstraint!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var txtFromAddress: UITextField!
    @IBOutlet weak var txtToAddress: UITextField!
    @IBOutlet weak var addressView: UIView!
//    var googlePlaceApi = ""
//    var subThoroughfare = ""
//    var thoroughfare = ""
//    var locationManager = CLLocationManager()
//    var myMapView = GMSMapView()
//    var marker = GMSMarker()
    
    var menuName : [String] = ["Payment","Pending requests",
                               "Accepted requests" ,"History","Profile","Logout"
    ]
    var menuIcon  = [UIImage(named: "baseline_payment_white_24pt_1x"),
                     UIImage(named: "to-do-list"),
                     UIImage(named: "done"),
                     UIImage(named: "baseline_history_white_24pt_1x"),
                     UIImage(named: "ic_person_outline_white_2x"),
                     UIImage(named: "logout")
    ]
    var isSideBarOpen:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let fullName = UserDefaults.standard.object(forKey: "username")
//        userName.text! = "\(String(describing: fullName!))"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        //mapView.addGestureRecognizer(tapGesture)
        setUpView()
        //txtToAddress.delegate = self
        
    }
    
    @objc func tapGestureAction()  {
        self.sideView.isHidden = false
        if isSideBarOpen{
            leadingConstraints.constant = -210
            tableLeadingConstrains.constant = -210
            viewLeading.constant = -230
        }else{
            leadingConstraints.constant = 0
            tableLeadingConstrains.constant = 0
            viewLeading.constant = 0
            
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let userLocation = locations.last
//        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
//
//        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
//                                              longitude: userLocation!.coordinate.longitude, zoom: 10.0)
//        myMapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height), camera: camera)
//        self.myMapView.isMyLocationEnabled = true
//        self.myMapView.settings.compassButton = true
//        self.myMapView.settings.myLocationButton = true
//        self.mapView.addSubview(myMapView)
//
//        marker.position = center
//        marker.title = "I am here "
//        marker.map = myMapView
//        self.myMapView.animate(toLocation: center)
//
//        print("Latitude :- \(userLocation!.coordinate.latitude)")
//        print("Longitude :-\(userLocation!.coordinate.longitude)")
//
//        self.locationManager.stopUpdatingLocation()
//        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) -> Void in
//
//            if error != nil{
//                print("Failed")
//                return
//            }
//
//            print("Response GeoLocation : \(String(describing: placemarks))")
//            var placeMark: CLPlacemark!
//            placeMark = placemarks![0]
//
//
//            if let subThoroughfare1 = placeMark.subThoroughfare {
//                self.subThoroughfare = subThoroughfare1
//                print("subThoroughfare is nil")
//
//            }
//
//            if let thoroughfare1 = placeMark.thoroughfare {
//                self.thoroughfare = thoroughfare1
//                print("thoroughfare is nil")
//
//            }
//
//            self.txtFromAddress.text = "\(self.subThoroughfare)\(self.thoroughfare)\(String(describing: placeMark.name!)), \(String(describing: placeMark.locality!)), \(String(describing: placeMark.postalCode!)), \(String(describing: placeMark.country!))"
//
//        })
//
//    }

  
    func setUpView()  {
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardTappedOutside()
        userProfileImage.layer.cornerRadius = (userProfileImage.frame.width / 2)
        userProfileImage.layer.masksToBounds = true
        
        // User Location
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
        
        sideView.isHidden = true
        sideMenuBar.backgroundColor = UIColor.clear
        isSideBarOpen = false
        sideView.layer.shadowOpacity = 0.5
        sideView.layer.shadowRadius = 5
        
        customeBackButton()
        swipView()
        self.addressView.layer.cornerRadius = 20
        self.addressView.clipsToBounds = true
        
        txtFromAddress.attributedPlaceholder = NSAttributedString(string: "Where From ?",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        txtToAddress.attributedPlaceholder = NSAttributedString(string: "Drop Where ? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    // Present the Autocomplete view controller when the textField is tapped.
    @IBAction func textFieldTapped(_ sender: Any) {
//        txtToAddress.resignFirstResponder()
//        let acController = GMSAutocompleteViewController()
//        acController.delegate = self
//        present(acController, animated: true, completion: nil)
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
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true
        )
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            sideView.isHidden = true
        }
    }
    func swipView()  {
        ////SWIP LEFT
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    @objc func didSwipeLeft(gesture: UISwipeGestureRecognizer){
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.left :
            self.sideView.isHidden = true
        default:
            break
        }
        
    }
    
    @IBAction func btnOpenCloseMenuAction(_ sender: UIBarButtonItem) {
        self.sideView.isHidden = false
        if isSideBarOpen{
            leadingConstraints.constant = -210
            tableLeadingConstrains.constant = -210
            viewLeading.constant = -210
        }else{
            leadingConstraints.constant = 0
            tableLeadingConstrains.constant = 0
            viewLeading.constant = 0
            
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}
    //MARK -: GOOGLE AUTO COMPLETE DELEGATE
//extension UserDashboard: GMSAutocompleteViewControllerDelegate {
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//
//        print("Place name: \(place.name ?? "")")
//        print("Place address: \(place.formattedAddress ?? "null")")
//        self.txtToAddress.text = place.formattedAddress
//        print("Place attributions: \(String(describing: place.attributions))")
//        let lat = place.coordinate.latitude
//        let lon = place.coordinate.longitude
//        print("Selected Place Lat is = \(lat) And Lon is = \(lon)")
//        self.dismiss(animated: true, completion: nil)
//    }
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        // TODO: handle the error.
//        print("Error: \(error.localizedDescription)")
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    // User canceled the operation.
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        print("Autocomplete was cancelled.")
//        self.dismiss(animated: true, completion: nil)
//    }
//}
extension UserDashboard:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.menuName.text = menuName[indexPath.row]
        cell.menuIcon.image = menuIcon[indexPath.row]
        return cell
        
    }
    
}

extension UserDashboard : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let next: PaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            self.navigationController?.pushViewController(next, animated: true)
        }
        //print(menuName[indexPath.row])
//        switch indexPath.row {
//        case 0:
//            let home = self.storyboard!.instantiateViewController(withIdentifier: "UserDashboard") as! UserDashboard
//            self.navigationController?.pushViewController(home, animated: false)
//
//        case 1:
//            let payment = self.storyboard!.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
//            self.navigationController?.pushViewController(payment, animated: false)
//
//        case 2:
//            let pending = self.storyboard!.instantiateViewController(withIdentifier: "pending") as! PendingRequestVC
//            self.navigationController?.pushViewController(pending, animated: false)
//
//        case 3:
//            let accept = self.storyboard!.instantiateViewController(withIdentifier: "AcceptedRequestVC") as! AcceptedRequestVC
//            self.navigationController?.pushViewController(accept, animated: false)
//
//        case 4:
//            let history = self.storyboard!.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
//            self.navigationController?.pushViewController(history, animated: false)
//
//
//        case 5:
//            let profile = self.storyboard!.instantiateViewController(withIdentifier: "UserProfileSetting") as! UserProfileSetting
//            self.navigationController?.pushViewController(profile, animated: false)
//
//        case 6:
//            UserDefaults.standard.removeObject(forKey: "mobileNumber")
//            let vc = storyboard!.instantiateViewController(withIdentifier:"LoginSignUpOptionVC")
//            let navVC = UINavigationController(rootViewController: vc)
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            appDelegate?.window?.rootViewController = navVC
//            appDelegate?.window?.makeKeyAndVisible()
//
//        default:
//            print("can't find view controller")
//        }

    }

    
    
}

