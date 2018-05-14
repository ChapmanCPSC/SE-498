//
//  LeaderboardCell.swift
//  MedQuiz
//
//  Created by Omar Sherief on 2/14/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

/*
 LeaderboardCell displays student information in LeaderboardVC.
 */

class LeaderboardCell: UITableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    /*
     Set background color when preparing for reuse.
     */
    
    override func prepareForReuse() {
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
