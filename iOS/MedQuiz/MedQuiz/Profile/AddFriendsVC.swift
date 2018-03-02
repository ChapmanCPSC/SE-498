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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let friendRequestsCellNib = UINib(nibName: "FriendRequestsTableViewCell", bundle: nil)
        friendRequestsTableView.register(friendRequestsCellNib, forCellReuseIdentifier: "friendRequests_cell")
        
        friendRequestsTableView.rowHeight = 100.0
        friendRequestsTableView.allowsSelection = false
        friendRequestsTableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
    }
    
    @IBAction func friendUsernameTextFieldEditingDidBegin(_ sender: Any) {
        friendUsernameTextField.textColor = activeTextColor
    }
    
    @IBAction func backToFriends(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        friendUsername = friendUsernameTextField.text
        
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FriendRequestsTableViewCell = friendRequestsTableView.dequeueReusableCell(withIdentifier: "friendRequests_cell") as! FriendRequestsTableViewCell
        
        return cell
    }
    
}

