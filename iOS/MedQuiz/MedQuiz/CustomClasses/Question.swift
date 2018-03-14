//
//  QuestionModel.swift
//  MedQuiz
//
//  Created by Paul on 11/13/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
class Question {
    var dateCreated:Date
    var points:Int
    var imageForQuestion:Bool
    var imageForAnswers:Bool
    var correctAnswer:String
    var answers:[Answer]
    var images:[String]// TODO Figure out what type it actually is
    var tags:[String]// TODO make TagModel (Probably same as the quiz?)

    init(dateCreated:Date, points:Int, imageForQuestion:Bool, imageForAnswers:Bool, correctAnswer:String, answers:[Answer], images:[String], tags:[String]){
        self.dateCreated = dateCreated
        self.points = points
        self.imageForQuestion = imageForQuestion
        self.imageForAnswers = imageForAnswers
        self.correctAnswer = correctAnswer
        self.answers = answers
        self.images = images
        self.tags = tags
    }

}
