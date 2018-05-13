//
//  LobbyPlayersCollectionViewCell.swift
//  MedQuiz
//
//  Created by Chad Johnson on 3/11/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

/*
 LobbyPlayersCollectionViewCell displays the profile picture, username, and score of non-user player for standard games in the lobby.
 */

class LobbyPlayersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
}
