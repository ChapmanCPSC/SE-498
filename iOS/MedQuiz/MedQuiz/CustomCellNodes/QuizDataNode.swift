//
//  QuizDataNode.swift
//  ExpandableTable
//
//  Created by Harnack, Paul (Student) on 2/16/18.
//  Copyright © 2018 Harnack, Paul (Student). All rights reserved.
//

import Foundation

class QuizDataNode:CellDataNode {
    var quizName:String
    var quiz:Quiz

    override class func reuseIdentifier() -> String {
        return "QuizCell"
    }

    /*init(quizName:String, children: [CellDataNode], completionEvents: [() -> ()]) {
        self.quizName = quizName

        super.init(children: children, completionEvents: completionEvents)
    }*/

    init(quiz:Quiz, children:[CellDataNode], completionEvents: [() -> ()]) {
        self.quiz = quiz
        self.quizName = quiz.name!

        super.init(children: children, completionEvents: completionEvents)
    }
    
    deinit {
        quizName = ""
        print("------->Deallocating QuizDataNode")
    }
}
