//
//  LeaderboardVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

class LeaderboardVC: UIViewController {
    
    
    @IBOutlet weak var switchButton: UIView!
    @IBOutlet weak var switchView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchView.layer.cornerRadius = 5;
        switchView.layer.masksToBounds = true;
        
    }
    
}

