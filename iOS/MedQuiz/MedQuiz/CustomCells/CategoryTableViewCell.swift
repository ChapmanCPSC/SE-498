//
//  CategoryTableViewCell.swift
//  ExpandableTable
//
//  Created by Harnack, Paul (Student) on 2/15/18.
//  Copyright © 2018 Harnack, Paul (Student). All rights reserved.
//

import UIKit

class CategoryTableViewCell: CellType {

    @IBOutlet weak var lab_categoryName: UILabel!

    var categoryDataNode:CategoryDataNode!
    override class func reuseIdentifier()->String {
        return "CategoryCell"
    }
    
    override var cellDataNode: CellDataNode! {
        get {
            return self.categoryDataNode
        }
        set {

            self.categoryDataNode = newValue as! CategoryDataNode
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
        lab_categoryName.text = categoryDataNode?.categoryName
    }
}
