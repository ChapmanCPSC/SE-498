//
//  SubjectTableViewCell.swift
//  ExpandableTable
//
//  Created by Harnack, Paul (Student) on 2/16/18.
//  Copyright © 2018 Harnack, Paul (Student). All rights reserved.
//

import UIKit

class SubjectTableViewCell: CellType {

    @IBOutlet weak var lab_subjectName: UILabel!

    var subjectDataNode:SubjectDataNode!

    override class func reuseIdentifier() -> String {
        return "SubjectCell"
    }

    override var cellDataNode: CellDataNode! {
        get {
            return self.subjectDataNode
        }
        set {

            self.subjectDataNode = newValue as! SubjectDataNode
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
        lab_subjectName.text = subjectDataNode?.subjectName
    }
}
