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
    
    @IBOutlet weak var answer1: AnswerView!
    @IBOutlet weak var answer2: AnswerView!
    @IBOutlet weak var answer3: AnswerView!
    @IBOutlet weak var answer4: AnswerView!
    var answerViews:[AnswerView]!
    var colors:[String] = ["#BB7AE1", "#DCA480", "#DA7E7E", "#88D3E5"]

    var toggleTemp:Bool = true
    @IBOutlet weak var lab_questionText: UILabel!
    @IBOutlet weak var lab_questionNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerViews = [answer1, answer2, answer3, answer4]
        answerViews.forEach { view in view.hideImage() }
        answerViews.forEach { view in view.parent = self }
        setAnswerColors()
    }
    
    func registerFirebaseListeners(){
        // handle setting up firebase stuff
    }
    
    func sendIsReady(){
        // tell firebase that this client is ready for next question
    }

    func setAnswerColors(){
        var count = 0
        answerViews.forEach { view in
            view.setBackgroundColor(color: colors[count])
            count += 1
        }
    }

    func reloadView(){
        // upon getting a new question update the view
        updateQuestionNumber(text: "1")
        updateQuestionText(text: "What is the question from swift")
        updateAnswerTexts(texts: ["Answer1", "Answer2", "Answer3", "Answer4"])
//         updateAnswerPictures(urls: [String])
        
    }
    
    func updateQuestionNumber(text:String){
        
    }
    
    func updateQuestionText(text:String){
        
    }
    
    func updateAnswerTexts(texts:[String]){
        
    }
    
    func updateAnswerPictures(urls:[String]){
        
    }
    
    @IBAction func tempPressed(_ sender: Any) {
        if(toggleTemp){
            answerViews.forEach { view in view.hideText() }
        }
        else{
            answerViews.forEach { view in view.hideImage() }
        }
        toggleTemp = !toggleTemp
    }
    
    @IBAction func tempResetPressed(_ sender: Any) {
        answerViews.forEach { view in view.resetViews() }
    }
}

extension QuizActivityVC:SelectsAnswer {
    func answerSelected(answer: AnswerView) {
        answer.fadeAnswer()
    }
}

