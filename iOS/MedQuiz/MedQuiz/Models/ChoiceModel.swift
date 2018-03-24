//
//  QuestionModel.swift
//  MedQuiz
//
//  Created by Omar Sherief on 3/13/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation
class ChoiceModel: FIRModel, FIRQueryable
    
{
    static var COLLECTION_NAME: String = "choices"
    
    static var ANSWERS = "answers"
    static var CORRECTANSWERS = "correctanswers"
    
    var answers: [String:String]? { return self.get(ChoiceModel.ANSWERS)}
    var correctAnswers: [String:String]? { return self.get(ChoiceModel.CORRECTANSWERS)}
}
