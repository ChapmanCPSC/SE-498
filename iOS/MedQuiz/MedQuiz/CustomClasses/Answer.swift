//
//  AnswerModel.swift
//  MedQuiz
//
//  Created by Harnack, Paul (Student) on 2/25/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Answer {
    var answerText:String?
    var points:Int = 0
    var isAnswer:Bool?
    var hasImage:Bool?
    var image:UIImage?
    
    init(answerText:String, isAnswer:Bool){
        self.answerText = answerText
        self.isAnswer = isAnswer
        self.hasImage = false
    }
    
    init(answerText:String, isAnswer:Bool, hasImage:Bool, imagePath:String, completion:@escaping (Answer) -> Void){
        self.answerText = answerText
        self.isAnswer = isAnswer
        self.hasImage = hasImage
        
        if hasImage{
            let imageRef = Storage.storage().reference(withPath: imagePath)
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
                completion(self)
            }
        }
        else{
            completion(self)
        }
    }
    
    deinit {
        answerText = ""
        isAnswer = nil
        hasImage = nil
        image = nil
        print("-------->deallocating answer")
    }
}
