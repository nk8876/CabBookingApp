//
//  UserDetailsVC.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 29/07/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class UserDetailsVC: UIViewController {
    
    var countryCode = ""
    var message: String?
    @IBOutlet weak var txtFullName: UITextField!{
        didSet {
            txtFullName.setIcon1(UIImage(named: "user1")!)
            
        }
    }
    @IBOutlet weak var txtEmail: UITextField!{
        didSet {
            txtEmail.setIcon1(UIImage(named: "email1")!)
            
        }
    }
    @IBOutlet weak var txtReferralCode: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblInfoTitle: UILabel!
    var email = "naresh1214@gmail.com"
   
    override func viewDidLoad() {
       super.viewDidLoad()
        setUpView()
        let mobileNumber = UserDefaults.standard.object(forKey: "mobileNumber" )
        lblInfoTitle.text = "\(lblInfoTitle.text ?? "")\(countryCode)\(String(describing: mobileNumber!))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
    func setUpView() {
        btnRegister.layer.cornerRadius = btnRegister.frame.height/2
        txtFullName.becomeFirstResponder()
        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardTappedOutside()
    }
    @objc func keyboardWillChange(notification:Notification)
    {
        guard let heightRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification
        {
            view.frame.origin.y = -heightRect.height + 160
        }else{
            view.frame.origin.y = 0
        }
        
    }
    deinit {
        //stop listening for keyboard hide/show events
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @IBAction func btnRegisterAction(_ sender: UIButton) {
        validation()
    }
    func validation() {

        if txtFullName.text!.isEmpty{
            SharedClass.sharedInstance.alert(view: self, title: "Full Name required", message: "Full name can't be Blank")
            
        }
        else if (txtFullName.text?.count)! < 4  && (txtFullName.text?.count)! != 30
        {
            SharedClass.sharedInstance.alert(view: self, title: "Full Name ", message: "Full name Must Be in Between 5 to 30 characters")
        }
            
        else if isValidEmail(emailID:txtEmail.text!)  == false
        {
            SharedClass.sharedInstance.alert(view: self, title: "Email Correction ", message: "Please enter valide email address")
        }
        else
        {
            navigateToUserHomeView()

        }
    }
    
    func navigateToUserHomeView()  {
        UserDefaults.standard.set(txtFullName.text, forKey: "user_name")
        UserDefaults.standard.set(txtEmail.text, forKey: "user_email")
        let next = storyboard!.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(next, animated: true)
   
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)

    }
        func isValidEmail(emailID:String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: emailID)
        }
    
    @IBAction func btnGoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UITextField {
    func setIcon1(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
