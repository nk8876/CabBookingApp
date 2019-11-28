//
//  AddCardDetails.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 09/09/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class AddCardDetails: UIViewController {
    
    var arrCountryName: [String] = ["India","Austrelia","Bangladesh","Pakistan","US","SriLanka","Chine","Russia"]
    var pickewView: UIPickerView!
    @IBOutlet weak var txtCountryName: UITextField!
    @IBOutlet weak var txtCvvNumber: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var centerX: NSLayoutConstraint!
    @IBOutlet weak var centerY: NSLayoutConstraint!
    @IBOutlet weak var pupUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var btnAddCard: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpView()
         createToolbar()
         createPickerView()
         formatCardNumber()
         configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
     navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationItem.title = "Add Account Info"
        navigationController?.navigationBar.barStyle = .black
        
       navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_ios_white_24pt_1x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
    }
    @objc func handleDismiss()
   {
    self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    func setUpView() {
        //txtCountryName.text = "India"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:   #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
       
        pupUpView.layer.cornerRadius = 10
        pupUpView.layer.masksToBounds = true
        okButton.layer.cornerRadius = okButton.frame.height / 2
        okButton.layer.masksToBounds = true
        btnAddCard.layer.cornerRadius = btnAddCard.frame.height / 2
        btnAddCard.layer.masksToBounds = true
        self.hideKeyboardTappedOutside()
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
    
    func createPickerView()
    {
        pickewView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 216))
        pickewView.delegate = self
        pickewView.delegate?.pickerView?(pickewView, didSelectRow: 0, inComponent: 0)
        txtCountryName.inputView = pickewView
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
        txtCountryName.inputAccessoryView = toolbar
        
    }
    @objc func closePickerView()
    {
        view.endEditing(true)
    }

    @IBAction func showPupUp(_ sender: UIButton) {
        centerX.constant = 0
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0.5
        }
    }
    
    @IBAction func cloasePupUp(_ sender: Any) {
        centerX.constant = -330
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        }
    }
    
    @IBAction func AddCardAction(_ sender: Any) {
        validation()
    }
    
    func validation()  {
        guard let cardNumber = txtCardNumber.text else {
            return
        }
        if cardNumber.isEmpty{
           SharedClass.sharedInstance.alert(view: self, title: "Card Number", message: "Please enter card number")
        }
        if cardNumber.count > 19 || cardNumber.count < 19 {
             SharedClass.sharedInstance.alert(view: self, title: "Invalid Card Number", message: "Please enter valid card number")
        }
        guard let expiryDate = txtExpiryDate.text else {
            return
        }
        if expiryDate.isEmpty{
            SharedClass.sharedInstance.alert(view: self, title: "Card Expiry Number", message: "Please enter card expiry date")
        }
        guard let cvvNumber = txtCvvNumber.text else {
            return
        }
        if cvvNumber.isEmpty{
            SharedClass.sharedInstance.alert(view: self, title: "CVV Number", message: "Please enter CVV number")
        }
        if cvvNumber.count > 3 || cvvNumber.count < 3 {
            SharedClass.sharedInstance.alert(view: self, title: "Invalid CVV Number", message: "Please enter valid CVV number")
        }
        
        guard let country = txtCountryName.text else {
            return
        }
        if country.isEmpty{
            SharedClass.sharedInstance.alert(view: self, title: "Select Country", message: "Please select country name")
        }
    }
    
    func formatCardNumber()  {
        self.txtCardNumber.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
      
   }
   
    @objc func didChangeText(textField:UITextField) {
        textField.text = self.modifyCreditCardString(creditCardString: textField.text!)
    }
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    @IBAction func formatExpiryDate(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(handleChange(sender:)), for: .valueChanged)
        txtExpiryDate.inputView = datePickerView
    }
    @objc func handleChange(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/YY"
        txtExpiryDate.text = dateFormatter.string(from: sender.date)
    }
}

extension AddCardDetails: UITextViewDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        if(textField == txtCardNumber) {
            return newLength <= 19
        }
        return true
    }
}
extension AddCardDetails: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return arrCountryName.count
    }
}

extension AddCardDetails: UIPickerViewDelegate {
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return arrCountryName[row]
       
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let codeIndex = pickerView.selectedRow(inComponent: 0)
        self.txtCountryName.text = "\(arrCountryName[codeIndex])"
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
            attributedString = NSAttributedString(string: arrCountryName[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        default:
            attributedString = nil
        }
        return attributedString
    }
}


