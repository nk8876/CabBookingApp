//
//  LoginViewController.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 08/08/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var pickewView: UIPickerView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    var arrCountryName: [String] = ["India","Austrelia","Bangladesh","Pakistan","US"]
    var arrCountryFlag: [UIImage] = [UIImage(named: "in")!,UIImage(named: "au")!,UIImage(named: "bd")!,UIImage(named: "pk")!,UIImage(named: "us")!]
    var arrCountryCode: [String] = ["+91","+61","+880","  +92","+1"]
    var activeTextField = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpView()
        createToolbar()
        createPickerView()
     
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setUpView() {
        txtCountryCode.text = "+91"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:   #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        btnLogin.layer.cornerRadius = btnLogin.frame.height/2
        btnLogin.layer.borderWidth = 1
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
    
    @IBAction func goToNext(_ sender: UIButton) {
        validation()
    }
    
    func validation() {
        guard let phoneNumber = txtPhoneNumber.text, let countryCode = txtCountryCode.text else { return }
    
       if phoneNumber.isEmpty{
            SharedClass.sharedInstance.alert(view: self, title: "Enter Phone Number", message: "Please enter phone number")
        }
        else if countryCode.isEmpty {
            SharedClass.sharedInstance.alert(view: self, title: "Country Code Can't be Empty", message: "Please select country code")
        }
        else if !self.validatePhone(number: txtPhoneNumber.text!) {
           SharedClass.sharedInstance.alert(view: self, title: "Invalid phone number", message: "Please Enter Valide phone number")
        }
       else{
            UserDefaults.standard.set(txtPhoneNumber.text!, forKey: "mobileNumber")
            VerifyAPI.sendVerificationCode(countryCode, phoneNumber)
            goToOtpVerifyAction()

        }
    }
   func goToOtpVerifyAction() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "EnterOtpVC") as! EnterOtpVC
        next.countryCode = txtCountryCode.text
        next.phoneNumber = txtPhoneNumber.text
        self.navigationController?.pushViewController(next, animated: true)
    }
    func validatePhone(number: String) -> Bool {
        let PHONE_REGEX = "^[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: number)
        return result
    }
    
    func createPickerView()
    {
        pickewView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 216))
        pickewView.delegate = self
        pickewView.delegate?.pickerView?(pickewView, didSelectRow: 0, inComponent: 0)
        txtCountryCode.inputView = pickewView
        pickewView.backgroundColor = UIColor.brown
        
    }
    func createToolbar()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.red
        toolbar.backgroundColor = UIColor.blue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(LoginViewController.closePickerView))
        let closeButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(LoginViewController.closePickerView))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolbar.setItems([closeButton,spaceButton,doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtCountryCode.inputAccessoryView = toolbar
       
    }
    @objc func closePickerView()
    {
        view.endEditing(true)
    }

}

extension LoginViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return arrCountryName.count
        }
            return arrCountryCode.count
    }
}
extension LoginViewController: UIPickerViewDelegate {
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return "\(arrCountryName[row])"
        }
            return "\(arrCountryCode[row])"
     
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let codeIndex = pickerView.selectedRow(inComponent: 1)
        self.txtCountryCode.text = "\(arrCountryCode[codeIndex])"
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 130.0
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!

        switch component {
        case 0:
            attributedString = NSAttributedString(string: arrCountryName[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        case 1:
            attributedString = NSAttributedString(string: arrCountryCode[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        default:
            attributedString = nil
        }
        return attributedString
    }
   
}
