//
//  QuizModel.swift
//  MedQuiz
//
//  Created by Paul on 11/13/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import Firebase
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

    init(quizDict:[String:AnyObject]){
        self.title = quizDict["title"]! as! String
        self.available = quizDict["available"] as! Bool
        self.visible = quizDict["visible"] as! Bool
//        var questionsToSet:[Question] = []
//        quizModel.quizQuestions.forEach { model in
//            model.getData(withMaxSize: 1 * 1024 * 1024, completion: { (d: Foundation.Data?, e: Error?) in
//                if let error = e
//                {
//                    print("Quiz Question Whoops: \(error)")
//                }
//                else
//                {
//                    questionsToSet.append(Question(questionModel: model))
//                }
//            })
//        }
//        self.questions = questionsToSet
        
        self.questions = []
        
//        var tagsToSet:[Tag] = []
//        quizModel.tags.forEach { model in
//            model.getData(withMaxSize: 1 * 1024 * 1024, completion: { (d: Foundation.Data?, e: Error?) in
//                if let error = e
//                {
//                    print("Quiz Tag Whoops: \(error)")
//                }
//                else
//                {
//                    tagsToSet.append((Tag(tagModel: model)))
//                }
//            })
//        }
//        self.tags = tagsToSet
        
        self.tags = []

        //self.dateCreated = quizModel.dateCreated!
        
        self.dateCreated = quizDict["datecreated"] as! String
    }
    
    func setQuestions(quizDict:[String:AnyObject]){
        var quizQuestionKeys:[String] = []
        for quizQuestion in quizDict["questions"] as! [String:AnyObject]{
            quizQuestionKeys.append(quizQuestion.key)
        }
        
        let questionRef = Database.database().reference(withPath: "question")
        questionRef.observeSingleEvent(of: .value, with: { snapshot in
            if let children = snapshot.children.allObjects as? [DataSnapshot] {
                for child in children {
                    if quizQuestionKeys.contains(child.key) {
                        self.questions.append(self.createFullQuestion(questionDict: child.value as! [String:AnyObject]))
                    }
                }
            }
        })
    }
    
    func setTags(quizDict:[String:AnyObject]){
        var quizTagKeys:[String] = []
        for quizTag in quizDict["tags"] as! [String:AnyObject]{
            quizTagKeys.append(quizTag.key)
        }
        
        let tagRef = Database.database().reference(withPath: "tag")
        tagRef.observeSingleEvent(of: .value, with: { snapshot in
            if let children = snapshot.children.allObjects as? [DataSnapshot] {
                for child in children {
                    if quizTagKeys.contains(child.key) {
                        self.tags.append(Tag(tagDict: child.value as! [String:AnyObject]))
                    }
                }
            }
        })
    }
    
    func createFullQuestion(questionDict:[String:AnyObject]) -> Question{
        let question = Question(questionDict: questionDict)
        question.setTags(questionDict: questionDict)
        return question
    }
    
}
