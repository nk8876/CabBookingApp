//
//  TableViewCell.swift
//  PractiseAppDemo
//
//  Created by Monet  on 12/08/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit


class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuName: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
