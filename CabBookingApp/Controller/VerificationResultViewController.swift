//
//  VerificationResultViewController.swift
//  CabBookingApp
//
//  Created by Dheeraj Arora on 28/09/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class VerificationResultViewController: UIViewController {
    
    @IBOutlet var successIndication: UILabel! = UILabel()
    var message: String?
    
    override func viewDidLoad() {
        if let resultToDisplay = message {
            successIndication.text = resultToDisplay
        } else {
            successIndication.text = "Something went wrong!"
        }
        super.viewDidLoad()
    }
}
