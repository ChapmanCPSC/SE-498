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

/*
 Answer stores information from Answer objects in database (does not have associated Model).
 */

class Answer {
    var answerText:String?
    var points:Int = 0
    var isAnswer:Bool?
    var hasImage:Bool?
    var image:UIImage?
    
    /*
     Create Answer from minimal set of attribute values.
     */
    
    init(answerText:String, isAnswer:Bool){
        self.answerText = answerText
        self.isAnswer = isAnswer
        self.hasImage = false
    }
    
    /*
     Create Answer from maximal set of attribute values.
     */
    
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
    
    /*
     Deinitialize Answer object.
     */
    
    deinit {
        answerText = ""
        isAnswer = nil
        hasImage = nil
        image = nil
        print("-------->deallocating answer")
    }
}
