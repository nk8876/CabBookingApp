//
//  MenuViewController.swift
//  NavigationDrawer
//
//  Created by Dheeraj Arora on 25/09/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin

class MenuViewController: UIViewController {
    
    var tap: UITapGestureRecognizer!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var menuName : [String] = ["Payment","History","Profile","Help","Share","Logout"]
    var menuIcon  = [UIImage(named: "baseline_payment_white_24pt_1x"),UIImage(named: "baseline_history_white_24pt_1x"),
                     UIImage(named: "ic_person_outline_white_2x"),UIImage(named: "baseline_settings_white_24dp"),
                     UIImage(named: "logout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        swipGestureAction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //navigationController?.navigationBar.barTintColor = UIColor.darkGray
        // hide the default back buttons
        self.navigationItem.hidesBackButton = true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func setupViews()   {
        guard let name = UserDefaults.standard.object(forKey: "full_name") else { return }
        self.userName.text = (name as! String)
        
        userProfilePic.layer.cornerRadius = userProfilePic.frame.height/2
        userProfilePic.layer.masksToBounds = true
        let tapPress = UITapGestureRecognizer(target: self, action: #selector(handleTapPress))
        menuTableView.addGestureRecognizer(tapPress)
        tapPress.cancelsTouchesInView = true
    }
    func swipGestureAction()  {
        let swipLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipLeft)
    }
    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer){
        switch gesture.direction {
        case  .right:
            //show menu
             showMenu()
        case  .left:
            closeOnSwip()
            closeOnTap()
        default:
            break
        }
    }
    func closeOnSwip()  {
        if AppDelegate.menu_bool{
            //show menu
            //showMenu()
        }else{
            //close menu
            closeMenu()
        }
    }
    func closeOnTap() {
        if AppDelegate.menu_bool{
            //show menu
            tap = UITapGestureRecognizer(target: self, action: #selector(tappedAction))
            tap.numberOfTapsRequired = 1
            view.addGestureRecognizer(tap)
        }else{
            //close menu
             closeMenu()
        }
        
    }
    @objc func tappedAction(){
        UIView.animate(withDuration: 0.3, animations: { ()-> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (finished) in
            self.view.removeFromSuperview()
        }
        
        AppDelegate.menu_bool = true
    }
    func showMenu() {
        UIView.animate(withDuration: 0.3) { ()-> Void in
            self.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
            self.addChild(self)
            self.view.addSubview(self.view)
            AppDelegate.menu_bool = false
        }
    }
    
    func closeMenu() {
        UIView.animate(withDuration: 0.3, animations: { ()-> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (finished) in
            self.view.removeFromSuperview()
        }

        AppDelegate.menu_bool = true
    }
    
    @objc func handleTapPress(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            let tapLocation = sender.location(in: self.menuTableView)
            if let tapIndexPath = self.menuTableView.indexPathForRow(at: tapLocation) {
                if (self.menuTableView.cellForRow(at: tapIndexPath) as? TableViewCell) != nil {
                    //do what you want to cell here
                    switch tapIndexPath.row {
                    case 0:
                        let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
                        self.navigationController?.pushViewController(paymentVC, animated: true)
                    case 1:
                        let historyVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
                        self.navigationController?.pushViewController(historyVC, animated: true)
                    case 2:
                        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileSetting") as! UserProfileSetting
                        self.navigationController?.pushViewController(profileVC, animated: true)
                    case 3:
                        let helpVC = self.storyboard?.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                        self.navigationController?.pushViewController(helpVC, animated: true)
                    case 4:
                        GIDSignIn.sharedInstance().signOut()
                        UserDefaults.standard.removeObject(forKey: "mobile_number")
                        UserDefaults.standard.set(false, forKey: "facebook_login")
                        UserDefaults.standard.set(false, forKey: "isUserLoginGoogleSignIn")
                        GIDSignIn.sharedInstance().signOut()
                        let manager = LoginManager()
                        manager.logOut()
                        AccessToken.current = nil  
                        let vc = storyboard!.instantiateViewController(withIdentifier:"LoginVC")
                        let navVC = UINavigationController(rootViewController: vc)
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.window?.rootViewController = navVC
                        appDelegate?.window?.makeKeyAndVisible()
                        
                    default:
                        break
                    }
                    
                }
            }
        }
    }
}
extension MenuViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        cell.lblTitle.text = menuName[indexPath.row]
        cell.imgIcon.image = menuIcon[indexPath.row]
        return cell
    }
}
extension MenuViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let index = indexPath.row
//        print(index)
       
//        switch indexPath.row {
//        case 0:
//            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
//            self.navigationController?.pushViewController(paymentVC, animated: true)
//        case 1:
//            let historyVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
//            self.navigationController?.pushViewController(historyVC, animated: true)
//        case 2:
//            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileSetting") as! UserProfileSetting
//            self.navigationController?.pushViewController(profileVC, animated: true)
//        case 3:
//            let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
//            self.navigationController?.pushViewController(settingVC, animated: true)
//        case 4:
//            //UserDefaults.standard.removeObject(forKey: "mobileNumber")
//            let vc = storyboard!.instantiateViewController(withIdentifier:"LoginSignUpOptionVC")
//            let navVC = UINavigationController(rootViewController: vc)
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            appDelegate?.window?.rootViewController = navVC
//            appDelegate?.window?.makeKeyAndVisible()
//        default:
//            break
//        }

    }
    
}

