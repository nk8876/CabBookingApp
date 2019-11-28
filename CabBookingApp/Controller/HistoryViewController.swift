//
//  ViewController.swift
//  CustomeTableViewDemo
//
//  Created by Dheeraj Arora on 25/07/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON

class HistoryViewController: UIViewController {

    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var mySegment: UISegmentedControl!
    private let locationManager = CLLocationManager()
    private var marker = GMSMarker()
   
    var arrDateTime: [String] = ["29/3/19,09:06 PM","29/3/19,09:06 PM","29/3/19,09:06 PM"]
    var arrCar: [String] = ["abc","abc","abc"]
    var arrFare: [String] = ["100","100","100"]
    var arrFareBy: [String] = ["Cash","Paytm","PhonePe"]
    var arrRating: [String] = ["4","3","5"]
    var username: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if let name = username{
            print("User Name is: \(name)")
        }else{
            print("User Name is not found...")
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true
        )
        
    }
    @IBAction func btnSegClick(_ sender: UISegmentedControl) {
        self.myTable.reloadData()
    }
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationItem.title = "Ride History"
        navigationController?.navigationBar.barStyle = .black
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_ios_white_24pt_1x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
    }
    @objc func handleDismiss()
    {
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return arrDateTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCellView", for: indexPath) as! HistoryTableCellView
        switch mySegment.selectedSegmentIndex{
        case 0:
            cell.selectionStyle = .none
            cell.lblDateAndTime.text = arrDateTime[indexPath.row]
            cell.lblFare.text = arrFare[indexPath.row]
            cell.lblCarType.text = arrCar[indexPath.row]
            cell.lblFareThrough.text = arrFareBy[indexPath.row]
            cell.lblRating.text = arrRating[indexPath.row]

        case 1:
            cell.selectionStyle = .none
            cell.lblDateAndTime.text = arrDateTime[indexPath.row]
            cell.lblFare.text = arrFare[indexPath.row]
            cell.lblCarType.text = arrCar[indexPath.row]
            cell.lblFareThrough.text = arrFareBy[indexPath.row]
            cell.lblRating.text = arrRating[indexPath.row]

        default:
            print("kjhkhvkv")

        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        switch mySegment.selectedSegmentIndex{
        case 0:
            
            let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "RidesDetailsViewController") as! RidesDetailsViewController
             nextVC.car = arrCar[indexPath.row]
             nextVC.fare = arrFare[indexPath.row]
             nextVC.dateTimes = arrDateTime[indexPath.row]
             nextVC.payment = arrFareBy[indexPath.row]
             nextVC.rating = arrRating[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case 1:
            let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "RidesDetailsViewController") as! RidesDetailsViewController
            nextVC.car = arrCar[indexPath.row]
            nextVC.fare = arrFare[indexPath.row]
            nextVC.dateTimes = arrDateTime[indexPath.row]
            nextVC.payment = arrFareBy[indexPath.row]
            nextVC.rating = arrRating[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
          
        default:
            print("kjhkhvkv")
            
        }
        
 }
}

