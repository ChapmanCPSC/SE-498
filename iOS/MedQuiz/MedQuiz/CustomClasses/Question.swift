//
//  QuestionModel.swift
//  MedQuiz
//
//  Created by Paul on 11/13/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import Firebase

class Question {
    var points:Int?
    var imageForQuestion:Bool?
    var imagesForAnswers:Bool?
    var correctAnswer:String?
    var answers:[Answer]?
    var image:UIImage?
    var tags:[Tag]?
    var title:String?

    init(points:Int, imageForQuestion:Bool, imagesForAnswers:Bool, correctAnswer:String, answers:[Answer], image:UIImage, tags:[Tag], title:String){
        self.points = points
        self.imageForQuestion = imageForQuestion
        self.imagesForAnswers = imagesForAnswers
        self.correctAnswer = correctAnswer
        self.answers = answers
        self.image = image
        self.tags = tags
        self.title = title
    }
    
    init(key: String, completion: @escaping (Question) -> Void){
        QuestionModel.From(key: key, completion: { (aQuestionModel) in
            self.title = aQuestionModel.questionTitle!
            self.points = Int(aQuestionModel.questionPoints!)
            self.imagesForAnswers = aQuestionModel.imagesForAnswers!
            self.imageForQuestion = aQuestionModel.imageForQuestion!
            
            if self.imageForQuestion!{
                let imageRef = Storage.storage().reference(withPath: aQuestionModel.questionImagePath!)
                imageRef.downloadURL { (u:URL?, e : Error?) in
                    if let error = e
                    {
                        print("Whoops: \(error)")
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
            
            self.tags = []
            var tagKeys:[String] = []
            for tagModel in aQuestionModel.tags{
                tagKeys.append(tagModel.key)
            }
            for tagKey in tagKeys{
                _ = Tag(key:tagKey, completion: { tag in
                    self.tags?.append(tag)
                })
            }
            
            self.answers = []
            
            var answerTexts:[String] = []
            var correctAnswers:[Bool] = []
            
            let answersRef = Database.database().reference(withPath: "choices/\(aQuestionModel.key)/answers")
            answersRef.observeSingleEvent(of: .value, with: { snapshot in
                if let children = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in children {
                        answerTexts.append(child.value as! String)
                    }
                    
                    let correctRef = Database.database().reference(withPath: "choices/\(aQuestionModel.key)/correctanswers")
                    correctRef.observeSingleEvent(of: .value, with: { snapshot in
                        if let children = snapshot.children.allObjects as? [DataSnapshot] {
                            for child in children {
                                correctAnswers.append(child.value as! Bool)
                            }
                        }
                        
                        for i in 0...answerTexts.count - 1 {
                            if self.imagesForAnswers!{
                                _ = Answer(answerText: "", points: self.points!, isAnswer: correctAnswers[i], hasImage: true, imagePath: answerTexts[i]) { theAnswer in
                                    self.answers?.append(theAnswer)
                                }
                            }
                            else{
                                _ = Answer(answerText: answerTexts[i], points: self.points!, isAnswer: correctAnswers[i], hasImage: false, imagePath: "") { theAnswer in
                                    self.answers?.append(theAnswer)
                                }
                            }
                            
                        }
                        
                        completion(self)
                    })
                }
            })
        })
    }

    init(questionDict:[String:AnyObject]){
//        self.points = questionModel.questionPoints!
        self.points = Int(questionDict["points"] as! String)!
//        self.imageForQuestion = questionModel.imageForQuestion!
        self.imageForQuestion = questionDict["imageforquestion"] as? Bool
//        self.imageForAnswers = questionModel.imagesForAnswer!
        self.imagesForAnswers = questionDict["imageforanswers"] as? Bool
        if(self.imageForQuestion)!{
            self.title = ""
        }
        else{
            //self.title = questionModel.questionTitle!
            self.title = questionDict["name"] as? String
        }
//        var toSet:[Tag] = []
//        questionModel.tags.forEach { model in
//            model.getData(withMaxSize: 1 * 1024 * 1024, completion: { (d: Foundation.Data?, e: Error?) in
//                if let error = e
//                {
//                    print("Question Tag Whoops: \(error)")
//                }
//                else
//                {
//                    toSet.append((Tag(tagModel: model)))
//                }
//            })
//        }
//        self.tags = toSet
        self.tags = []

        self.image = UIImage()
        self.answers = []
        self.correctAnswer = ""
    }
    
    deinit {
        points = nil
        imageForQuestion = nil
        imagesForAnswers = nil
        correctAnswer = ""
        answers = []
        image = nil
        tags = []
        title = ""
        print("------->deallocating Question")
    }
    
    func setTags(questionDict:[String:AnyObject]){
        var questionTagKeys:[String] = []
        for questionTag in questionDict["tags"] as! [String:AnyObject]{
            questionTagKeys.append(questionTag.key)
        }
        
        let tagRef = Database.database().reference(withPath: "tag")
        tagRef.observeSingleEvent(of: .value, with: { snapshot in
            if let children = snapshot.children.allObjects as? [DataSnapshot] {
                for child in children {
                    if questionTagKeys.contains(child.key) {
                        self.tags?.append(Tag(tagDict: child.value as! [String:AnyObject]))
                    }
                }
            }
        })
    }

}
