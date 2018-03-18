//
// Created by Harnack, Paul (Student) on 3/17/18.
// Copyright (c) 2018 Omar Sherief. All rights reserved.
//

import Foundation

class Tag {
    var color:String
    var name:String

    init(color:String, name:String){
        self.color = color
        self.name = name
    }

    init(tagModel:TagModel){
        self.color = "blue"
        self.name = tagModel.tagName!
    }
}
