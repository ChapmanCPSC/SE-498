//
//  CellType.swift
//  ExpandableTable
//
//  Created by Harnack, Paul (Student) on 2/15/18.
//  Copyright © 2018 Harnack, Paul (Student). All rights reserved.
//

import UIKit


class CellType:UITableViewCell {
    
    var cellDataNode:CellDataNode!
    class func reuseIdentifier()-> String {
        assert(false, "This method must be overriden by the subclass")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()

    }

    func updateViews(){
        assert(false, "This method must be overriden by the subclass")
    }

    func hasChildren() -> Bool{
        return cellDataNode.hasChildren
    }

    func getChildren() -> [CellDataNode] {
        return cellDataNode.children
    }
}
