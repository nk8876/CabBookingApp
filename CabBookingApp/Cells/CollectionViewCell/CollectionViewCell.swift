//
//  CollectionViewCell.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 28/08/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
   @IBOutlet weak var carImage: UIImageView!
   @IBOutlet weak var lblName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        addSubview(imgView)
        imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imgView.heightAnchor.constraint(equalTo: imgView.heightAnchor).isActive = true
        
        addSubview(lblTitile)
        lblTitile.topAnchor.constraint(equalTo: lblTitile.bottomAnchor).isActive = true
        lblTitile.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        lblTitile.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        lblTitile.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    let imgView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let lblTitile: UILabel = {
        let lbl = UILabel()
        lbl.text = "sample text"
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.numberOfLines = 1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
}
