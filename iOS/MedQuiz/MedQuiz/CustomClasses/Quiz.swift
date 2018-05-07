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
    var dateCreated:String?
    var available:Bool?
    var visible:Bool?
    var name:String?
    var questions:[Question]?
    var tags:[Tag]?

    init(dateCreated:String, available:Bool, visible:Bool, name:String, questions:[Question], tags:[Tag]){
        self.dateCreated = dateCreated
        self.available = available
        self.visible = visible
        self.name = name
        self.questions = questions
        self.tags = tags
    }

    init(key: String, completion: @escaping (Quiz) -> Void){
        QuizModel.From(key: key, completion: { (aQuizModel) in
            self.dateCreated = aQuizModel.dateCreated!
            self.available = aQuizModel.available!
            self.visible = aQuizModel.visiblity!
            
            if let name = aQuizModel.name {
                self.name = name
            }
            else{
                self.name = (Database.database().reference(withPath: "quiz-name/\(key)").value(forKey: "name") as! String)
            }
            
            self.questions = []
            var questionKeys:[String] = []
            for questionModel in aQuizModel.quizQuestions{
                questionKeys.append(questionModel.key)
            }
            
            for i in 0...questionKeys.count - 1 {
                _ = Question(key:questionKeys[i], completion: { question in
                    self.questions?.append(question)
                    if i == questionKeys.count - 1 {
                        self.tags = []
                        var tagKeys:[String] = []
                        for tagModel in aQuizModel.tags{
                            tagKeys.append(tagModel.key)
                        }
                        
                        for j in 0...tagKeys.count - 1 {
                            _ = Tag(key:tagKeys[j], completion: { tag in
                                self.tags?.append(tag)
                                if j == tagKeys.count - 1 {
                                    completion(self)
                                }
                            })
                        }
                    }
                })
            }
        })
    }
    
    init(quizDict:[String:AnyObject]){
        self.name = quizDict["name"] as? String
        self.available = (quizDict["available"] as? Bool)
        self.visible = quizDict["visible"] as? Bool
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
        
        self.dateCreated = quizDict["datecreated"] as? String
    }
    
    deinit {
        dateCreated = ""
        available = nil
        visible = nil
        name = ""
        questions = []
        tags = []
        print("------->Deallocating Quiz")
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
                        self.questions?.append(self.createFullQuestion(questionDict: child.value as! [String:AnyObject]))
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
                        self.tags?.append(Tag(tagDict: child.value as! [String:AnyObject]))
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
