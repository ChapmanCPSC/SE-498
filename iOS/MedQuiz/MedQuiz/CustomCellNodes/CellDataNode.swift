//
//  CellDataNode.swift
//  ExpandableTable
//
//  Created by Harnack, Paul (Student) on 2/15/18.
//  Copyright © 2018 Harnack, Paul (Student). All rights reserved.
//

import Foundation

class CellDataNode {
    var children:[CellDataNode] = []
    var hasChildren:Bool {
        get {
            return children.count != 0
        }
    }
    class func reuseIdentifier()->String {
        assert(false, "This method must be overriden by the subclass")
    }

    var completionEvents:[()->()]
    var isExpanded:Bool = false
    
    
    init(children:[CellDataNode], completionEvents:[()->()]) {
        self.children = children
        self.completionEvents = completionEvents
    }

    func getChildCount() -> Int {
        var count = 0
        if(!self.isExpanded){
            return count
        }
        children.forEach { child in
            if(child.hasChildren){
                count += child.getChildCount()
            }
            count += 1
         }


        return count
    }
    
    
}
