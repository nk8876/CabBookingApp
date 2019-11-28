//
//  LoginVC.swift
//  CabBookingApp
//
//  Created by Dheeraj Arora on 01/10/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import FirebaseCore
import FBSDKLoginKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var fbLoginAction: UIButton!
    @IBOutlet weak var btnGoogleLogin: UIButton!
   
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtPassword1: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    var pickewView: UIPickerView!
    var arrCountryName: [String] = ["India","Austrelia","Bangladesh","Pakistan","US"]
    var arrCountryCode: [String] = ["+91","+61","+880","  +92","+1"]
    @IBOutlet weak var txtEmail: UITextField!{
        didSet {
            txtEmail.setIcon(UIImage(named: "email")!)
            
        }
    }
    @IBOutlet weak var txtPassword: UITextField!{
        didSet {
            txtPassword.setIcon(UIImage(named: "password_lock")!)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewSetup()
        createPickerView()
        createToolbar()
    }
    func ViewSetup()  {
        loginView.isHidden = false
        registerView.isHidden = true
        loginView.layer.cornerRadius = 10
        registerView.layer.cornerRadius = 10
        btnLogin.layer.cornerRadius = btnLogin.frame.height/2
        btnLogin.layer.masksToBounds = true
        btnRegister.layer.cornerRadius = btnRegister.frame.height/2
        btnRegister.layer.masksToBounds = true
        fbLoginAction.layer.cornerRadius = fbLoginAction.frame.height/2
        fbLoginAction.layer.masksToBounds = true
        
        btnGoogleLogin.layer.cornerRadius = btnGoogleLogin.frame.height/2
        btnGoogleLogin.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:   #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         self.hideKeyboardTappedOutside()
        
        segControl.backgroundColor = .clear
        segControl.tintColor = .clear
        segControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18) ?? "",
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        segControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18) ?? "",
            NSAttributedString.Key.foregroundColor: UIColor.orange
            ], for: .selected)
        
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
    }
    @objc func keyboardWillChange(notification:Notification)
    {
        guard let heightRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification
        {
            view.frame.origin.y = -heightRect.height + 260
        }else{
            view.frame.origin.y = 0
        }
        
    }
    deinit {
        //stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @IBAction func changeViewAction(_ sender: UISegmentedControl) {
        if segControl.selectedSegmentIndex == 0 {
            loginView.isHidden = false
            registerView.isHidden = true
        }else if segControl.selectedSegmentIndex == 1 {
            loginView.isHidden = true
            registerView.isHidden = false
        }
    }
    @IBAction func btnLoginAction(_ sender: UIButton) {
        validation()
    }
    
    func validation() {
        guard let email = txtEmail.text, let pass = txtPassword.text else { return }
        
        if email.isEmpty{
            SharedClass.sharedInstance.alert(view: self, title: "Enter email", message: "Please enter email address")
        }
        else if isValidEmail(emailID: email)  == false
        {
            SharedClass.sharedInstance.alert(view: self, title: "Email Correction ", message: "Please enter valide email address")
        }
        else if pass.isEmpty {
            SharedClass.sharedInstance.alert(view: self, title: "Enter password", message: "Please enter password")
        }
        else if isValidPassword(testPassword: pass) == false {
            SharedClass.sharedInstance.alert(view: self, title: "Invalid Password", message: "Please Enter Password at least one uppercase, at least one digit, at least one lowercase, 8 characters total ")
        }
        else{
            UserDefaults.standard.set(txtEmail.text!, forKey: "email")
            goToHomePage()
            
        }
    }
    func goToHomePage() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
       self.navigationController?.pushViewController(next, animated: true)
    }
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    func isValidPassword(testPassword:String?) -> Bool {
        guard testPassword != nil else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testPassword)
    }
    
    @IBAction func btnRegisterAction(_ sender: UIButton) {
        validateDetails()
    }
    func validateDetails() {
        guard let fullName = txtFullName.text, let mobile = txtMobileNumber.text, let countryCode = txtCountryCode.text, let emailAddress = txtEmailAddress.text, let password = txtPassword1.text, let conPassword = txtConfirmPassword.text else { return }
        
        if fullName.isEmpty{
            SharedClass.sharedInstance.alert(view: self, title: "Enter full name", message: "Please enter full name")
        }
        else if mobile.isEmpty
        {
            SharedClass.sharedInstance.alert(view: self, title: "Mobile number ", message: "Please enter mobile number")
        }
        else if countryCode.isEmpty {
            SharedClass.sharedInstance.alert(view: self, title: "Country Code", message: "Please select country code")
        }
        else if emailAddress.isEmpty {
            SharedClass.sharedInstance.alert(view: self, title: "Email Address", message: "Please enter email address")
        }
        else if password.isEmpty {
            SharedClass.sharedInstance.alert(view: self, title: "Password", message: "Please enter password")
        }
        else if conPassword.isEmpty {
            SharedClass.sharedInstance.alert(view: self, title: "Confirm Password", message: "Please confirm password")
        }
        else if validatePhone(number: mobile) == false {
            SharedClass.sharedInstance.alert(view: self, title: "Invalid Mobile Number", message: "Please enter valid mobile number  ")
        }
        else if isValidEmail(emailID: emailAddress) == false {
            SharedClass.sharedInstance.alert(view: self, title: "Invalid Email Address", message: "Please enter valid email address")
        }
        else if isValidPassword(testPassword: password) == false {
            SharedClass.sharedInstance.alert(view: self, title: "Invalid Password", message: "Please Enter Password at least one uppercase, at least one digit, at least one lowercase, 8 characters total")
        }
        else if isValidPassword(testPassword: conPassword) == false {
            SharedClass.sharedInstance.alert(view: self, title: "Invalid Password", message: "Please Enter Password at least one uppercase, at least one digit, at least one lowercase, 8 characters total")
        }
        else if password != conPassword{
            SharedClass.sharedInstance.alert(view: self, title: "Password Not Matching", message: "Password and Confirm Passowrd Does Not Match")
        }
        else{
            UserDefaults.standard.set(txtFullName.text, forKey: "full_name")
            UserDefaults.standard.set(txtMobileNumber.text!, forKey: "mobile_number")
            UserDefaults.standard.set(txtCountryCode.text!, forKey: "country_code")
            VerifyAPI.sendVerificationCode(countryCode, mobile)
           goToOtpPage()
            
        }
    }
    func goToOtpPage() {
        let otpPage = self.storyboard?.instantiateViewController(withIdentifier: "EnterOtpVC") as! EnterOtpVC
        otpPage.countryCode = txtCountryCode.text
        otpPage.phoneNumber = txtMobileNumber.text
        self.navigationController?.pushViewController(otpPage, animated: true)
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

    //Social Media Login
    //Facebook Login
    @IBAction func btnFacebookLoginAction(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "facebook_login")
        let loginManager = LoginManager()
        loginManager.loginBehavior = .web
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("User cancelled login.")
                loginManager.logOut()
                self.dismiss(animated: true, completion: nil)
            case .success(_,_,_):
                self.getUserInfo { userInfo, error in
                    if let err = error{
                        print(err.localizedDescription)
                    }
                    if let userInfo = userInfo,let id = userInfo["id"],let name = userInfo["name"],let email = userInfo["email"],let firstName = userInfo["first_name"], let lastName = userInfo["last_name"], let dob = userInfo["birthday"]  {
                        print("User Info:\(userInfo)")
                        print("User Id:\(id)")
                        print("User Name:\(name)")
                        print("User Email:\(email)")
                        print("User First Name:\(firstName)")
                        print("User Last Name:\(lastName)")
                        print("User Dob:\(dob)")
                        
                    }
                    
                    if let userInfo = userInfo, let pictureUrl = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        print("User Picture URL are :\(pictureUrl)")
                    }
                    
                    let dashboard = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(dashboard, animated: true)
                    //self.present(dashboard, animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
    func getUserInfo(completion:@escaping(_:[String:Any]?,_:Error?)->Void) {
        let permissionDictionary = [
            "fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large)"]
        let request = GraphRequest(graphPath: "me", parameters: permissionDictionary)
        request.start { (responce, result) in
            switch result{
            case .failed(let error):
                completion(nil,error)
            case .success(response: let graphResponce):
                completion(graphResponce.dictionaryValue,nil)
            }
        }
    }
    
    //Google Login
    @IBAction func btnGoogleSignInAction(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isUserLoginGoogleSignIn")
        GIDSignIn.sharedInstance().signIn()
    }
    
}
extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 0, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 0, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
extension LoginVC: UIPickerViewDataSource {
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
extension LoginVC: UIPickerViewDelegate {
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
extension LoginVC: GIDSignInDelegate, GIDSignInUIDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //if any error stop and print the error
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        else{
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("User Id : \(userId ?? "")")
            print("Google Token : \(idToken ?? "")")
            print("User Full Name : \(fullName ?? "")")
            print("User Profile Given Name : \(givenName ?? "")")
            print("User Family Name : \(familyName ?? "")")
            print("User Email : \(email ?? "")")
            let dashboard = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(dashboard, animated: true)
            
        }
        
    } 
    
}
