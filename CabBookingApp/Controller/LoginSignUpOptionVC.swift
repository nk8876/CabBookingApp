//
//  LoginSignUpOptionVC.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 08/08/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import FirebaseCore
import FBSDKLoginKit
class LoginSignUpOptionVC: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var fbLoginAction: UIButton!
    @IBOutlet weak var btnGoogleLogin: UIButton!
  
    var token = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        //adding the delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        ViewSetup()
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func ViewSetup()  {
        btnLogin.layer.cornerRadius = btnLogin.frame.height/2
        btnLogin.layer.masksToBounds = true
        
        fbLoginAction.layer.cornerRadius = fbLoginAction.frame.height/2
        fbLoginAction.layer.masksToBounds = true
        
        btnGoogleLogin.layer.cornerRadius = btnGoogleLogin.frame.height/2
        btnGoogleLogin.layer.masksToBounds = true
     
    }
    @IBAction func goToLoginAction(_ sender: Any) {
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
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
    
    @IBAction func btnGoogleSignInAction(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isUserLoginGoogleSignIn")
        GIDSignIn.sharedInstance().signIn()
    }
    
    
}

extension LoginSignUpOptionVC: GIDSignInDelegate, GIDSignInUIDelegate{
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
