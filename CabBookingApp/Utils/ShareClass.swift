//
//  ShareClass.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 01/08/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//


import UIKit

class SharedClass: NSObject {
    static let sharedInstance = SharedClass()
    
    //Show alert
    func alert(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(defaultAction)
        DispatchQueue.main.async(execute: {
            view.present(alert, animated: true)
        })
    }

}
