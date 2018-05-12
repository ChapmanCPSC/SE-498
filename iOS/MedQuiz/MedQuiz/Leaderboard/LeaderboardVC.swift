//
//  LeaderboardVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LeaderboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    var friendsOrGlobal = "friends"
    
    @IBOutlet weak var switchButton: UIView!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var leaderboardHeadline: UILabel!
    @IBOutlet weak var leaderboardTableview: UITableView!
    @IBOutlet weak var globalSwitchLabel: UILabel!
    @IBOutlet weak var friendSwitchLabel: UILabel!
    
    var friendsList : [StudentModel] = []
    
    var checkStudentRef:DatabaseReference!
    var checkStudentHandle:DatabaseHandle!
    var checkStudentSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkStudentRef = Firebase.Database.database().reference().child("student").child(currentUserID).child("friends")
        checkStudentHandle = checkStudentRef.observe(.value, with: { (snap: DataSnapshot) in
        
            Firebase.Database.database().reference().child("student").child(currentUserID).observeSingleEvent(of: DataEventType.value, with: { (user) in
                self.friendsList.append(StudentModel(snapshot: user))
            })
        
            for s in snap.children {
                let friend = FriendModel(snapshot: s as! DataSnapshot)
                Firebase.Database.database().reference().child("student").child(friend.key).observeSingleEvent(of: .value, with: { (friendSnap: DataSnapshot) in
                    
                    self.friendsList.append(StudentModel(snapshot: friendSnap))
                    self.leaderboardTableview.reloadData()
                })
            }
        })
        
        //TODO: sort the friendList by score
        
        globalSwitchLabel.isUserInteractionEnabled = true
        friendSwitchLabel.isUserInteractionEnabled = true
        switchView.isUserInteractionEnabled = true
        
        switchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchLeaderboardPressed)))
        friendSwitchLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchLeaderboardPressed)))
        globalSwitchLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchLeaderboardPressed)))
        
        leaderboardTableview.dataSource = self
        leaderboardTableview.delegate = self
        //Registering the leaderboard cell nib to use in tableview
        let leaderboardCellNib = UINib(nibName: "LeaderboardCell", bundle: nil)
        self.leaderboardTableview.register(leaderboardCellNib, forCellReuseIdentifier: "leaderboard_cell")
       // self.leaderboardTableview.isUserInteractionEnabled = false
        
        
        leaderboardHeadline.text = "Friends"
        
        switchView.layer.cornerRadius = 30;
        switchButton.backgroundColor = OurColorHelper.pharmAppTeal

        switchButton.layer.cornerRadius = 25;
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        removeListeners()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LeaderboardCell = leaderboardTableview.dequeueReusableCell(withIdentifier: "leaderboard_cell") as! LeaderboardCell
        
        cell.rankLabel.text = String(indexPath.row+1)
        cell.scoreLabel.text = String(self.friendsList[indexPath.row].score!)
        cell.usernameLabel.text = self.friendsList[indexPath.row].studentUsername!
        
        if friendsList[indexPath.row].studentUsername == globalUsername {
            cell.backgroundColor = OurColorHelper.pharmAppYellow
        }
        
        return cell
    }
    
    
    @IBAction func switchLeaderboardPressed(_ sender: Any) {
        print("tapped")
        if(friendsOrGlobal == "friends"){
            UIView.animate(withDuration: 0.5, animations: {
                self.switchButton.transform = CGAffineTransform(translationX: 200, y: 0)
                self.switchButton.backgroundColor = OurColorHelper.pharmAppRed
            }) { (true) in
                self.leaderboardHeadline.text = "Global"
                self.friendsOrGlobal = "global"
                print("done animating")
            }
        }
        else if(friendsOrGlobal == "global"){
            UIView.animate(withDuration: 0.5, animations: {
                self.switchButton.backgroundColor = OurColorHelper.pharmAppTeal
                self.switchButton.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (true) in
                self.leaderboardHeadline.text = "Friends"
                self.friendsOrGlobal = "friends"
                print("done animating")
            }
        }
    }
    
    func removeListeners(){
        if checkStudentSet {
            checkStudentRef.removeObserver(withHandle: checkStudentHandle)
        }
    }
    
}

