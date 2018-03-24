//
//  QuestionModel.swift
//  MedQuiz
//
//  Created by Omar Sherief on 3/13/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation
class QuestionModel: FIRModel, FIRQueryable
    
{
    static var COLLECTION_NAME: String = "question"
    
    static var NAME = "name"
    static var POINTS = "points"
    static var IMAGE_FOR_ANSWERS = "imageforanswers"
    static var IMAGE_FOR_QUESTIONS = "imageforquestion"
    static var TAGS = "tags"
   
    
    
    var questionTitle: String? { return self.get(QuestionModel.NAME) }
    var questionPoints: String? { return self.get(QuestionModel.POINTS) }
    var imagesForAnswers: Bool? { return self.get(QuestionModel.IMAGE_FOR_ANSWERS) }
    var imageForQuestion: Bool? { return self.get(QuestionModel.IMAGE_FOR_QUESTIONS) }
    var tags: [TagModel] {return self.get(QuestionModel.TAGS)}
}