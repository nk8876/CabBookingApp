//
//  CancelRidesVC.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 19/08/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class CancelRidesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Cancels Rides"
    }
    

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true
        )
    }

}
