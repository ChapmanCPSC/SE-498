
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

/*
 ProfileVC displays relevent profile information and navigates to changing username, changing profile picture, and managing friends list.
 */

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
    
    /*
     Set component values. Add gesture recognizer for change profile picture.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Testing profile info population
        //Here I created a variable testUserLoginInput, assume
        // this would be used for example on successful login/authentication
        // from Firebase. We have the input from the usernameTextField
        // and we can use that on login to get the username and profile pic etc.
//        let testUser = "_________"
        //I query a student by the key and I print the student's username on success
//        StudentModel.From(key: testUser) { (aStudent) in
//            print("Testing profile info population")
//            print(aStudent.studentUsername!)
//        }
        
        let profileAvatarChange = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.profileAvatarPressed))
        
        profileImageView.addGestureRecognizer(profileAvatarChange)
        profileImageView.image = globalProfileImage
        
        usernameLabel.text = globalUsername
        
        //rgba(67, 158, 196, 1)
        lastQuizImageView.layer.borderColor = UIColor(red:0.26, green:0.62, blue:0.77, alpha:1.0).cgColor
        
        //rgba(255, 141, 132, 1)
        globallyImageView.layer.borderColor = UIColor(red:1.00, green:0.55, blue:0.52, alpha:1.0).cgColor
        //rgba(255, 228, 131, 1)
        friendsImageView.layer.borderColor = UIColor(red:1.00, green:0.89, blue:0.51, alpha:1.0).cgColor
        
        let mask = UIImageView(image: #imageLiteral(resourceName: "StudentAvatarPlaceholder.png"))
        mask.frame = profileImageView.bounds
        changeImageView.mask = mask
        changeImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    /*
     Set local profile picture data using provided image.
     */
    
    func dataChanged(profileImage: UIImage) {
        //TODO: MAKE SURE IMAGE IS CHANGED ON DB
        globalProfileImage = profileImage
        profileImageView.image = globalProfileImage
    }
    
    /*
     Set local username data using provided username and usernameChanged values..
     */
    
    func dataChanged(username: String, usernameChanged: Bool) {
        self.username = username
        usernameLabel.text = username
        editUsernameButton.isHidden = usernameChanged
    }
    
    /*
     Transition to AddFriendsVC.
     */
    
    @IBAction func addFriendsPressed(_ sender: Any) {
//        let addFriendsVC =  self.storyboard?.instantiateViewController(withIdentifier: "addFriends") as! AddFriendsVC
        let altAddFriendsVC =  self.storyboard?.instantiateViewController(withIdentifier: "altFriendRequest") as! FriendsVC

        self.present(altAddFriendsVC, animated: false, completion: nil)

    }
    
    
    /*
     Transition to ChangeAvatarVC.
     */
    
    @objc func profileAvatarPressed(){
        let changeAvatarVC = self.storyboard?.instantiateViewController(withIdentifier: "changeAvatarVC") as! ChangeAvatarVC
        changeAvatarVC.profileImage = globalProfileImage
        changeAvatarVC.delegate = self
        self.present(changeAvatarVC, animated: false, completion: nil)
    }
    
    
    /*
     Log out of app. Dismiss to LoginVC.
     */
    @IBAction func logoutPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let err {
            print(err)
        }
        
    }
    
    
    /*
     Transition to ChangeUsernameVC.
     */
    
    @IBAction func changeUsernamePressed(_ sender: Any) {
        let changeUsernameVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeUsernameVC") as! ChangeUsernameVC
        changeUsernameVC.delegate = self
        changeUsernameVC.username = username
        changeUsernameVC.usernameChanged = usernameChanged
        self.present(changeUsernameVC, animated: false, completion: nil)
    }
}

