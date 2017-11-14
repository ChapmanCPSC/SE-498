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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileAvatarChange = UITapGestureRecognizer(target: self, action: Selector("profileAvatarPressed"))
        
        profileImage.addGestureRecognizer(profileAvatarChange)

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

