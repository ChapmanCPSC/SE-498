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
    
    @IBOutlet weak var lastQuizRankLabel: UILabel!
    @IBOutlet weak var globalRankLabel: UILabel!
    @IBOutlet weak var friendsRankLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var username = "KetSwiftMoves"
    
    var lastQuizRank = 4
    var globalRank = 20
    var friendsRank = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileAvatarChange = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.profileAvatarPressed))
        
        profileImage.addGestureRecognizer(profileAvatarChange)
        
        usernameLabel.text = username
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        lastQuizRankLabel.text = formatter.string(from: NSNumber(value: lastQuizRank))
        globalRankLabel.text = formatter.string(from: NSNumber(value: globalRank))
        friendsRankLabel.text = formatter.string(from: NSNumber(value: friendsRank))
    }
    
    @IBAction func addFriendsPressed(_ sender: Any) {
        let addFriendsVC =  self.storyboard?.instantiateViewController(withIdentifier: "addFriends") as! AddFriendsVC
        self.present(addFriendsVC, animated: false, completion: nil) 
    }
    
    func profileAvatarPressed(){
        print("woo")
       let changeAvatarVC = self.storyboard?.instantiateViewController(withIdentifier: "changeAvatar") as! ChangeAvatarVC
        self.present(changeAvatarVC, animated: false, completion: nil)
    }
    
}

