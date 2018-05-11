//
// Created by Harnack, Paul (Student) on 2/27/18.
// Copyright (c) 2018 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Student: Equatable {
    var userName:String?
    var profilePic:UIImage?
    var friends:[Student]?
//    var classes:[String:Bool]
    var totalPoints:Int?
    var hasChangedUsername:Bool?
    var databaseID:String?
    var friendRequests:[Student]?
    var complete:Bool!
    
    init(key: String, completion: @escaping (Student) -> Void){
        StudentModel.From(key: key, completion: { (aStudentModel) in
            self.complete = true
            
            if let userName = aStudentModel.studentUsername {
                self.userName = userName
                print(self.userName!)
            }
            else{
                self.userName = "userName"
                self.complete = false
                print("ERROR: Student userName not found.")
            }
            
            //self.friends = Student.convertFriends(students: aStudentModel.friends)//get friends from student and also implemement a FriendsModel file
            
            self.friends = []
            aStudentModel.friends.forEach { studentModel in
                self.friends!.append(Student(studentModel: studentModel, addFriends: false))
            }
            print("Friends\(self.friends!)")

            
            if let hasChangedUsername = aStudentModel.hasChangedUsername {
                self.hasChangedUsername = hasChangedUsername
                print(self.hasChangedUsername!)
            }
            else{
                self.hasChangedUsername = true
                self.complete = false
                print("ERROR: Student hasChangedUsername not found.")
            }
            
            self.databaseID = key
            print(self.databaseID!)
            
            if let totalPoints = aStudentModel.score {
                self.totalPoints = totalPoints
                print(self.totalPoints!)
            }
            else{
                self.totalPoints = 0
                self.complete = false
                print("ERROR: Student totalPoints not found.")
            }
            
            self.friendRequests = []
            aStudentModel.friendRequests.forEach { studentModel in
                self.friendRequests!.append(Student(studentModel: studentModel, addFriends: false))
            }
            print("Requests \(self.friendRequests!)")


            aStudentModel.getProfilePic(completion: { (theProfilePic) in
                if let profilePic = theProfilePic {
                    self.profilePic = profilePic
                    print(self.profilePic!)
                }
                else{
                    self.profilePic = nil
                    self.complete = false
                    print("ERROR: Student profilePic not found.")
                }
                completion(self)
            })
        })
    }
    
    init(username: String, completion: @escaping (Student) -> Void){
        StudentModel.Where(child: "username", equals: username) { (studentModelsReturned) in
            self.complete = true
            
            let aStudentModel = studentModelsReturned[0]
            
            if let userName = aStudentModel.studentUsername {
                self.userName = userName
                print(self.userName!)
            }
            else{
                self.userName = "userName"
                self.complete = false
                print("ERROR: Student userName not found.")
            }
            
            //self.friends = Student.convertFriends(students: aStudentModel.friends)//get friends from student and also implemement a FriendsModel file
            
            self.friends = []
            aStudentModel.friends.forEach { studentModel in
                self.friends!.append(Student(studentModel: studentModel, addFriends: false))
            }
            print("Friends\(self.friends!)")

            
            if let hasChangedUsername = aStudentModel.hasChangedUsername {
                self.hasChangedUsername = hasChangedUsername
                print(self.hasChangedUsername!)
            }
            else{
                self.hasChangedUsername = true
                self.complete = false
                print("ERROR: Student hasChangedUsername not found.")
            }
            
            self.databaseID = aStudentModel.key
            print(self.databaseID!)
            
            if let totalPoints = aStudentModel.score {
                self.totalPoints = totalPoints
                print(self.totalPoints!)
            }
            else{
                self.totalPoints = 0
                self.complete = false
                print("ERROR: Student totalPoints not found.")
            }
            
            self.friendRequests = []
            aStudentModel.friendRequests.forEach { studentModel in
                self.friendRequests!.append(Student(studentModel: studentModel, addFriends: false))
            }
            print("Requests \(self.friendRequests!)")

            
            aStudentModel.getProfilePic(completion: { (theProfilePic) in
                if let profilePic = theProfilePic {
                    self.profilePic = profilePic
                    print(self.profilePic!)
                }
                else{
                    self.profilePic = nil
                    self.complete = false
                    print("ERROR: Student profilePic not found.")
                }
                completion(self)
            })
        }
    }
    
    init(userName:String, profilePic:UIImage, friends:[Student], totalPoints:Int, hasChangedUsername:Bool){
        self.userName = userName
        self.profilePic = profilePic
        self.friends = friends
        self.totalPoints = totalPoints
        self.hasChangedUsername = hasChangedUsername
    }

    func addFriendRequest(studentModel: StudentModel,completion:@escaping () -> Void) {
        if self.friendRequests == nil {
            self.friendRequests = []
        }
        for friend in self.friendRequests! {

            if friend.databaseID == studentModel.key {
                completion()
                return
            }
        }
        self.friendRequests!.append(Student(key: studentModel.key) { student in
            completion()
         })
    }

//    init(studentDict:[String:AnyObject], addFriends:Bool=true){
//        self.userName = studentDict["username"] as? String
//        //self.totalPoints = studentModel.totalPoints!
//        self.totalPoints = 10000
//        self.profilePic = UIImage()
//        self.hasChangedUsername = true
//        if(addFriends){
//            //self.friends = Student.convertFriends(students: studentModel.friends!)
//            self.friends = []
//        }
//        else{
//            self.friends = []
//        }
//    }

    init(studentModel:StudentModel, addFriends:Bool){
        self.complete = true
        
        if let userName = studentModel.studentUsername {
            self.userName = userName
            print(self.userName!)
        }
        else{
            self.userName = "userName"
            self.complete = false
            print("ERROR: Student userName not found.")
        }
        
        self.friends = []
        
        if let totalPoints = studentModel.score {
            self.totalPoints = totalPoints
            print(self.totalPoints!)
        }
        else{
            self.totalPoints = 0
            self.complete = false
            print("ERROR: Student totalPoints not found.")
        }

        self.databaseID = studentModel.key
        
        studentModel.getProfilePic(completion: { (theProfilePic) in
            if let profilePic = theProfilePic {
                self.profilePic = profilePic
                print(self.profilePic!)
            }
            else{
                self.profilePic = nil
                self.complete = false
                print("ERROR: Student profilePic not found.")
            }
        })
    }

    func addFriend(student:StudentModel){
        if self.friends == nil {
            self.friends = []
        }
        self.friends!.append(Student(studentModel: student, addFriends: false))
    }

    deinit {
        userName = ""
        profilePic = nil
        friends = []
        print("-------->deallocating Student")
    }

    static func convertFriends(students:[StudentModel]?) -> [Student] {
        var toReturn:[Student] = []
        if let _ = students{
            students!.forEach { studentModel in
                toReturn.append(Student(studentModel: studentModel, addFriends: false))
            }
        }


        return toReturn
    }
    
//    func getProfilePicImage2(profilePicRef: String, completion: @escaping () -> Void) {
//        let imageRef = Storage.storage().reference(withPath: profilePicRef)
//        imageRef.getData(maxSize: 1 * 1024 * 1024, completion: { (d: Foundation.Data?, e: Error?) in
//            if let error = e
//            {
//                print("Whoops: \(error)")
//            }
//            else if let data = d
//            {
//                self.profilePic = UIImage(data: data)!
//            }
//        })
//    }
    
    
    
    func getProfilePicImage(profilePicRef: String, completion: @escaping() -> Void)
    {
        let imageRef = Storage.storage().reference(withPath: profilePicRef)
        imageRef.downloadURL { (u:URL?, e : Error?) in
            guard u != nil else
            {
                completion()
                return
            }
            
            if let error = e
            {
                print("Whoops: \(error)")
            }
            else if let url = u
            {
                let data = try! Foundation.Data(contentsOf: url)
                
                self.profilePic = UIImage(data: data)!
                completion()
            }
        }
    }
    
    static func ==(lhs: Student, rhs: Student) -> Bool {
        if lhs.userName == rhs.userName{
            return true
        }
        else{
            return false
        }
    }
    
}
