//
//  AnswerModel.swift
//  MedQuiz
//
//  Created by Harnack, Paul (Student) on 2/25/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation

class AnswerModel {
    var answerText:String
    var points:Int
    var isAnswer:Bool
    var imageLink:String
    
    var hasImage:Bool {
        get{
            return imageLink == ""
        }
    }
    
    init(answerText:String, points:Int, isAnswer:Bool, imageLink:String){
        self.answerText = answerText
        self.points = points
        self.isAnswer = isAnswer
        self.imageLink = imageLink
    }
    
    
}
