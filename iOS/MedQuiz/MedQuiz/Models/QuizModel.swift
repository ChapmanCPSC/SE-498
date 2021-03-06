//
//  QuizModel.swift
//  MedQuiz
//
//  Created by Omar Sherief on 3/13/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation

/*
 Firebase wrapper for Quiz. Abstracts the process of accessing attributes of Quiz objects stored in the database.
 */

class QuizModel: FIRModel, FIRQueryable
    
{
    static var COLLECTION_NAME: String = "quiz"
    
    static var NAME = "name"
    static var AVAILABILITY = "available"
    static var DATE_CREATED = "datecreated"
    static var VISIBILITY = "visible"
    static var QUESTIONS = "questions"
    static var TAGS = "tags"
    
    var name: String? { return self.get(QuizModel.NAME) }
    var available: Bool? { return self.get(QuizModel.AVAILABILITY) }
    var dateCreated: String? { return self.get(QuizModel.DATE_CREATED) }
    var visiblity: Bool? { return self.get(QuizModel.VISIBILITY) }
    
    var quizQuestions: [QuestionModel] { return self.get(QuizModel.QUESTIONS) }
    var tags: [TagModel] { return self.get(QuizModel.TAGS) }
    
    
}
