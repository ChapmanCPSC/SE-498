//
//  HeadToHeadGameModel.swift
//  MedQuiz
//
//  Created by Chad Johnson on 4/6/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation

class HeadToHeadGameModel: FIRModel, FIRQueryable
{
    static var COLLECTION_NAME: String = "head-to-head-game"
    
    static var QUIZ = "quiz"
    static var INVITER = "inviter"
    static var INVITEE = "invitee"
    static var ACCEPTED = "accepted"
    static var DECIDED = "decided"
    
    var quizKey: String? { return self.get(GameModel.QUIZ) }
    var inviter: String? { return self.get(HeadToHeadGameModel.INVITER) }
    var invitee: String? { return self.get(HeadToHeadGameModel.INVITEE) }
    var accepted: Bool? { return self.get(HeadToHeadGameModel.ACCEPTED) }
    var decided: Bool? { return self.get(HeadToHeadGameModel.DECIDED) }
}
