//
//  HeadToHeadVC.swift
//  MedQuiz
//
//  Created by Chad Johnson on 3/27/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

/*
 HeadToHeadVC allows the user to select a friend for a head to head game invitation.
 */

class HeadToHeadVC: UIViewController, UITableViewDelegate, UITableViewDataSource, HeadToHeadFriendRequestViewCellDelegate {

    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var quizKey:String!
    var friends:[Student]!

    /*
     Retrieve user friends and set values for table view.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        friends = currentGlobalStudent.friends!
        
        let friendRequestsCellNib = UINib(nibName: "HeadToHeadFriendRequestTableViewCell", bundle: nil)
        self.friendsTableView.register(friendRequestsCellNib, forCellReuseIdentifier: "friendRequest_cell")

        self.friendsTableView.delegate = self
        self.friendsTableView.dataSource = self

        self.friendsTableView.rowHeight = 100.0
        self.friendsTableView.allowsSelection = false
        self.friendsTableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
        self.friendsTableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Return number of sections in table (1).
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*
     Return number of rows in section of table view.
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    /*
     Set and return table view cell at indexPath.
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HeadToHeadFriendRequestTableViewCell = friendsTableView.dequeueReusableCell(withIdentifier: "friendRequest_cell") as! HeadToHeadFriendRequestTableViewCell
        cell.delegate = self
        cell.friend = friends[indexPath.row]
        cell.setViews()
        return cell
    }
    
    /*
     Check if selected friend if online and not busy. Create database objects for head to head game and transition to lobby.
     */
    
    func requestMade(selectedFriend: Student) {
        StudentModel.From(key: selectedFriend.databaseID!) {friend in
            if !friend.online! {
                let alert = UIAlertController(title:"Friend Offline", message:"Friend is offline at the moment.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if friend.headToHeadGameRequest == nil{
                let headToHeadGameReference = Database.database().reference().child("head-to-head-game").childByAutoId()
                headToHeadGameReference.child("quiz").setValue(self.quizKey)
                headToHeadGameReference.child("inviter").child("student").setValue(currentUserID)
                headToHeadGameReference.child("inviter").child("ready").setValue(false)
                headToHeadGameReference.child("invitee").child("student").setValue(selectedFriend.databaseID)
                headToHeadGameReference.child("invitee").child("ready").setValue(false)
                headToHeadGameReference.child("accepted").setValue(false)
                headToHeadGameReference.child("decided").setValue(false)
                
                let inGameLeaderboardReference = Database.database().reference().child("inGameLeaderboards").childByAutoId()
                inGameLeaderboardReference.child("game").setValue(headToHeadGameReference.key)
                let inviterLeaderboardRef = inGameLeaderboardReference.child("students").child(currentUserID)
                inviterLeaderboardRef.child("studentKey").setValue(currentUserID)
                inviterLeaderboardRef.child("studentScore").setValue(0)
                let inviteeLeaderboardRef = inGameLeaderboardReference.child("students").child(selectedFriend.databaseID!)
                inviteeLeaderboardRef.child("studentKey").setValue(selectedFriend.databaseID)
                inviteeLeaderboardRef.child("studentScore").setValue(0)
                
                let friendReference = Database.database().reference().child("student").child(selectedFriend.databaseID!)
                friendReference.child("headtoheadgamerequest").setValue(headToHeadGameReference.key)
                
                let userReference = Database.database().reference().child("student").child(currentUserID)
                userReference.child("headtoheadgamerequest").setValue(headToHeadGameReference.key)
                
                let quizLobbyVC = self.storyboard?.instantiateViewController(withIdentifier: "quizLobbyVC") as! QuizLobbyVC
                quizLobbyVC.quizKey = self.quizKey
                quizLobbyVC.gameKey = headToHeadGameReference.key
                quizLobbyVC.headToHeadOpponent = selectedFriend
                quizLobbyVC.quizMode = QuizLobbyVC.QuizMode.HeadToHead
                quizLobbyVC.isInvitee = false
                
                globalBusy = true
                self.present(quizLobbyVC, animated: false, completion: nil)
            }
            else{
                let alert = UIAlertController(title:"Friend Busy", message:"Friend is busy at the moment.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /*
     Dismiss view.
     */
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
