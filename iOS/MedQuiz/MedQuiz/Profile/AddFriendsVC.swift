//
//  AddFriendsVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

class AddFriendsVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var friendUsernameTextField: UITextField!
    @IBOutlet weak var friendRequestsTableView: UITableView!
    
    let placeholderTextColor = UIColor.hexStringToUIColor(hex: "FF8D84")
    let activeTextColor = UIColor.hexStringToUIColor(hex: "439EC4")
    
    var friendUsername: String?
    
    var cellUsernames:[String] = ["Kyle102", "Jeniffer308", "Mark075", "Layla690"]
    var cellImages:[UIImage] = [#imageLiteral(resourceName: "StudentAvatarPlaceholder.png"), #imageLiteral(resourceName: "StudentAvatarPlaceholder.png"), #imageLiteral(resourceName: "StudentAvatarPlaceholder.png"), #imageLiteral(resourceName: "StudentAvatarPlaceholder.png")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let friendRequestsCellNib = UINib(nibName: "FriendRequestsTableViewCell", bundle: nil)
        friendRequestsTableView.register(friendRequestsCellNib, forCellReuseIdentifier: "friendRequests_cell")
        
        friendRequestsTableView.rowHeight = 100.0
        friendRequestsTableView.allowsSelection = false
        friendRequestsTableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
    }
    
    @IBAction func friendUsernameTextFieldTouchDown(_ sender: Any) {
        friendUsernameTextField.text = ""
        friendUsernameTextField.textColor = activeTextColor
    }
    
    @IBAction func backToFriends(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func friendUsernameTextFieldEditingDidEnd(_ sender: Any) {
        friendUsernameTextField.textColor = placeholderTextColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        friendUsername = friendUsernameTextField.text
        friendUsernameTextField.textColor = placeholderTextColor
        friendUsernameTextField.endEditing(true)
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FriendRequestsTableViewCell = friendRequestsTableView.dequeueReusableCell(withIdentifier: "friendRequests_cell") as! FriendRequestsTableViewCell
        cell.setViews(username: cellUsernames[indexPath.row], avatarImage: cellImages[indexPath.row])
        return cell
    }
    
}

