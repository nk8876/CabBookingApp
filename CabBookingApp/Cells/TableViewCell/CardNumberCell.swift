//
//  CardNumberCell.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 11/09/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class CardNumberCell: UITableViewCell {
    
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var paymentIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
