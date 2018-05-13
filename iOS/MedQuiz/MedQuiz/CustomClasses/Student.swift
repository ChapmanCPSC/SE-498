//
// Created by Harnack, Paul (Student) on 2/27/18.
// Copyright (c) 2018 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit
import Firebase

/*
 Student stores information from Student objects in database.
 */

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
    
    /*
     Create Student using relevant database key for Student object.
     */
    
    init(key: String, addFriends: Bool, completion: @escaping (Student) -> Void){
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
            
//            self.userName = aStudentModel.studentUsername
            
//            self.friends = Student.convertFriends(students: aStudentModel.friends)//get friends from student and also implemement a FriendsModel file
            
            self.friends = []
            if addFriends {
                aStudentModel.friends.forEach { studentModel in
                    _ = Student(key: studentModel.key, addFriends: false, completion: { student in
                        self.friends!.append(student)
                    })
                }
            }


            if let hasChangedUsername = aStudentModel.hasChangedUsername {
                self.hasChangedUsername = hasChangedUsername
                print(self.hasChangedUsername!)
            }
            else{
                self.hasChangedUsername = true
                self.complete = false
                print("ERROR: Student hasChangedUsername not found.")
            }
            
//            self.hasChangedUsername = aStudentModel.hasChangedUsername
            
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
            
//            self.totalPoints = aStudentModel.score
            
            self.friendRequests = []
            aStudentModel.friendRequests.forEach { studentModel in
                self.friendRequests!.append(Student(studentModel: studentModel, addFriends: false))
            }
            print("Requests \(self.friendRequests!)")


            aStudentModel.getProfilePic(completion: { (theProfilePic) in
                if let profilePic = theProfilePic {
                    self.profilePic = theProfilePic
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
    
    /*
     Create Student using Student database object containing the provided username string.
     */
    
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
            
//            self.userName = aStudentModel.studentUsername
            
//            self.friends = Student.convertFriends(students: aStudentModel.friends)//get friends from student and also implemement a FriendsModel file
            
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
            
//            self.hasChangedUsername = aStudentModel.hasChangedUsername
            
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
            
//            self.totalPoints = aStudentModel.score
            
            self.friendRequests = []
            aStudentModel.friendRequests.forEach { studentModel in
                self.friendRequests!.append(Student(studentModel: studentModel, addFriends: false))
            }
            print("Requests \(self.friendRequests!)")

            
            aStudentModel.getProfilePic(completion: { (theProfilePic) in
                if let profilePic = theProfilePic {
                    self.profilePic = theProfilePic
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
    
    /*
     Create Student using set of attribute values.
     */
    
    init(userName:String, profilePic:UIImage, friends:[Student], totalPoints:Int, hasChangedUsername:Bool){
        self.userName = userName
        self.profilePic = profilePic
        self.friends = friends
        self.totalPoints = totalPoints
        self.hasChangedUsername = hasChangedUsername
    }

    /*
     Add a friend request to user from another Student, represented by a StudentModel.
     */
    
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
        self.friendRequests!.append(Student(key: studentModel.key, addFriends: false) { student in
            completion()
         })
    }

    /*
     Create Student from a StudentModel.
     */
    
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
        
//        self.userName = studentModel.studentUsername
        
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
        
//        self.totalPoints = studentModel.score

        self.databaseID = studentModel.key
        
        studentModel.getProfilePic(completion: { (theProfilePic) in
            if let profilePic = theProfilePic {
                self.profilePic = theProfilePic
                print(self.profilePic!)
            }
            else{
                self.profilePic = nil
                self.complete = false
                print("ERROR: Student profilePic not found.")
            }
        })
    }

    /*
     Add a friend, represented by a StudentModel, to the user.
     */
    
    func addFriend(student:StudentModel){
        if self.friends == nil {
            self.friends = []
        }
        self.friends!.append(Student(studentModel: student, addFriends: false))
    }

    /*
     Deinitialize Student object.
     */
    
    deinit {
        userName = ""
        profilePic = nil
        friends = []
        print("-------->deallocating Student")
    }

    /*
     Convert collection of StudentModels into a collection of Students. Returns Student collection.
     */
    
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
    
    
    /*
     Download a Student's profile picture by referencing the database using the profilePicRef.
     */
    
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
    
    /*
     Comparision operator.
     */
    
    static func ==(lhs: Student, rhs: Student) -> Bool {
        if lhs.userName == rhs.userName{
            return true
        }
        else{
            return false
        }
    }
    
}
