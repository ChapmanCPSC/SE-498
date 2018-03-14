//
// Created by Harnack, Paul (Student) on 2/27/18.
// Copyright (c) 2018 Omar Sherief. All rights reserved.
//

import Foundation


class Student {
    var userName:String
    var profilePic:String
    var friends:[Student]
    var classes:[String:Bool]
    var totalPoints:Int

    init(userName:String, profilePic:String, friends:[Student], classes:[String:Bool], totalPoints:Int){
        self.userName = userName
        self.profilePic = profilePic
        self.friends = friends
        self.classes = classes
        self.totalPoints = totalPoints
    }
}
