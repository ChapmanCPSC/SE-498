//
//  QuizModel.swift
//  MedQuiz
//
//  Created by Paul on 11/13/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
class Quiz {
    var dateCreated:Date
    var available:Bool
    var visible:Bool
    var classBelongsTo:String
    var points: Bool
    var title:String
    var questions:[Question]
    var tags:[String] // TODO create a TagModel

    init(dateCreated:Date, available:Bool, visible:Bool, classBelongsTo:String, points: Bool, title:String, questions:[Question], tags:[String]){
        self.dateCreated = dateCreated
        self.available = available
        self.visible = visible
        self.classBelongsTo = classBelongsTo
        self.points = points
        self.title = title
        self.questions = questions
        self.tags = tags
    }
}
