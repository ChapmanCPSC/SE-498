//
//  QuizModel.swift
//  MedQuiz
//
//  Created by Omar Sherief on 3/13/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation
class QuizModel: FIRModel, FIRQueryable
    
{
    static var COLLECTION_NAME: String = "quiz"
    
    static var TITLE = "title"
    static var AVAILABILITY = "available"
    static var DATE_CREATED = "datecreated"
    static var VISIBILITY = "visible"
    static var QUESTIONS = "questions"
    static var TAGS = "tags"
    
    var title: String? { return self.get(QuizModel.TITLE) }
    var available: Bool? { return self.get(QuizModel.AVAILABILITY) }
    var dateCreated: String? { return self.get(QuizModel.DATE_CREATED) }
    var visiblity: Bool? { return self.get(QuizModel.VISIBILITY) }
    
    var quizQuestions: [QuestionModel] { return self.get(QuizModel.QUESTIONS) }
    var tags: [TagModel] { return self.get(QuizModel.TAGS) }
    
    
}
