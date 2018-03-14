//
//  UserModel.swift
//  MedQuiz
//
//  Created by Omar Sherief on 3/13/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation


class StudentModel: FIRModel, FIRQueryable
    
    
{
    static var COLLECTION_NAME: String = "student"
    
    static var USERNAME = "username"
    
    var studentUsername: String? { return self.get(StudentModel.USERNAME) }
    
}
