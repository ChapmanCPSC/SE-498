//
//  EditProfileVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

protocol ChangeAvatarVCDelegate: class{
    func dataChanged(profileImage: UIImage)
}

class ChangeAvatarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AvatarCollectionViewCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var array:[UIImage] = [#imageLiteral(resourceName: "StudentAvatarPlaceholder.png"), #imageLiteral(resourceName: "MockAnswerTwo.png"), #imageLiteral(resourceName: "MockAnswerOne.png"), #imageLiteral(resourceName: "RightAnswer.png"), #imageLiteral(resourceName: "MockAnswerThree.png")]
    
    var profileImage: UIImage?
    
    weak var delegate: ChangeAvatarVCDelegate?
    
    var selectedImageIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumInteritemSpacing = 10000.0
        layout.minimumLineSpacing = 200
        layout.itemSize = CGSize(width: 150, height: 150)
        collectionView.collectionViewLayout = layout
        
        collectionView.showsHorizontalScrollIndicator = true
        
        let selectedImageIndex = array.index(of: profileImage!)
        array.swapAt(selectedImageIndex!, array.capacity / 2)
        selectedImageIndexPath = IndexPath(row: array.capacity / 2, section: 0)
    }
    override func viewDidAppear(_ animated: Bool) {
        //collectionView.scrollToItem(at: selectedImageIndexPath, at: [], animated: false)
        collectionView.contentOffset.x = (collectionView.contentSize.width / 2) - (collectionView.bounds.width / 2)
    }
    
    @IBAction func doneWithAvatar(_ sender: Any) {
        delegate?.dataChanged(profileImage: profileImage!)
        self.dismiss(animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AvatarCollectionViewCell
        cell.imageView.image = array[indexPath.row]
        cell.delegate = self
        
        adjustVisibleCollectionCells()
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustVisibleCollectionCells()
    }
    
    func adjustVisibleCollectionCells(){
        let maxScale:CGFloat = 1.7
        let minHeight:CGFloat = 70.0
        let maxHeight:CGFloat = 100.0
        
        for cell in collectionView.visibleCells as! [AvatarCollectionViewCell]{
            let multiplier = min((cell.frame.midX - collectionView.bounds.minX) / (collectionView.bounds.midX - collectionView.bounds.minX), -((cell.frame.midX - collectionView.bounds.maxX) / (collectionView.bounds.maxX - collectionView.bounds.midX)))
            let scale = 1 + (maxScale - 1) * multiplier
            
            cell.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            var frame = cell.frame
            frame.origin.y = minHeight + multiplier * (maxHeight - minHeight)
            cell.frame = frame
            
            if (cell.imageView.image == profileImage){
                collectionView.selectItem(at: collectionView.indexPath(for: cell), animated: false, scrollPosition: [])
            }
        }
    }
    
    func cellSelected(selectedImage: UIImage) {
        profileImage = selectedImage
    }
}

