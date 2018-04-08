//
//  HeadToHeadVC.swift
//  MedQuiz
//
//  Created by Chad Johnson on 3/27/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

class HeadToHeadVC: UIViewController, UITableViewDelegate, UITableViewDataSource, HeadToHeadFriendRequestViewCellDelegate {

    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var quizKey:String!
    var friends:[Student]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Temp quiz key value
        quizKey = "96f8f44213334d4eb8ff"
        
        //friends = user.friends!
        
        let friendRequestsCellNib = UINib(nibName: "HeadToHeadFriendRequestTableViewCell", bundle: nil)
        friendsTableView.register(friendRequestsCellNib, forCellReuseIdentifier: "friendRequest_cell")
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        friendsTableView.rowHeight = 100.0
        friendsTableView.allowsSelection = false
        friendsTableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
        friendsTableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HeadToHeadFriendRequestTableViewCell = friendsTableView.dequeueReusableCell(withIdentifier: "friendRequest_cell") as! HeadToHeadFriendRequestTableViewCell
        cell.delegate = self
        cell.friend = friends[indexPath.row]
        cell.setViews()
        return cell
    }
    
    func requestMade(selectedFriend: Student) {
        let headToHeadGameReference = Database.database().reference().child("head-to-head-game").childByAutoId()
        headToHeadGameReference.child("quiz").setValue(quizKey)
        //headToHeadGameReference.child("inviter").setValue(user.key)
        headToHeadGameReference.child("invitee").setValue(selectedFriend.databaseID)
        headToHeadGameReference.child("accepted").setValue(false)
        headToHeadGameReference.child("decided").setValue(false)
       
        let friendReference = Database.database().reference().child("student").child(selectedFriend.databaseID!)
        friendReference.child("headtoheadgamerequests").childByAutoId().setValue(headToHeadGameReference.key)
        
        let quizLobbyVC = self.storyboard?.instantiateViewController(withIdentifier: "quizLobbyVC") as! QuizLobbyVC
        quizLobbyVC.quizKey = quizKey
        quizLobbyVC.headToHeadGameKey = headToHeadGameReference.key
        quizLobbyVC.headToHeadOpponent = selectedFriend
        quizLobbyVC.quizMode = QuizLobbyVC.QuizMode.HeadToHead
        mainQuizVC.present(quizLobbyVC, animated: false, completion: nil)
    }
    
    
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
