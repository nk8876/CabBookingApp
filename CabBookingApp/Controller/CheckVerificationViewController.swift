//
//  CheckVerificationViewController.swift
//  CabBookingApp
//
//  Created by Dheeraj Arora on 28/09/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class CheckVerificationViewController: UIViewController {
    
    @IBOutlet var codeField: UITextField! = UITextField()
    @IBOutlet var errorLabel: UILabel! = UILabel()
    
    var countryCode: String?
    var phoneNumber: String?
    var resultMessage: String?
    
    @IBAction func validateCode() {
        self.errorLabel.text = nil // reset
        if let code = codeField.text {
            VerifyAPI.validateVerificationCode(self.countryCode!, self.phoneNumber!, code) { checked in
                if (checked.success) {
                    self.resultMessage = checked.message
                    self.showResultAction()
                    //self.performSegue(withIdentifier: "checkResultSegue", sender: nil)
                } else {
                    self.errorLabel.text = checked.message
                }
            }
        }
    }
    
    func showResultAction()  {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "VerificationResultViewController") as! VerificationResultViewController
        next.message = resultMessage
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
}
