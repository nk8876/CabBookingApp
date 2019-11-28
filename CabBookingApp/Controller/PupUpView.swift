//
//  PupUpView.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 09/09/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class PupUpView: UIViewController {

    
    @IBOutlet weak var pupUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
     
         pupUpView.layer.cornerRadius = 20
        pupUpView.layer.masksToBounds = true
          okButton.layer.cornerRadius = okButton.frame.height / 2
        okButton.layer.masksToBounds = true
    }
    

    @IBAction func closePupUp(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
