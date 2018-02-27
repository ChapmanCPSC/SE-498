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

    @IBOutlet weak var uv_first: UserView!
    @IBOutlet weak var uv_second: UserView!
    @IBOutlet weak var uv_third: UserView!
    @IBOutlet weak var uv_fourth: UserView!
    @IBOutlet weak var uv_fifth: UserView!
    var userViews:[UserView]!
    
    
    var toggleTemp:Bool = true
    @IBOutlet weak var lab_questionText: UILabel!
    @IBOutlet weak var lab_questionNumber: UILabel!
    
    var seconds = 5
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        answerViews = [answer1, answer2, answer3, answer4]
        userViews = [uv_first, uv_second, uv_third, uv_fourth, uv_fifth]
        answerViews.forEach { view in view.parent = self }
        hideAnswerLabels()
        setAnswerColors()
        hideSidebar()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(showLabels), userInfo: nil, repeats: false)
       // runTimer()
    }
    
   /* func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(QuizActivityVC.updateTimer)), userInfo: nil, repeats: true)
    }*/
    
    @objc func showLabels(){
        answerViews.forEach { view in view.displayAnswer() }
    }
    
    func hideAnswerLabels(){
        answerViews.forEach { view in view.resetViews()}
    }
    
    func registerFirebaseListeners(){
        // handle setting up firebase stuff
    }
    
    func sendIsReady(){
        // tell firebase that this client is ready for next question
    }

    func hideSidebar(){
        self.splitViewController?.preferredDisplayMode = .primaryHidden
        // TODO Should be switched back to true after finishing quiz?
        self.splitViewController?.presentsWithGesture = false
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
            answerViews.forEach { view in
                view.answer.imageLink="dfg"
            }
        }
        else{
            answerViews.forEach { view in
                view.answer.imageLink = ""
            }
        }
        toggleTemp = !toggleTemp
        answerViews.forEach { (view) in
            view.resetViews()
            view.displayAnswer()
        }
    }
    
    @IBAction func tempResetPressed(_ sender: Any) {
        answerViews.forEach { view in
            view.resetViews()
            view.displayAnswer()
        }
    }
}

extension QuizActivityVC:SelectsAnswer {
    func answerSelected(answer: AnswerView) {
        answerViews.forEach { (view) in
            if(view == answer){
                // check if it's correct and take appropriate action
            }
            else{
                view.fadeAnswer()
            }
        }
    }
}

