//
// Created by Harnack, Paul (Student) on 3/17/18.
// Copyright (c) 2018 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

class Tag {
    var color:String?
    var name:String?

    init(color:String, name:String){
        self.color = color
        self.name = name
    }

    init(key: String, completion: @escaping (Tag) -> Void){
        TagModel.From(key: key, completion: { (aTagModel) in
            self.color = aTagModel.tagColor!
            self.name = aTagModel.tagName!
            completion(self)
        })
    }
    
    init(tagDict:[String:AnyObject]){
        //self.color = "blue"
        self.color = tagDict["color"] as? String
        //self.name = tagModel.tagName!
        self.name = tagDict["name"] as? String
    }
    
    deinit {
        color = ""
        name = ""
    }
}
