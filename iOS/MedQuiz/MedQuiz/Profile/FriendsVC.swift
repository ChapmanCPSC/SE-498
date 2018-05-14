//
//  AltAddFriendsVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 3/3/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase


/*
 FriendsVC displays friend information and allows the user to interact with friend requests.
 */

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    

    @IBOutlet weak var friendRequestsTable: UITableView!
    @IBOutlet weak var searchFriendTextfield: UITextField!
    @IBOutlet weak var searchResultLabel: UILabel!
    
    @IBOutlet weak var searchFriendCard: UIView!
    
    @IBOutlet weak var searchFriendBorder: UIView!
    
    let placeholderTextColor = UIColor.hexStringToUIColor(hex: "FF8D84")
    let activeTextColor = OurColorHelper.pharmAppBlue

    var friendRequests:[Student] = []
    
    
    /*
     Retrieve current friends and friend requests. Set component values.
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        getFriendRequests()
        updateFriendsList()
        
        searchFriendCard.backgroundColor = OurColorHelper.pharmAppRed
        searchFriendBorder.backgroundColor = OurColorHelper.pharmAppBlue
        
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

    
    /*
     Retrieve friend requests from database.
     */
    
    func getFriendRequests(){
        Firebase.Database.database().reference()
                .child("student")
                .child(currentGlobalStudent.databaseID!)
                .child("friendrequests")
                .observeSingleEvent(of: .value, with: {(snap:DataSnapshot) in
                    for s in snap.children {
                        let friend = StudentModel(snapshot: s as! DataSnapshot)
                        currentGlobalStudent.addFriendRequest(studentModel: friend) {
                            self.friendRequests = currentGlobalStudent.friendRequests!
                            self.friendRequestsTable.reloadData()
                        }
                    }
                })
    }

    
    /*
     Return number of sections in tableView.
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*
     Return number of rows in provided tableView section.
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendRequests.count
    }
    
    
    /*
     Set and return cell at specified tableView indexPath.
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FriendRequestsTableViewCell = friendRequestsTable.dequeueReusableCell(withIdentifier: "friendRequests_cell") as! FriendRequestsTableViewCell
        cell.parent = self
        cell.setStudent(student: friendRequests[indexPath.row])
        return cell
    }
    
    
    /*
     Adjust input field text for editing.
     */
    
    @IBAction func friendUsernameTextFieldTouchDown(_ sender: Any) {
        searchFriendTextfield.text = ""
        searchFriendTextfield.textColor = activeTextColor
    }
    
    /*
     Adjust input field text for editing end.
     */
    
    @IBAction func friendUsernameTextFieldEditingDidEnd(_ sender: Any) {
        searchFriendTextfield.textColor = placeholderTextColor
    }
    
    /*
     Search for friend using text field input.
     */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFriendTextfield.textColor = placeholderTextColor
        searchFriendTextfield.endEditing(true)
        friendSearch(friendUsername: searchFriendTextfield.text!)
        return true
    }
    
    /*
     Hide search result label when editing starts.
     */
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchResultLabel.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        
        let length = text.characters.count + string.characters.count - range.length
        
        return length <= 20
    }
    
    /*
     Search database for user matching provided username.
     */
    
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
                let student = student[0]

                var alreadyRequested = false

                for requestedStudent in currentGlobalStudent.friendRequests! {
                    if requestedStudent.databaseID == student.key {
                        alreadyRequested = true
                        break
                    }
                }

                if alreadyRequested {
                    self.searchResultLabel.text = "Search failed: User has already requested you, check your requests"
                    return
                }

                var alreadyFriend = false

                for friendStudent in currentGlobalStudent.friends! {
                    if friendStudent.databaseID == student.key {
                        alreadyFriend = true
                        break
                    }
                }

                if alreadyFriend {
                    self.searchResultLabel.text = "Search failed: User is already your friend"
                    return
                }

                var isSelf = false
                if student.key == currentGlobalStudent.databaseID! {
                    isSelf = true
                }

                if isSelf {
                    self.searchResultLabel.text = "Search failed: You cannot request yourself"
                    return
                }

                self.searchResultLabel.text = "Search successful. Request sent"


                Firebase.Database.database().reference()
                    .child("student")
                    .child(student.key)
                    .child("friendrequests")
                    .child(currentGlobalStudent.databaseID!)
                    .setValue(true)

//                print(stud)
//                let image = UIImage() //should be profile pic of stud
//                let friends : [Student] = [] // should be friends list from stud
//                var newFriend = Student(userName: stud.studentUsername!, profilePic: image, friends: friends, totalPoints: stud.totalPoints!, hasChangedUsername: stud.hasChangedUsername!)
//                print(newFriend)
            }
        }
        
        searchResultLabel.isHidden = false
    }
    
    /*
     Dismiss view.
     */
    
    @IBAction func backFromFriends(_ sender: Any) {
        self.dismiss(animated: false) {
        }
    }
    
    func updateFriendsList(){
        Firebase.Database.database().reference()
            .child("student")
            .child(currentGlobalStudent.databaseID!)
            .child("friends")
            .observeSingleEvent(of: .value, with: { (snap: DataSnapshot) in
                for s in snap.children {
                    let friend = FriendModel(snapshot: s as! DataSnapshot)
                    Firebase.Database.database().reference()
                            .child("student")
                            .child(friend.key)
                            .observeSingleEvent(of: .value, with: { (friendSnap: DataSnapshot) in
                                currentGlobalStudent.addFriend(student: StudentModel(snapshot: friendSnap))
                    })
                }
        })
    }
    
    
}

extension FriendsVC:RequestAction {
    
    /*
     Hide request from selected student.
     */

    func hideRequestSelected(student:Student){
        print("Hide pressed")
        removeFromFriendRequests(student: student)
    }
    
    /*
     Add selected friend.
     */

    func addFriendSelected(student:Student){
        print("Add pressed")
        addToFriends(student: student)
        removeFromFriendRequests(student: student)
    }

    /*
     Remove hidden friend request from user Student object and database.
     */
    
    func removeFromFriendRequests(student:Student){
        for idx in 0..<currentGlobalStudent.friendRequests!.count{
            let friend:Student = currentGlobalStudent.friendRequests![idx]
            if friend.databaseID! == student.databaseID! {
                currentGlobalStudent.friendRequests!.remove(at: idx)
                self.friendRequests = currentGlobalStudent.friendRequests!
                self.friendRequestsTable.reloadData()
                break
            }
        }

        Firebase.Database.database().reference()
            .child("student")
            .child(currentGlobalStudent.databaseID!)
            .child("friendrequests")
            .child(student.databaseID!)
            .removeValue()
    }
    
    /*
     Make user and selected student friends in database.
     */

    func addToFriends(student: Student){
        // add to accepting user's friends list
        Firebase.Database.database().reference()
            .child("student")
            .child(currentGlobalStudent.databaseID!)
            .child("friends")
            .child(student.databaseID!)
            .setValue(true)

        // add to the requesting user's friends list
        Firebase.Database.database().reference()
                .child("student")
                .child(student.databaseID!)
                .child("friends")
                .child(currentGlobalStudent.databaseID!)
                .setValue(true)

        updateFriendsList()
    }

}
