//
// Created by Harnack, Paul (Student) on 2/27/18.
// Copyright (c) 2018 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit
import Firebase



class Student {
    var userName:String?
    var profilePic:UIImage?
    var friends:[Student]?
//    var classes:[String:Bool]
    var totalPoints:Int?
    var hasChangedUsername:Bool?

    
    init(username: String, completion: @escaping (Student) -> Void){
        StudentModel.Where(child: "username", equals: username) { (studentModelsReturned) in
            let theStudent = studentModelsReturned[0]
            print(theStudent.studentUsername!)
            
            self.userName = theStudent.studentUsername!
            self.totalPoints = 10000
            self.friends = []
            self.hasChangedUsername = false
            
            theStudent.getProfilePic(completion: { (theProfilePic) in
                self.profilePic = theProfilePic!
                print(theProfilePic!.description)
                completion(self)
            })
        }
    }
        
    init(key: String, completion: @escaping (Student) -> Void){
        StudentModel.From(key: key, completion: { (aStudentModel) in
            self.userName = aStudentModel.studentUsername!
            print(aStudentModel.studentUsername!)
            
            self.totalPoints = 10000
            self.friends = []
            self.hasChangedUsername = false
            
            print(aStudentModel.studentUsername!)
            aStudentModel.getProfilePic(completion: { (theProfilePic) in
                self.profilePic = theProfilePic!
                print(theProfilePic!.description)
                completion(self)
            })
        })
    }
    
    init(userName:String, profilePic:UIImage, friends:[Student], totalPoints:Int, hasChangedUsername:Bool){
        self.userName = userName
        self.profilePic = profilePic
        self.friends = friends
        self.totalPoints = totalPoints
        self.hasChangedUsername = hasChangedUsername
    }

    init(studentDict:[String:AnyObject], addFriends:Bool=true){
        /*self.userName = (studentModel.snapshot.value as! [String:AnyObject])["username"] as! String
        self.profilePic = (studentModel.snapshot.value as! [String:AnyObject])["profilePic"] as! String
        self.friends = (studentModel.snapshot.value as! [String:AnyObject])["friends"] as! [Student]
        self.classes = (studentModel.snapshot.value as! [String:AnyObject])["classes"] as! [String:Bool]
        self.totalPoints = Int((studentModel.snapshot.value as! [String:AnyObject])["totalPoints"] as! String)!*/
        self.userName = studentDict["username"] as! String
        //self.userName = "Lylenator2000"
        //self.totalPoints = studentModel.totalPoints!
        self.totalPoints = 10000
        //self.profilePic = studentModel.profilePic!
        self.profilePic = UIImage()
        //self.hasChangedUsername = studentModel.hasChangedUsername!
        self.hasChangedUsername = true
        if(addFriends){
            //self.friends = Student.convertFriends(students: studentModel.friends!)
            self.friends = []
        }
        else{
            self.friends = []
        }
    }

//    static func convertFriends(students:[StudentModel]) -> [Student] {
//        var toReturn:[Student] = []
//        students.forEach { studentModel in
//            toReturn.append(Student(studentModel: studentModel, addFriends: false))
//         }
//
//
//        return toReturn
//    }
    
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
            guard u! != nil else
            {
                completion()
                return
            }
            
            if let error = e
            {
                print("Woops: \(error)")
            }
            else if let url = u
            {
                let data = try! Foundation.Data(contentsOf: url)
                
                self.profilePic = UIImage(data: data)!
                completion()
            }
        }
    }
    
}
