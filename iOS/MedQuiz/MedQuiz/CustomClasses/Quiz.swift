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
    var complete:Bool!

    init(dateCreated:String, available:Bool, visible:Bool, name:String, questions:[Question], tags:[Tag]){
        self.dateCreated = dateCreated
        self.available = available
        self.visible = visible
        self.name = name
        self.questions = questions
        self.tags = tags
        self.complete = true
    }

    init(key: String, completion: @escaping (Quiz) -> Void){
        QuizModel.From(key: key, completion: { (aQuizModel) in
            print("key")
            print(aQuizModel.key)
            
            self.complete = true
            
            if let dateCreated = aQuizModel.dateCreated {
                self.dateCreated = dateCreated
            }
            else{
                self.dateCreated = "2018-01-01"
                self.complete = false
                print("ERROR: Quiz dateCreated not found.")
            }
            
//            self.dateCreated = aQuizModel.dateCreated
            
            if let available = aQuizModel.available {
                self.available = available
            }
            else{
                self.available = false
                self.complete = false
                print("ERROR: Quiz available not found.")
            }
            
//            self.available = aQuizModel.available
            
            if let visible = aQuizModel.visiblity {
                self.visible = visible
            }
            else{
                self.visible = false
                self.complete = false
                print("ERROR: Quiz visible not found.")
            }
            
//            self.visible = aQuizModel.visiblity
            
            if let name = aQuizModel.name {
                self.name = name
            }
            else{
                self.name = "Quiz Title"
                self.complete = false
                print("ERROR: Quiz title not found.")
            }
            
//            self.name = aQuizModel.name
            
            var questions:[Question] = []
            var questionKeys:[String] = []
            
            if !aQuizModel.quizQuestions.isEmpty {
                for questionModel in aQuizModel.quizQuestions{
                    questionKeys.append(questionModel.key)
                }
                
                for i in 0...questionKeys.count - 1 {
                    _ = Question(key:questionKeys[i], completion: { question in
                        questions.append(question)
                        if !question.complete {
                            self.complete = false
                        }

                        if i == questionKeys.count - 1 {
                            self.questions = questions
                            
                            var tags:[Tag] = []
                            var tagKeys:[String] = []
                            
                            if !aQuizModel.tags.isEmpty {
                                for tagModel in aQuizModel.tags{
                                    tagKeys.append(tagModel.key)
                                }
                                
                                for j in 0...tagKeys.count - 1 {
                                    _ = Tag(key:tagKeys[j], completion: { tag in
                                        tags.append(tag)
                                        if !tag.complete {
                                            self.complete = false
                                        }
                                        if j == tagKeys.count - 1 {
                                            self.tags = tags
                                            completion(self)
                                        }
                                    })
                                }
                            }
                            else{
                                self.complete = false
                                print("ERROR: Quiz tags not found.")
                                completion(self)
                            }
                        }
                    })
                }
            }
            else{
                self.complete = false
                print("ERROR: Quiz questions not found.")
                completion(self)
            }
        })
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
    
}
