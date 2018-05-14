//
//  AvatarCollectionViewCell.swift
//  MedQuiz
//
//  Created by Chad Johnson on 2/25/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

protocol AvatarCollectionViewCellDelegate: class{
    func cellSelected(selectedImage: UIImage)
}

/*
 AvatarCollectionViewCell displays a profile picture in AvatarCollectionView.
 */

class AvatarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    weak var delegate: AvatarCollectionViewCellDelegate?
    
    override var isSelected: Bool
    {
        didSet
        {
            if (self.isSelected)
            {
                selectedImageView.isHidden = false
                cellSelected(selectedImage: imageView.image!)
            }
            else
            {
                selectedImageView.isHidden = true
            }
        }
    }
    
    /*
     Signal delegate to perform selection operations on selected image.
     */
    
    func cellSelected(selectedImage: UIImage){
        if let del = self.delegate{
            del.cellSelected(selectedImage: selectedImage)
        }
    }
}
