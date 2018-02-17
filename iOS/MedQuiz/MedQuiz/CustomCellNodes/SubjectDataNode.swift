//
//  SubjectDataNode.swift
//  ExpandableTable
//
//  Created by Harnack, Paul (Student) on 2/16/18.
//  Copyright © 2018 Harnack, Paul (Student). All rights reserved.
//

import Foundation
class SubjectDataNode:CellDataNode{
    
    var subjectName:String
    override class func reuseIdentifier() -> String {
        return "SubjectCell"
    }
    
    init(subjectName:String, children: [CellDataNode], completionEvents: [() -> ()]) {
        self.subjectName = subjectName
        
        super.init(children: children, completionEvents: completionEvents)
    }
}
