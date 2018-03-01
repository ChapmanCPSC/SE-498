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
    
    var avatarImage: UIImage?
    var username: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
