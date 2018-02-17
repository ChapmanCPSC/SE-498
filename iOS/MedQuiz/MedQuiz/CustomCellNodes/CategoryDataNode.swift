//
//  CategoryDataNode.swift
//  ExpandableTable
//
//  Created by Harnack, Paul (Student) on 2/15/18.
//  Copyright © 2018 Harnack, Paul (Student). All rights reserved.
//

import Foundation

class CategoryDataNode:CellDataNode{
    
    var categoryName:String
    override class func reuseIdentifier() -> String {
        return "CategoryCell"
    }

    init(categoryName:String, children: [CellDataNode], completionEvents: [() -> ()]) {
        self.categoryName = categoryName

        super.init(children: children, completionEvents: completionEvents)
    }
}
