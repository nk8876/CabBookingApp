//
//  PendingDetailViewController.swift
//  PractiseAppDemo
//
//  Created by Dheeraj Arora on 23/08/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit

class UpcommingRideDetail: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    let arrImage = [#imageLiteral(resourceName: "micro_car"),#imageLiteral(resourceName: "taxi1"),#imageLiteral(resourceName: "mini_car"),#imageLiteral(resourceName: "driving"),#imageLiteral(resourceName: "micro_car")]
    let arrName = ["Micro","Mini","Sedan","SUV","Luxury"]
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
       
    }
    

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func backButton()  {
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.title = "Pending Detail"
    }
    
}
extension UpcommingRideDetail: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(arrImage.count)
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
       
//         cell.carImage.image = arrImage[indexPath.row]
//
//         cell.carImage.layer.borderWidth = 0.5
//         cell.carImage.layer.borderColor = UIColor.darkGray.cgColor
//         cell.carImage.layer.cornerRadius = cell.carImage.frame.width / 2
//         cell.lblName.text = arrName[indexPath.row]
        
         return cell
        
    }
   
}
extension UpcommingRideDetail: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: myCollectionView.frame.width/3, height: myCollectionView.frame.height/2)
  }
    
    
}
