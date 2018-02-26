//
//  EditProfileVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

class ChangeAvatarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let array:[String] = ["gentleman_icon-icons.com_55044.png", "gentleman_icon-icons.com_55044.png", "gentleman_icon-icons.com_55044.png", "gentleman_icon-icons.com_55044.png", "gentleman_icon-icons.com_55044.png", "gentleman_icon-icons.com_55044.png", "gentleman_icon-icons.com_55044.png", "gentleman_icon-icons.com_55044.png", "gentleman_icon-icons.com_55044.png", "gentleman_icon-icons.com_55044.png", "gentleman_icon-icons.com_55044.png", "gentleman_icon-icons.com_55044.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumInteritemSpacing = 10000.0
        layout.minimumLineSpacing = 200
        layout.itemSize = CGSize(width: 150, height: 150)
        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func doneWithAvatar(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AvatarCollectionViewCell
        cell.imageView.image = UIImage(named: array[indexPath.row] + ".png")
        return cell
    }
}

