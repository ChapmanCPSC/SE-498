//  ProfileSideBarCell.swift
//  MedQuiz
//
//  Created by Maddy Transue on 11/14/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import UIKit

class ProfileSideBarCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var scoreNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
