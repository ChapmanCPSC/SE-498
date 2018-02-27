
//
//  ProfileVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var lastQuizImageView: UIImageView!
    @IBOutlet weak var globallyImageView: UIImageView!
    @IBOutlet weak var friendsImageView: UIImageView!
    
    @IBOutlet weak var changeImageView: UIImageView!
    
    var username = "Maddy Transue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileAvatarChange = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.profileAvatarPressed))
        
        profileImage.addGestureRecognizer(profileAvatarChange)
        
        usernameLabel.text = username
        
        lastQuizImageView.layer.borderColor = UIColor.init(red:0.0, green:0.0, blue:1.0, alpha:1.0).cgColor
        
        globallyImageView.layer.borderColor = UIColor.init(red:1.0, green:0.0, blue:0.0, alpha:1.0).cgColor
        
        friendsImageView.layer.borderColor = UIColor.init(red:1.0, green:1.0, blue:0.0, alpha:1.0).cgColor
        
        let mask = UIImageView(image: #imageLiteral(resourceName: "StudentAvatarPlaceholder.png"))
        mask.frame = profileImage.bounds
        changeImageView.mask = mask
        changeImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    @IBAction func addFriendsPressed(_ sender: Any) {
        let addFriendsVC =  self.storyboard?.instantiateViewController(withIdentifier: "addFriends") as! AddFriendsVC
        self.present(addFriendsVC, animated: false, completion: nil)
    }
    
    @objc func profileAvatarPressed(){
        print("woo")
        let changeAvatarVC = self.storyboard?.instantiateViewController(withIdentifier: "changeAvatar") as! ChangeAvatarVC
        self.present(changeAvatarVC, animated: false, completion: nil)
    }
    @IBAction func logoutPressed(_ sender: Any) {
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBAction func changeUsernamePressed(_ sender: Any) {
        let changeUsernameVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeUsernameVC") as! ChangeUsernameVC
        self.present(changeUsernameVC, animated: false, completion: nil)
    }
}

