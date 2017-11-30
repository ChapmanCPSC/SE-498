//
//  QuizActivityVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

class QuizActivityVC: UIViewController {
    
    var currQuestion:QuestionModel!
    
    @IBOutlet weak var answer1: UIView!
    @IBOutlet weak var answer2: UIView!
    @IBOutlet weak var answer3: UIView!
    @IBOutlet weak var answer4: UIView!
    var answerViews:[UIView]!

    @IBOutlet weak var lab_questionText: UILabel!
    @IBOutlet weak var lab_questionNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerViews = [answer1, answer2, answer3, answer4]
    }
    
    func registerFirebaseListeners(){
        // handle setting up firebase stuff
    }
    
    func sendIsReady(){
        // tell firebase that this client is ready for next question
    }
    
    func reloadView(){
        // upon getting a new question update the view
        updateQuestionNumber(text: "1")
        updateQuestionText(text: "What is the question from swift")
        updateAnswerTexts(texts: ["Answer1", "Answer2", "Answer3", "Answer4"])
        // updateAnswerPictures(urls: [String])
        
    }
    
    func updateQuestionNumber(text:String){
        
    }
    
    func updateQuestionText(text:String){
        
    }
    
    func updateAnswerTexts(texts:[String]){
        
    }
    
    func updateAnswerPictures(urls:[String]){
        
    }
    
}

