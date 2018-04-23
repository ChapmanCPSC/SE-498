//
//  FriendModel.swift
//  MedQuiz
//
//  Created by Edgar Delgado on 4/22/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation

class FriendModel: FIRModel {
    
    static var FIELD_FRIENDID = "friend"
    
    var friendID : Bool? { return self.get(FriendModel.FIELD_FRIENDID) }
}
