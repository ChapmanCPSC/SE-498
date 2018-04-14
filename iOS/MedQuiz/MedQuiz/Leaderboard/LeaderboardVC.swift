//
//  LeaderboardVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

class LeaderboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    var friendsOrGlobal = "friends"
    
    @IBOutlet weak var switchButton: UIView!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var leaderboardHeadline: UILabel!
    @IBOutlet weak var leaderboardTableview: UITableView!
    @IBOutlet weak var globalSwitchLabel: UILabel!
    @IBOutlet weak var friendSwitchLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        leaderboardHeadline.text = "Friends"
        
        switchView.layer.cornerRadius = 30;
        switchButton.backgroundColor = OurColorHelper.pharmAppTeal

        switchButton.layer.cornerRadius = 25;
    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LeaderboardCell = leaderboardTableview.dequeueReusableCell(withIdentifier: "leaderboard_cell") as! LeaderboardCell
        
        
        if indexPath.row == 0{
            cell.backgroundColor = OurColorHelper.pharmAppYellow
            //TODO: just assuming current user is first for now, change later to actual postion
            cell.usernameLabel.text = globalUsername
            cell.scoreLabel.text = String(globalHighscore)
        }
        else{
            cell.scoreLabel.text = "0"
        }
        
        cell.rankLabel.text = String(indexPath.row+1)
        
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
    
}

