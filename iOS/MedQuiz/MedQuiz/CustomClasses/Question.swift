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
    var points:Int
    var imageForQuestion:Bool
    var imageForAnswers:Bool
    var correctAnswer:String
    var answers:[Answer]
    var images:[String]// TODO Figure out what type it actually is
    var tags:[Tag]// TODO make TagModel (Probably same as the quiz?)
    var title:String

    init(points:Int, imageForQuestion:Bool, imageForAnswers:Bool, correctAnswer:String, answers:[Answer], images:[String], tags:[Tag], title:String){
        self.points = points
        self.imageForQuestion = imageForQuestion
        self.imageForAnswers = imageForAnswers
        self.correctAnswer = correctAnswer
        self.answers = answers
        self.images = images
        self.tags = tags
        self.title = title
    }

    init(questionDict:[String:AnyObject]){
//        self.points = questionModel.questionPoints!
        self.points = Int(questionDict["points"] as! String)!
//        self.imageForQuestion = questionModel.imageForQuestion!
        self.imageForQuestion = questionDict["imageforquestion"] as! Bool
//        self.imageForAnswers = questionModel.imagesForAnswer!
        self.imageForAnswers = questionDict["imageforanswers"] as! Bool
        if(self.imageForQuestion){
            self.title = ""
        }
        else{
            //self.title = questionModel.questionTitle!
            self.title = questionDict["name"] as! String
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

        self.images = []
        self.answers = []
        self.correctAnswer = ""
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
                        self.tags.append(Tag(tagDict: child.value as! [String:AnyObject]))
                    }
                }
            }
        })
    }

}
