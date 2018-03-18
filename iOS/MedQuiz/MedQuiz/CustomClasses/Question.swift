//
//  QuestionModel.swift
//  MedQuiz
//
//  Created by Paul on 11/13/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
class Question {
    var points:Int
    var imageForQuestion:Bool
    var imageForAnswers:Bool
    var correctAnswer:String
    var answers:[Answer]
    var images:[String]// TODO Figure out what type it actually is
    var tags:[Tag]// TODO make TagModel (Probably same as the quiz?)
    var title:String

    init(points:Int, imageForQuestion:Bool, imageForAnswers:Bool, correctAnswer:String, answers:[Answer], images:[String], tags:[Tag], title:String){
        self.points = points
        self.imageForQuestion = imageForQuestion
        self.imageForAnswers = imageForAnswers
        self.correctAnswer = correctAnswer
        self.answers = answers
        self.images = images
        self.tags = tags
        self.title = title
    }

    init(questionModel:QuestionModel){
        self.points = questionModel.questionPoints!
        self.imageForQuestion = questionModel.imageForQuestion!
        self.imageForAnswers = questionModel.imagesForAnswer!
        if(questionModel.imageForQuestion!){
            self.title = ""
        }
        else{
            self.title = questionModel.questionTitle!
        }
        var toSet:[Tag] = []
        questionModel.tags!.forEach({ model in
            toSet.append(Tag(tagModel: model))
        })
        self.tags = toSet
        self.images = []
        self.answers = []
        self.correctAnswer = ""
    }

}
