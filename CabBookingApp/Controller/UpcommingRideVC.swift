//
//  PendingRequestVC.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 19/08/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class UpcommingRideVC: UIViewController {

    var username: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        if let name = username{
            print("User Name is: \(name)")
        }else{
            print("User Name is not found...")
        }
      self.navigationItem.title = "Pending Request"

    }
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationItem.title = "Pending Rides"
        navigationController?.navigationBar.barStyle = .black
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_ios_white_24pt_1x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
    }
    @objc func handleDismiss()
    {
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func goToNextVC(_ sender: Any) {
        
    }
    
   
}
