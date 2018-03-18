//
//  QuizModel.swift
//  MedQuiz
//
//  Created by Paul on 11/13/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
class Quiz {
    var dateCreated:String
    var available:Bool
    var visible:Bool
    var title:String
    var questions:[Question]
    var tags:[Tag]

    init(dateCreated:String, available:Bool, visible:Bool, title:String, questions:[Question], tags:[Tag]){
        self.dateCreated = dateCreated
        self.available = available
        self.visible = visible
        self.title = title
        self.questions = questions
        self.tags = tags
    }

    init(quizModel:QuizModel){
        self.title = quizModel.title!
        self.available = quizModel.available!
        self.visible = quizModel.visiblity!
        var questionsToSet:[Question] = []
        quizModel.quizQuestions.forEach { model in
            questionsToSet.append(Question(questionModel: model))
         }
        self.questions = questionsToSet
        var tagsToSet:[Tag] = []
        quizModel.tags.forEach { model in
            tagsToSet.append(Tag(tagModel: model))
        }
        self.tags = tagsToSet
        self.dateCreated = quizModel.dateCreated!
    }
}
