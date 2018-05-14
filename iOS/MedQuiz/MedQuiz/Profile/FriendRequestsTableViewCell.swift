//
//  FriendRequestsTableViewCell.swift
//  MedQuiz
//
//  Created by Chad Johnson on 2/28/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

/*
FriendRequestsTableViewCell displays friend information in FriendRequestsTableView.
 */

class FriendRequestsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    var avatarImage: UIImage?
    var username: String?

    var student:Student?
    var parent:RequestAction!
    
    /*
     Set component values and borderView color and width.
     */
    
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
    
    /*
     Set either username or profile picture related component values using provided username or profile picture.
     */
    
    func setViews(username:String?, avatarImage:UIImage?){
        print("done setting view")
        if let _ = username{
            self.username = username
            self.usernameLabel.text = username
        }
        if let _ = avatarImage {
            self.avatarImage = avatarImage
            self.avatarImageView.image = avatarImage
        }

    }
    
    /*
     Set component values using provided student.
     */

    func setStudent(student:Student){
        self.student = student
        setViews(username: student.userName, avatarImage: student.profilePic)
    }
    
    /*
     Signal delegate to accept selected friend request.
     */
    
    @IBAction func addPressed(_ sender: Any) {
        parent.addFriendSelected(student: self.student!)
    }
    
    /*
     Signal delegate to hide selected friend request.
     */
    
    @IBAction func hidePressed(_ sender: Any) {
        parent.hideRequestSelected(student: self.student!)
    }
}
