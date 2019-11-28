//
//  PaymentVC.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 19/08/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var tableHight: NSLayoutConstraint!
    var arrCardNumber: [String] = ["1234567891234567","1234567891234567","1234567891234567","1234567891234567","1234567891234567"]
    var paymentIcon = UIImage(named: "payment_black_24dp")
    var username: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if let name = username{
            print("User Name is: \(name)")
        }else{
            print("User Name is not found...")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
     navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHight?.constant = self.myTable.contentSize.height
    }
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationItem.title = "Payment"
        navigationController?.navigationBar.barStyle = .black
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_ios_white_24pt_1x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
    }
    @objc func handleDismiss()
    {
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    @IBAction func goToAddPaymentVC(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AddCardDetails") as! AddCardDetails
        self.navigationController?.pushViewController(next, animated: false)
    }
}
extension PaymentVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCardNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardNumberCell") as! CardNumberCell
        
        let strCard = arrCardNumber[indexPath.row]
        var resultString = String()
        
        // Loop through all the characters of your string
         strCard.characters.enumerated().forEach { (index, character) in
            
            // Add space every 4 characters
            if index % 4 == 0 && index > 0 {
                resultString += " "
            }
            
            if index < 12 {
                // Replace the first 12 characters by *
                resultString += "X"
                
            } else {
                // Add the last 4 characters to your final string
                resultString.append(character)
            }
            
        }
        cell.lblCardNumber.text = resultString
        cell.paymentIcon.image = paymentIcon
        self.viewWillLayoutSubviews()
        return cell
    }
    
    
}
extension PaymentVC: UITableViewDelegate{
    
}
