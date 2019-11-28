//
//  EnterOtpVC.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 26/07/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class EnterOtpVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtOTPOne: UITextField!
    @IBOutlet weak var txtOTPTwo: UITextField!
    @IBOutlet weak var txtOTPThree: UITextField!
    @IBOutlet weak var txtOTFour: UITextField!
    @IBOutlet weak var btnVerifyOTP: UIButton!
    @IBOutlet weak var lblPhoneTitile: UILabel!

    var countryCode: String?
    var phoneNumber: String?
    var resultMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        configureUI()
    }
    
    func setUpView() {
        btnVerifyOTP.layer.cornerRadius = btnVerifyOTP.frame.height/2
        txtOTPOne.becomeFirstResponder()
        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardTappedOutside()
       
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // hide the default back buttons
        self.navigationItem.hidesBackButton = true
    }
    @objc func handleDismiss()
    {
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationItem.title = "Enter OTP"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_ios_white_24pt_1x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
    }
    @objc func keyboardWillChange(notification:Notification)
    {
        guard let heightRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification
        {
            view.frame.origin.y = -heightRect.height + 200
        }else{
            view.frame.origin.y = 0
        }
        
    }
    deinit {
        //stop listening for keyboard hide/show events
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @IBAction func goToNextVC(_ sender: UIButton) {
         validation()
    }
    
    func validation() {
        let otp = "\(txtOTPOne.text!)\(txtOTPTwo.text!)\(txtOTPThree.text!)\(txtOTFour.text!)"
        if otp.isEmpty
        {
        SharedClass.sharedInstance.alert(view: self, title: "OTP Warning", message: "Please enter OTP")
            
        }
        else{
            VerifyAPI.validateVerificationCode(self.countryCode!, self.phoneNumber!, otp) { (checked) in
                if checked.success{
                    self.resultMessage = checked.message
                    goToNextPage()
                }else{
                    self.resultMessage = checked.message
                    SharedClass.sharedInstance.alert(view: self, title: "OTP Warning", message: self.resultMessage!)
                }
            }
        }
        
        func goToNextPage(){
            let detailsVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
             detailsVC.countryCode = countryCode!
             detailsVC.message = self.resultMessage
            self.navigationController?.pushViewController(detailsVC, animated: false)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (((textField.text?.count)!) < 1) && (string.count > 0){
                if textField == txtOTPOne{
                    txtOTPTwo.becomeFirstResponder()
                }
                if textField == txtOTPTwo{
                    txtOTPThree.becomeFirstResponder()
                }
                if textField == txtOTPThree{
                    txtOTFour.becomeFirstResponder()
                }
                if textField == txtOTFour{
                    txtOTFour.becomeFirstResponder()
                }
                textField.text = string
                return false
        }
        
        else if ((textField.text?.count)! >= 1) && (string.count == 0){

            if textField == txtOTPTwo{
                txtOTPOne.becomeFirstResponder()
            }
            if textField == txtOTPThree{
                txtOTPTwo.becomeFirstResponder()
            }
            if textField == txtOTFour{
                txtOTPThree.becomeFirstResponder()
            }
            if textField == txtOTPOne{
                txtOTPOne.becomeFirstResponder()
            }
            textField.text = ""
            return false
        }
            
        else if (textField.text?.count)! >= 1{
            textField.text = string
            return false
        }
        return true
    }
    @IBAction func btnGoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
 
}
