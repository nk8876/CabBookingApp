//
//  AppDelegate.swift
//  CabBookingApp
//
//  Created by Dheeraj Arora on 20/09/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import GoogleMaps
import FacebookCore
import FacebookLogin
import GooglePlaces
import Google
import GoogleSignIn
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let googleMapsApiKey = "AIzaSyBcywSTZ1DH9ZWqon18owqouNqCPZbie-o"
    static var menu_bool = true
    let mainStortyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize sign-in
        application.statusBarStyle = .lightContent // .default
        GIDSignIn.sharedInstance().clientID = "969342632993-57g2d19govjlhelm89tqsu7n2fk0pj8l.apps.googleusercontent.com"
        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey("AIzaSyDH3pl8UDfXIlti5X_ie-GR1ReqOK-rsJQ")
        checkUserLoginStatus()
        facebookLoginStatus()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    GIDSignIn.sharedInstance().handle(url as URL,sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
   
    func facebookLoginStatus() {
        if let accessToken = AccessToken.current {
            print("Access Token is:\(accessToken)")
            UserDefaults.standard.set(accessToken, forKey: "facebookAccessToken")
            let dashboard = mainStortyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let nav = UINavigationController(rootViewController: dashboard)
            window!.rootViewController = nav
            window!.makeKeyAndVisible()
           
        }
    }
    
    func checkUserLoginStatus()  {
        let isUserLoggedInWithPhoneNumber = UserDefaults.standard.object(forKey: "mobileNumber")
        let isUserLoggedInWithGoogleSignIn = UserDefaults.standard.bool(forKey: "isUserLoginGoogleSignIn")
        let facebookLogin = UserDefaults.standard.bool(forKey: "facebook_login")
        
        if (isUserLoggedInWithPhoneNumber != nil) {
            print("user is signed in with phone number")
           let homeViewController = mainStortyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let nav = UINavigationController(rootViewController: homeViewController)
            window!.rootViewController = nav
            window!.makeKeyAndVisible()
        }
        else if isUserLoggedInWithGoogleSignIn{
            print("user is signed in with google")
            let homeViewController = mainStortyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let nav = UINavigationController(rootViewController: homeViewController)
            window!.rootViewController = nav
            window!.makeKeyAndVisible()
        }
        else if facebookLogin{
            print("user is signed in with facebook")
            let homeViewController = mainStortyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let nav = UINavigationController(rootViewController: homeViewController)
            window!.rootViewController = nav
            window!.makeKeyAndVisible()
        }
        else{
            // code to show your login VC
            print("user is not signed in")
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

