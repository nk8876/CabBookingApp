//
//  StartVerificationViewController.swift
//  CabBookingApp
//
//  Created by Dheeraj Arora on 28/09/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class StartVerificationViewController: UIViewController {
    @IBOutlet var phoneNumberField: UITextField! = UITextField()
    @IBOutlet var countryCodeField: UITextField! = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func sendVerification() {
        if let phoneNumber = phoneNumberField.text,
            let countryCode = countryCodeField.text {
            VerifyAPI.sendVerificationCode(countryCode, phoneNumber)
             goToVerifyAction()
        }
    }
    func goToVerifyAction() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CheckVerificationViewController") as! CheckVerificationViewController
        next.countryCode = countryCodeField.text
        next.phoneNumber = phoneNumberField.text
        self.navigationController?.pushViewController(next, animated: true)
    }
   
}
