//  ProfileSideBarCell.swift
//  MedQuiz
//
//  Created by Maddy Transue on 11/14/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

/*
 ProfileSideBarCell displays basic user profile information in the SideBar.
 */

class ProfileSideBarCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var scoreNumberLabel: UILabel!
    
    var checkTotalPointsUpdateRef:DatabaseReference!
    var checkTotalPointsUpdateHandle:DatabaseHandle!
    var checkTotalPointsUpdateSet = false
    
    /*
     Set background color. Observe changes in user totalPoints.
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        
        checkTotalPointsUpdateRef = Database.database().reference(withPath:"student/\(currentUserID)/score")
        checkTotalPointsUpdateHandle = checkTotalPointsUpdateRef.observe(.value, with: { snapshot in
            self.checkTotalPointsUpdateSet = true

            let scoreFormatter = NumberFormatter()
            scoreFormatter.numberStyle = NumberFormatter.Style.decimal

            self.scoreNumberLabel.text = scoreFormatter.string(from: NSNumber(value: snapshot.value as! Int))
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
     Remove database observers. 
     */
    
    func removeListeners(){
        if checkTotalPointsUpdateSet {
            checkTotalPointsUpdateRef.removeObserver(withHandle: checkTotalPointsUpdateHandle)
        }
    }
    
}
