//
//  AvatarCollectionViewCell.swift
//  MedQuiz
//
//  Created by Chad Johnson on 2/25/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool
    {
        didSet
        {
            if (self.isSelected)
            {
                self.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            }
            else
            {
                self.transform = CGAffineTransform.identity
            }
        }
    }
    
}
