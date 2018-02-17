//
//  QuizTableViewCell.swift
//  ExpandableTable
//
//  Created by Harnack, Paul (Student) on 2/16/18.
//  Copyright © 2018 Harnack, Paul (Student). All rights reserved.
//

import UIKit

class QuizTableViewCell: CellType {

    @IBOutlet weak var lab_quizName: UILabel!
    
    var quizDataNode:QuizDataNode!
    override class func reuseIdentifier()->String {
        return "QuizCell"
    }

    override var cellDataNode: CellDataNode! {
        get {
            return self.quizDataNode
        }
        set {

            self.quizDataNode = newValue as! QuizDataNode
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func updateViews() {
        lab_quizName.text = quizDataNode?.quizName
    }
}
