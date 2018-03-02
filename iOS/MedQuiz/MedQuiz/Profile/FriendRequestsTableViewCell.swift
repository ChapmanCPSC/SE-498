//
//  FriendRequestsTableViewCell.swift
//  MedQuiz
//
//  Created by Chad Johnson on 2/28/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

class FriendRequestsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var borderImageView: UIImageView!
    
    var avatarImage: UIImage?
    var username: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        usernameLabel.text = username
        avatarImageView.image = avatarImage
        borderImageView.layer.borderColor = UIColor.init(red:0.5, green:0.5, blue:0.5, alpha:0.3).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setViews(username:String, avatarImage:UIImage){
        self.username = username
        self.usernameLabel.text = username
        self.avatarImage = avatarImage
        self.avatarImageView.image = avatarImage
    }

}
