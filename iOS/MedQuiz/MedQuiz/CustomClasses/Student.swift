//
// Created by Harnack, Paul (Student) on 2/27/18.
// Copyright (c) 2018 Omar Sherief. All rights reserved.
//

import Foundation


class Student {
    var userName:String
    var profilePic:String
    var friends:[Student]
//    var classes:[String:Bool]
    var totalPoints:Int
    var hasChangedUsername:Bool

    init(userName:String, profilePic:String, friends:[Student], totalPoints:Int, hasChangedUsername:Bool){
        self.userName = userName
        self.profilePic = profilePic
        self.friends = friends
        self.totalPoints = totalPoints
        self.hasChangedUsername = hasChangedUsername
    }

    init(studentModel:StudentModel, addFriends:Bool=true){
        /*self.userName = (studentModel.snapshot.value as! [String:AnyObject])["username"] as! String
        self.profilePic = (studentModel.snapshot.value as! [String:AnyObject])["profilePic"] as! String
        self.friends = (studentModel.snapshot.value as! [String:AnyObject])["friends"] as! [Student]
        self.classes = (studentModel.snapshot.value as! [String:AnyObject])["classes"] as! [String:Bool]
        self.totalPoints = Int((studentModel.snapshot.value as! [String:AnyObject])["totalPoints"] as! String)!*/
        self.userName = studentModel.studentUsername!
        self.totalPoints = studentModel.totalPoints!
        self.profilePic = studentModel.profilePic!
        self.hasChangedUsername = studentModel.hasChangedUsername!
        if(addFriends){
            self.friends = Student.convertFriends(students: studentModel.friends!)
        }
        else{
            self.friends = []
        }
    }

    static func convertFriends(students:[StudentModel]) -> [Student] {
        var toReturn:[Student] = []
        students.forEach { studentModel in
            toReturn.append(Student(studentModel: studentModel, addFriends: false))
         }


        return toReturn
    }
}
