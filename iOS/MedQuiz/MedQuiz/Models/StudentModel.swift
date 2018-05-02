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
    static var PROFILE_PIC = "profilepic"
    static var SCORE = "score"
    static var HAS_CHANGED_USERNAME = "haschangedusername"
    static var FRIENDS = "friends"
    static var HEADTOHEAD_GAME_REQUEST = "headtoheadgamerequest"
    static var ONLINE = "online"

    var studentUsername: String? { return self.get(StudentModel.USERNAME) }
    var profilePic: String? { return self.get(StudentModel.PROFILE_PIC) }
    var score: Int? { return self.get(StudentModel.SCORE) }
    var hasChangedUsername:Bool? { return self.get(StudentModel.HAS_CHANGED_USERNAME) }
    var friends:[StudentModel]? { return self.get(StudentModel.FRIENDS) }
    var headToHeadGameRequest:String? { return self.get(StudentModel.HEADTOHEAD_GAME_REQUEST) }
    var online:Bool? { return self.get(StudentModel.ONLINE) }

    func getProfilePic(completion: @escaping(UIImage?) -> Void)
    {
        self.getDownloadURL(completion: { (u: URL?, e: Error?) in
            
            guard self.profilePic != nil else
            {
                completion(nil)
                return
            }
            
            if let error = e
            {
                print("Woops: \(error)")
            }
            else if let url = u
            {
                let data = try! Foundation.Data(contentsOf: url)
                
                let pic = UIImage(data: data)
                completion(pic!)
            }
        })
    }
    
}
