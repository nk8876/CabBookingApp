//
//  AddPaymentMethods.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 09/09/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class AddPaymentMethods: UIViewController {
    
    var arrIcon: [UIImage] = [#imageLiteral(resourceName: "google_pay"),#imageLiteral(resourceName: "upi_icon"),#imageLiteral(resourceName: "credit_card_black_24pt_1x"),#imageLiteral(resourceName: "paytm_icon"),#imageLiteral(resourceName: "phone_pe")]
    var arrPaymentName: [String] = ["Google Pay","UPI","Credit or Debit Card","Paytm","PhonePe"]

    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true
        )
        self.navigationController!.navigationBar.tintColor = UIColor.black
    }

}

extension AddPaymentMethods: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPaymentName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPaymentMethodsCell") as! AddPaymentMethodsCell
        cell.paymentIcon.image = arrIcon[indexPath.row]
        cell.lblPaymentName.text = arrPaymentName[indexPath.row]
        return cell
    }
    
    
}
extension AddPaymentMethods: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            let next = self.storyboard!.instantiateViewController(withIdentifier: "AddCardDetails") as! AddCardDetails
            self.navigationController!.pushViewController(next, animated: false)
        default:
            print("khfksf")
        }
    }
}
