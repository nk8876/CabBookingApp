//
//  UserProfileSetting.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 19/08/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class UserProfileSetting: UIViewController {
//    func setUserData(name: String, email: String, phone: String) {
//        self.txtFullName.text = name
////        self.txtEmail.text = email
////        self.txtPhone.text = phone
//
//    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var btnChangeProfileImage: UIButton!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnSave: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureUI()
    }
    
    @objc func handleDismiss()
    {
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationItem.title = "Edit Profile"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_ios_white_24pt_1x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
    }
    func setupView() {

        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        guard let image = profileImage else { return }
        image.layer.cornerRadius = image.frame.height/2
        image.image = UIImage(named: "myImage")
        image.layer.borderWidth = 2
        image.clipsToBounds = true

        btnChangePassword.layer.cornerRadius = btnChangePassword.frame.height/2
        btnChangePassword.clipsToBounds = true

        btnSave.layer.cornerRadius = btnSave.frame.height/2
        btnSave.clipsToBounds = true

        self.hideKeyboardTappedOutside()
        setData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: true)
    }
    func setData() {
        let name = UserDefaults.standard.object(forKey: "full_name")
        self.txtFullName.text = "\(name ?? "")"
        let email = UserDefaults.standard.object(forKey: "email")
        self.txtEmail.text = "\(email ?? "")"
        let phone = UserDefaults.standard.object(forKey: "mobile_number")
        self.txtPhone.text = "\(phone ?? "")"
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

    @IBAction func btnChanegPasswordAction(_ sender: Any) {
    }

    @IBAction func btnChangeProfilePicture(_ sender: UIButton) {
    }

    @IBAction func btnSaveAction(_ sender: UIButton) {
    }
}
