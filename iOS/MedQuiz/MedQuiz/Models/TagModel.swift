//
//  TagModel.swift
//  MedQuiz
//
//  Created by Omar Sherief on 3/13/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation

class TagModel: FIRModel, FIRQueryable
{
    
    static var COLLECTION_NAME = "tag"
    
    static var NAME = "name"
    static var COLOR = "color"
    static var QUIZZES = "quizzes"
    static var QUESTIONS = "questions"
    
    var tagName: String? { return self.get(TagModel.NAME) }
    var tagColor: String? {return self.get(TagModel.COLOR) }
    var quizzesForTag : [QuizModel] { return self.get(TagModel.QUIZZES) }
    var questionsForTag: [QuestionModel] {return self.get(TagModel.QUESTIONS) }
}
