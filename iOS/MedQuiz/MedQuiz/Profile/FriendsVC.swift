//
//  AltAddFriendsVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 3/3/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    

    @IBOutlet weak var friendRequestsTable: UITableView!
    @IBOutlet weak var searchFriendTextfield: UITextField!
    @IBOutlet weak var searchResultLabel: UILabel!
    
    let placeholderTextColor = UIColor.hexStringToUIColor(hex: "FF8D84")
    let activeTextColor = UIColor.hexStringToUIColor(hex: "439EC4")
    
    var cellUsernames:[String] = ["Kyle102", "Jeniffer308", "Mark075", "Layla690"]
    var cellImages:[UIImage] = [#imageLiteral(resourceName: "StudentAvatarPlaceholder.png"), #imageLiteral(resourceName: "StudentAvatarPlaceholder.png"), #imageLiteral(resourceName: "StudentAvatarPlaceholder.png"), #imageLiteral(resourceName: "StudentAvatarPlaceholder.png")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let friendRequestsCellNib = UINib(nibName: "FriendRequestsTableViewCell", bundle: nil)
        friendRequestsTable.register(friendRequestsCellNib, forCellReuseIdentifier: "friendRequests_cell")
        
        friendRequestsTable.delegate = self
        friendRequestsTable.dataSource = self
        
        friendRequestsTable.rowHeight = 100.0
        friendRequestsTable.allowsSelection = false
        friendRequestsTable.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
        friendRequestsTable.separatorStyle = .none
        
        searchFriendTextfield.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellUsernames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FriendRequestsTableViewCell = friendRequestsTable.dequeueReusableCell(withIdentifier: "friendRequests_cell") as! FriendRequestsTableViewCell
        cell.setViews(username: cellUsernames[indexPath.row], avatarImage: cellImages[indexPath.row])
        return cell
    }
    
    
    @IBAction func friendUsernameTextFieldTouchDown(_ sender: Any) {
        searchFriendTextfield.text = ""
        searchFriendTextfield.textColor = activeTextColor
    }
    
    
    @IBAction func friendUsernameTextFieldEditingDidEnd(_ sender: Any) {
        searchFriendTextfield.textColor = placeholderTextColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFriendTextfield.textColor = placeholderTextColor
        searchFriendTextfield.endEditing(true)
        friendSearch(friendUsername: searchFriendTextfield.text!)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchResultLabel.isHidden = true
    }
    
    
    //Temporary conditionals used, will be replaced when connections to database established
    func friendSearch(friendUsername:String) {
        
        StudentModel.Where(child: StudentModel.USERNAME, equals: friendUsername) { (student: [StudentModel]) in
            
            if student.count == 0 {
                
                self.searchResultLabel.text = "Search failed: No matches found"
                
//                if (errorTrue){
//                    searchResultLabel.text = "Search failed: Unable to connect to server"
//                }
//                else{
//                    searchResultLabel.text = "Search failed: No matches found"
//                }
            } else {
               //add your friend
                self.searchResultLabel.text = "Search successful"
//                let stud = student[0]
//                print(stud)
//                let image = UIImage() //should be profile pic of stud
//                let friends : [Student] = [] // should be friends list from stud
//                var newFriend = Student(userName: stud.studentUsername!, profilePic: image, friends: friends, totalPoints: stud.totalPoints!, hasChangedUsername: stud.hasChangedUsername!)
//                print(newFriend)
            }
        }
        
        searchResultLabel.isHidden = false
    }
    
    @IBAction func backFromFriends(_ sender: Any) {
        self.dismiss(animated: false) {
        }
    }
    
    
}
