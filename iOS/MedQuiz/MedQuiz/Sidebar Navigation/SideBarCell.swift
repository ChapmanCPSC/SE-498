//
//  SideBarCell.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import UIKit

/*
 SideBarCell allows the user to navigate through different views in the splitViewController through the SideBar table view.
 */

class SideBarCell: UITableViewCell {

    @IBOutlet weak var navigateToPage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
