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
    var tag:Tag
    override class func reuseIdentifier() -> String {
        return "CategoryCell"
    }

    /*init(categoryName:String, children: [CellDataNode], completionEvents: [() -> ()]) {
        self.categoryName = categoryName

        super.init(children: children, completionEvents: completionEvents)
    }*/

    init(tag:Tag, children:[CellDataNode], completionEvents: [()->()]){
        self.tag = tag
        self.categoryName = tag.name!

        super.init(children: children, completionEvents: completionEvents)
    }
    
    deinit {
        categoryName = ""
        print("------->Deallocating CategoryDataNode")
    }
}
