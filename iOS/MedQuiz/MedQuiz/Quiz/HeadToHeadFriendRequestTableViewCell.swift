//
//  HeadToHeadFriendRequestTableViewCell.swift
//  MedQuiz
//
//  Created by Chad Johnson on 4/4/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

protocol HeadToHeadFriendRequestViewCellDelegate: class{
    func requestMade(selectedFriend: Student)
}

class HeadToHeadFriendRequestTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var borderView: UIView!
    
    var avatarImage: UIImage?
    var username: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        usernameLabel.text = ""
        avatarImageView.image = nil
        print("done nib")
        borderView.backgroundColor = UIColor.clear
        borderView.layer.borderWidth = 0.5
        borderView.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setViews(username:String, avatarImage:UIImage){
        print("done setting view")
        self.username = username
        self.usernameLabel.text = username
        self.avatarImage = avatarImage
        self.avatarImageView.image = avatarImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
