//
//  QuestionModel.swift
//  MedQuiz
//
//  Created by Paul on 11/13/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import Firebase

/*
 Question stores information from Question objects in database.
 */

class Question {
    var points:Int?
    var imageForQuestion:Bool?
    var imagesForAnswers:Bool?
    var correctAnswer:String?
    var answers:[Answer]?
    var image:UIImage?
    var tags:[Tag]?
    var name:String?
    var complete:Bool!
    
    var answerTexts:[String] = []
    var correctAnswers:[Bool] = []

    /*
     Create Question from set of attribute values.
     */
    
    init(points:Int, imageForQuestion:Bool, imagesForAnswers:Bool, correctAnswer:String, answers:[Answer], image:UIImage, tags:[Tag], name:String){
        self.points = points
        self.imageForQuestion = imageForQuestion
        self.imagesForAnswers = imagesForAnswers
        self.correctAnswer = correctAnswer
        self.answers = answers
        self.image = image
        self.tags = tags
        self.name = name
        self.complete = true
    }
    
    /*
     Create Question using relevent database key for Question object.
     */
    
    init(key: String, completion: @escaping (Question) -> Void){
        QuestionModel.From(key: key, completion: { (aQuestionModel) in
            self.complete = true

            if let pointsStr = aQuestionModel.questionPoints {
                if let points:Int = Int(pointsStr) {
                    self.points = points
                }
                else {
                    self.points = 10
                    print("Failed to get points")
                }
            }
            else {
                self.points = 10
                print("Failed to get points")
            }


            if let name = aQuestionModel.questionName {
                self.name = name
            }
            else if let name = (Database.database().reference(withPath: "question-name/\(key)").value(forKey: "name") as? String) {
                self.name = name
            }
            else{
                self.name = "Question"
                self.complete = false
                print("ERROR: Question name not found.")
            }
            
//            self.name = aQuestionModel.questionName

            if let imagesForAnswers = aQuestionModel.imagesForAnswers {
                self.imagesForAnswers = imagesForAnswers
            }
            else{
                self.imagesForAnswers = false
                self.complete = false
                print("Question imagesForAnswers not found.")
            }
            
//            self.imagesForAnswers = aQuestionModel.imagesForAnswers
            
            if let imageForQuestion = aQuestionModel.imageForQuestion {
                self.imageForQuestion = imageForQuestion
            }
            else{
                self.imageForQuestion = false
                self.complete = false
                print("Question imageForQuestion not found.")
            }
            
//            self.imageForQuestion = aQuestionModel.imageForQuestion
            
            if self.imageForQuestion!{
                let imageRef = Storage.storage().reference(withPath: aQuestionModel.questionImagePath!)
                imageRef.downloadURL { (u:URL?, e : Error?) in
                    if let error = e
                    {
                        self.complete = false
                        print("Quiestion image Whoops: \(error)")
                    }
                    else if let url = u
                    {
                        let data = try! Foundation.Data(contentsOf: url)
                        self.image = UIImage(data: data)!
                    }
                }
            }
            else{
                self.image = UIImage()
            }
            
            var tags:[Tag] = []
            var tagKeys:[String] = []
            
            if !aQuestionModel.tags.isEmpty {
                for tagModel in aQuestionModel.tags {
                    tagKeys.append(tagModel.key)
                }
                
                for i:Int in 0...tagKeys.count - 1 {
                    _ = Tag(key:tagKeys[i], completion: { tag in
                        tags.append(tag)
                        
                        if !tag.complete {
                            self.complete = false
                            print("Question: tag not complete.")
                        }
                        
                        if i == tagKeys.count - 1 {
                            self.tags = tags
                            
                            var answers:[Answer] = []
                            self.getAnswers(questionKey: aQuestionModel.key, completion: {
                                self.getCorrectAnswers(questionKey: aQuestionModel.key, completion: {
                                    print("answerTexts length: \(self.answerTexts.count)")
                                    if self.answerTexts.count >= 2 {
                                        for i in 0...self.answerTexts.count - 1 {
                                            print("index is ", i)
                                            if self.imagesForAnswers!{
                                                _ = Answer(answerText: "", isAnswer: self.correctAnswers[i], hasImage: true, imagePath: self.answerTexts[i]) { theAnswer in
                                                    answers.append(theAnswer)
                                                    
                                                    if i == self.answerTexts.count - 1 {
                                                        self.answers = answers
                                                        print("Question Done")
                                                        completion(self)
                                                    }
                                                }
                                            }
                                            else{
                                                _ = Answer(answerText: self.answerTexts[i], isAnswer: self.correctAnswers[i], hasImage: false, imagePath: "") { theAnswer in
                                                    answers.append(theAnswer)
                                                    
                                                    if i == self.answerTexts.count - 1 {
                                                        self.answers = answers
                                                        print("Question Done")
                                                        completion(self)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        print("ERROR: Fewer than 2 question answers found.")
                                        self.complete = false
                                        self.answers = []
                                    }
                                })
                            })
                        }
                    })
                }
            }
            else{
                self.complete = false
                print("ERROR: Question tags not found.")
            }
        })
    }
    
    /*
     Retrieve Question answers from database; stored separately from Questions.
     */

    func getAnswers(questionKey:String, completion: @escaping () -> Void){
        
        print("questionKey: \(questionKey)")
        
        let answersRef = Database.database().reference(withPath: "choices/\(questionKey)/answers")
        
        answersRef.observeSingleEvent(of: .value, with: { snapshot in
            let children = snapshot.children.allObjects as? [DataSnapshot]
            for child in children! {
                if (child.value as? String) != nil {
                    print("answers child: \(child.value as! String)")
                    self.answerTexts.append(child.value as! String)
                }
                else{
                    self.answerTexts.append("Answer Text")
                    self.complete = false
                    print("ERROR: Answer text not found.")
                }
            }
            completion()
        })
    }
    
    /*
     Retrieve Question correct answers from database; stored separately from Questions.
     */
    
    func getCorrectAnswers(questionKey:String, completion: @escaping () -> Void){
        Database.database().reference().child("choices").child(questionKey).child("correctanswers").observeSingleEvent(of: DataEventType.value) { (correctAnswerSnap) in
            for child in correctAnswerSnap.children{
                if (child as! DataSnapshot).value! as? Bool != nil {
                    self.correctAnswers.append((child as! DataSnapshot).value! as! Bool)
                    print("new correct answer")
                    print(self.correctAnswers)
                }
                else{
                    self.correctAnswers.append(false)
                    self.complete = false
                    print("ERROR: Correct answer bool not found.")
                }

            }
            completion()
        }
    }
    
    /*
     Deinitialize Question object.
     */
    
    deinit {
        print("------->deallocating Question")
    }
}
