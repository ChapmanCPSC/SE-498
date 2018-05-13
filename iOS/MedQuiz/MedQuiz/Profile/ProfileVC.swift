
//
//  ProfileVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class ProfileVC: UIViewController, ChangeAvatarVCDelegate, ChangeUsernameVCDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var lastQuizImageView: UIImageView!
    @IBOutlet weak var globallyImageView: UIImageView!
    @IBOutlet weak var friendsImageView: UIImageView!
    
    @IBOutlet weak var changeImageView: UIImageView!
    @IBOutlet weak var editUsernameButton: UIButton!
    
    var username = ""
    var usernameChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        //Testing profile info population
        //Here I created a variable testUserLoginInput, assume
        // this would be used for example on successful login/authentication
        // from Firebase. We have the input from the usernameTextField
        // and we can use that on login to get the username and profile pic etc.
//        let testUser = "654426e87a6"
        //I query a student by the key and I print the student's username on success
//        StudentModel.From(key: testUser) { (aStudent) in
//            print("Testing profile info population")
//            print(aStudent.studentUsername!)
//        }
        
        
        
    
        
        
        
        
        let profileAvatarChange = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.profileAvatarPressed))
        
        profileImageView.addGestureRecognizer(profileAvatarChange)
        profileImageView.image = globalProfileImage
        
        usernameLabel.text = globalUsername
        
        lastQuizImageView.layer.borderColor = UIColor.init(red:0.0, green:0.0, blue:1.0, alpha:1.0).cgColor
        
        globallyImageView.layer.borderColor = UIColor.init(red:1.0, green:0.0, blue:0.0, alpha:1.0).cgColor
        
        friendsImageView.layer.borderColor = UIColor.init(red:1.0, green:1.0, blue:0.0, alpha:1.0).cgColor
        
        let mask = UIImageView(image: #imageLiteral(resourceName: "StudentAvatarPlaceholder.png"))
        mask.frame = profileImageView.bounds
        changeImageView.mask = mask
        changeImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    func dataChanged(profileImage: UIImage) {
        //TODO: MAKE SURE IMAGE IS CHANGED ON DB
        globalProfileImage = profileImage
        profileImageView.image = globalProfileImage
    }
    
    func dataChanged(username: String, usernameChanged: Bool) {
        self.username = username
        usernameLabel.text = username
        editUsernameButton.isHidden = usernameChanged
    }
    
    @IBAction func addFriendsPressed(_ sender: Any) {
//        let addFriendsVC =  self.storyboard?.instantiateViewController(withIdentifier: "addFriends") as! AddFriendsVC
        let altAddFriendsVC =  self.storyboard?.instantiateViewController(withIdentifier: "altFriendRequest") as! FriendsVC

        self.present(altAddFriendsVC, animated: false, completion: nil)

    }
    
    @objc func profileAvatarPressed(){
        let changeAvatarVC = self.storyboard?.instantiateViewController(withIdentifier: "changeAvatarVC") as! ChangeAvatarVC
        changeAvatarVC.profileImage = globalProfileImage
        changeAvatarVC.delegate = self
        self.present(changeAvatarVC, animated: false, completion: nil)
    }
    @IBAction func logoutPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let err {
            print(err)
        }
        
    }
    
    @IBAction func changeUsernamePressed(_ sender: Any) {
        let changeUsernameVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeUsernameVC") as! ChangeUsernameVC
        changeUsernameVC.delegate = self
        changeUsernameVC.username = username
        changeUsernameVC.usernameChanged = usernameChanged
        self.present(changeUsernameVC, animated: false, completion: nil)
    }
}

