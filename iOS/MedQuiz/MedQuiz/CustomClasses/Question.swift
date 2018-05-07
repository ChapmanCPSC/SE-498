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
    var imageForQuestion:Bool?
    var imagesForAnswers:Bool?
    var correctAnswer:String?
    var answers:[Answer]?
    var image:UIImage?
    var tags:[Tag]?
    var name:String?
    
    var answerTexts:[String] = []
    var correctAnswers:[Bool] = []

    init(points:Int, imageForQuestion:Bool, imagesForAnswers:Bool, correctAnswer:String, answers:[Answer], image:UIImage, tags:[Tag], name:String){
        self.imageForQuestion = imageForQuestion
        self.imagesForAnswers = imagesForAnswers
        self.correctAnswer = correctAnswer
        self.answers = answers
        self.image = image
        self.tags = tags
        self.name = name
    }
    
    init(key: String, completion: @escaping (Question) -> Void){
        QuestionModel.From(key: key, completion: { (aQuestionModel) in
            if let name = aQuestionModel.questionName {
                self.name = name
            }
            else{
                self.name = (Database.database().reference(withPath: "question-name/\(key)").value(forKey: "name") as! String)
            }
            
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
            
            self.getAnswers(questionKey: aQuestionModel.key, completion: {
                
//                print("please")
//                print(self.answerTexts)
                self.getCorrectAnswers(questionKey: aQuestionModel.key, completion: {
                    print("answerTexts length: \(self.answerTexts.count)")
                    for i in 0...self.answerTexts.count - 1 {
                        print("index is ", i)
                        if self.imagesForAnswers!{
                            _ = Answer(answerText: "", isAnswer: self.correctAnswers[i], hasImage: true, imagePath: self.answerTexts[i]) { theAnswer in
                                self.answers?.append(theAnswer)
                            }
                        }
                        else{
                            _ = Answer(answerText: self.answerTexts[i], isAnswer: self.correctAnswers[i], hasImage: false, imagePath: "") { theAnswer in
                                self.answers?.append(theAnswer)
                            }
                        }
                        
                    }
                    print("Question Done")
                    completion(self)
                })
            })
        })
    }

    func getAnswers(questionKey:String, completion: @escaping () -> Void){
        
        print("questionKey: \(questionKey)")
        
        let answersRef = Database.database().reference(withPath: "choices/\(questionKey)/answers")
        
        answersRef.observeSingleEvent(of: .value, with: { snapshot in
            let children = snapshot.children.allObjects as? [DataSnapshot]
            for child in children! {
                print("answers child: \(child.value as! String)")
                self.answerTexts.append(child.value as! String)
//                print("new answer text")
//                print(self.answerTexts)
                }
//            print("half answer text")
//            print(self.answerTexts)
            completion()
        })
        
    }
    
    
    func getCorrectAnswers(questionKey:String, completion: @escaping () -> Void){
        
        //print("quizKey")
        //print(quizKey)
        
        Database.database().reference().child("choices").child(questionKey).child("correctanswers").observeSingleEvent(of: DataEventType.value) { (correctAnswerSnap) in
            //print("CORRECT ANSWER")
            //print(correctAnswerSnap.value!)
            //print("next half answer text")
            //print(self.answerTexts)
            for child in correctAnswerSnap.children{
                self.correctAnswers.append((child as! DataSnapshot).value! as! Bool)
                    print("new correct answer")
                    print(self.correctAnswers)
                }
                completion()
        }
    }
    
    init(questionDict:[String:AnyObject]){
//        self.points = questionModel.questionPoints!
//        self.imageForQuestion = questionModel.imageForQuestion!
        self.imageForQuestion = questionDict["imageforquestion"] as? Bool
//        self.imageForAnswers = questionModel.imagesForAnswer!
        self.imagesForAnswers = questionDict["imageforanswers"] as? Bool
        if(self.imageForQuestion)!{
            self.name = ""
        }
        else{
            //self.title = questionModel.questionTitle!
            self.name = questionDict["name"] as? String
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
