//
//  UserModel.swift
//  MedQuiz
//
//  Created by Omar Sherief on 3/13/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

class StudentModel: FIRModel, FIRQueryable,FIRStorageDownloadable
    
    
{
    static var COLLECTION_NAME: String = "student"
    
    static var USERNAME = "username"
    static var PROFILEPIC = "profilepic"
    
    
    
    var studentUsername: String? { return self.get(StudentModel.USERNAME) }
    
    var profilePic: String? { return self.get(StudentModel.PROFILEPIC) }
    
    func getProfilePic(completion: @escaping (UIImage?) -> Void){
        var theProfileImageToReturn = UIImage()
        guard self.profilePic != nil else
        {
            completion(nil)
            return
        }
        
            self.getData(withMaxSize: 1 * 1024 * 1024, completion: { (d: Foundation.Data?, e: Error?) in
                
                if let error = e
                {
                    print("Woops: \(error)")
                }
                else if let data = d
                {
                    theProfileImageToReturn = UIImage(data: data)!
                }
            })
            completion(theProfileImageToReturn)
        }
    
}
