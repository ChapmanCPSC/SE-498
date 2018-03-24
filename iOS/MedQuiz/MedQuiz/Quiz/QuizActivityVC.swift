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
    
    var currQuestion:Question!
    var currQuestionIdx:Int = -1 // start at -1 so that first call can call nextQuestion
    var currQuiz:Quiz!
    var canSelect:Bool = false
    var currPos:Int = 5
    var user:Student = Student(userName: "Paul", profilePic: UIImage(), friends: [], totalPoints: 0, hasChangedUsername: false)
    var allUsers:[Student]! // TODO kinda working off assumption there'll be an array that'll be updated in firebase that we can use
    
    @IBOutlet weak var answer1: AnswerView!
    @IBOutlet weak var answer2: AnswerView!
    @IBOutlet weak var answer3: AnswerView!
    @IBOutlet weak var answer4: AnswerView!
    var answerViews:[AnswerView]!
    var colors:[String] = ["#BB7AE1", "#DCA480", "#DA7E7E", "#88D3E5"]
    var userColors:[String] = ["#8884FF", "#9AD5D2", "#BB7AE1", "#F5A623","#8884FF"]
    
    @IBOutlet weak var uv_first: UserView!
    @IBOutlet weak var uv_second: UserView!
    @IBOutlet weak var uv_third: UserView!
    @IBOutlet weak var uv_fourth: UserView!
    @IBOutlet weak var uv_fifth: UserView!
    var userViews:[UserView]!

    
    var toggleTemp:Bool = true
    var toggleTempQuestion:Bool = true
    var isCurrUser:Bool = false

    @IBOutlet weak var lab_questionText: UILabel!
    @IBOutlet weak var lab_questionNumber: UILabel!
    @IBOutlet weak var iv_questionImage: UIImageView!
    @IBOutlet weak var viewQuestionContainer: UIView!
    
    @IBOutlet var viewMain: UIView!
    
    
    @IBOutlet weak var con_questionContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var con_questionImageHeight: NSLayoutConstraint!
    
    var seconds = 10
    var timer = Timer()
    var isTimerRunning = false
    var pointsEarned: Int = 0
    var firstLoad: Bool = true
    
    @IBOutlet weak var questionsTimer: SRCountdownTimer!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        questionsTimer.backgroundColor = UIColor.clear
        questionsTimer.labelTextColor = UIColor.black
        questionsTimer.lineColor = UIColor.yellow
        questionsTimer.trailLineColor = UIColor.white
        questionsTimer.lineWidth = 5.0
        questionsTimer.isHidden = true
        
        answerViews = [answer1, answer2, answer3, answer4]
        userViews = [uv_first, uv_second, uv_third, uv_fourth, uv_fifth]
        answerViews.forEach { view in view.parent = self }
        hideAnswerLabels()
        setAnswerColors()
        setUserColors()
        hideSidebar()

        hideAnswersForTime()

        print("Multiplier of image is: \(con_questionImageHeight.multiplier)")
        
//        tempSetupQuiz() // TODO Remove this after finishing testing
        tempSetupLeaderBoard()

        nextQuestion()

        updateUserInLeaderboard() // TODO maybe remove this?
    }

    func hideAnswersForTime(){
        //Hides answers for 5 sec and then calls showLabels func
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(showLabels), userInfo: nil, repeats: false)
    }

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        seconds -= 1
        timerLabel.text = "\(seconds)"
        if seconds == 0{
            timer.invalidate()
            seconds = 10
        }
    }
    
    @objc func showLabels(){
        answerViews.forEach { view in view.displayAnswer() }
        canSelect = true
        questionsTimer.isHidden = false
        questionsTimer.start(beginingValue: 10, interval: 1)
//        runTimer()
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
    
    func setUserColors(){
        var count = 0
        userViews.forEach { (view) in
            view.setBackgroundColor(color: userColors[count])
            count += 1
        }
    }

    func nextQuestion(){
        currQuestionIdx += 1
        if(currQuestionIdx == currQuiz.questions?.count){
            finishQuiz()
            return
        }
        currQuestion = currQuiz.questions![currQuestionIdx]
        hideAnswersForTime()
        reloadView()
    }

    func reloadView(){
        // upon getting a new question update the view
        updateQuestionNumber()
        updateQuestionText()
        updateAnswers()
    }

    func displayImageQuestion(){
        // resize container
        let newConstraint = con_questionContainerHeight.constraintWithMultipler(0.5)
        viewMain.removeConstraint(con_questionContainerHeight)
        con_questionContainerHeight = newConstraint
        viewMain.addConstraint(con_questionContainerHeight)
        viewMain.layoutIfNeeded()

        // resize image
        let newImageConstraint = con_questionImageHeight.constraintWithMultipler(0.5)
        viewQuestionContainer.removeConstraint(con_questionImageHeight)
        con_questionImageHeight = newImageConstraint
        viewQuestionContainer.addConstraint(con_questionImageHeight)
        viewQuestionContainer.layoutIfNeeded()

        iv_questionImage.isHidden = false
    }

    func displayTextQuestion(){
        // resize container
        let newConstraint = con_questionContainerHeight.constraintWithMultipler(0.2)
        viewMain.removeConstraint(con_questionContainerHeight)
        con_questionContainerHeight = newConstraint
        viewMain.addConstraint(con_questionContainerHeight)
        viewMain.layoutIfNeeded()

        // resize image
        let newImageConstraint = con_questionImageHeight.constraintWithMultipler(0.000000001)
        viewQuestionContainer.removeConstraint(con_questionImageHeight)
        con_questionImageHeight = newImageConstraint
        viewQuestionContainer.addConstraint(con_questionImageHeight)
        viewQuestionContainer.layoutIfNeeded()


        iv_questionImage.isHidden = true
    }

    func updateQuestionNumber(){
        lab_questionNumber.text = "Q\(currQuestionIdx+1)"
    }
    
    func updateQuestionText(){
        // has to call displayTextQuestion first so that it hides the image
        if let _ = currQuestion.title{
            lab_questionText.text = currQuestion.title
            displayTextQuestion()
        }

        if(currQuestion.imageForQuestion!){
            // TODO set iv_questionImage's image
            iv_questionImage.image = currQuestion.image
            displayImageQuestion()
        }
    }
    
    func updateAnswers(){
        let answers = currQuestion.answers!
        for idx in 0..<4{
            let currView = answerViews[idx] as AnswerView
            currView.setAnswer(answer: answers[idx])
        }
    }

    func updateLeaderboard(){
        var userSubset:[Student]
        var startingPosition:Int
        // user is in first or second
        if(currPos == 1 || currPos == 2){
            startingPosition = 1
            userSubset = Array(allUsers[0...4])
        }
        // user is in second to last or last
        else if(currPos == allUsers.count-1 || currPos == allUsers.count){
            startingPosition = allUsers.count - 5
            userSubset = Array(allUsers[allUsers.count-5...allUsers.count-1])
        }
        // user is somewhere in between
        else{
            startingPosition = currPos-2
            userSubset = Array(allUsers[currPos-3...currPos+1])
        }
        var count = 0
        
        if(firstLoad){
            userViews.forEach { view in
                view.updateView(student: userSubset[count], position: startingPosition + count, score: 0)
                count += 1
                }
            firstLoad = false
        }
        else{
            userViews.forEach { view in
                view.updateView(student: userSubset[count], position: startingPosition + count)
                count += 1
            }
        }
    }
    
    func updateUserInLeaderboard(){
        userViews.forEach { view in
            if(view.currStudent.userName == user.userName){
                view.convertToCurrUser()
            }
            else{
                view.convertToOtherUser()
            }
         }
    }

    func moveUpPosition(){
        if (currPos > 1){
            let appUser = allUsers.remove(at: currPos-1)
            currPos -= 1
            allUsers.insert(appUser, at: currPos-1)
            updateLeaderboard()
            updateUserInLeaderboard()
        }
    }

    func moveDownPosition(){
        if(currPos < allUsers.count){
            let appUser = allUsers.remove(at: currPos-1)
            currPos += 1
            allUsers.insert(appUser, at: currPos-1)
            updateLeaderboard()
            updateUserInLeaderboard()
        }
    }


    func finishQuiz(){
         //segue to quiz summary
        performSegue(withIdentifier: "quizActToSummary", sender: nil)
    }

    @IBAction func tempPressed(_ sender: Any) {
        if(toggleTemp){
            answerViews.forEach { view in
                //view.answer.imageLink="dfg"
                view.answer.hasImage = true
            }
        }
        else{
            answerViews.forEach { view in
                //view.answer.imageLink = ""
                view.answer.hasImage = false
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
            canSelect = true
        }
        seconds = 11
        questionsTimer.start(beginingValue: 10, interval: 1)
//        updateTimer()
//        runTimer()
    }

    @IBAction func tempQuestionInvertPressed(_ sender: Any) {
        if(toggleTemp){
            displayImageQuestion()
        }
        else{
            displayTextQuestion()
        }
        toggleTemp = !toggleTemp
    }

    @IBAction func tempUpPosition(_ sender: Any) {
        moveUpPosition()
    }
    
    @IBAction func tempDownPosition(_ sender: Any) {
        moveDownPosition()
    }
    
    @IBAction func tempSwitchCurrUser(_ sender: Any) {
        if(isCurrUser){
            uv_third.convertToOtherUser()
        }
        else{
            uv_third.convertToCurrUser()
        }
        isCurrUser = !isCurrUser
        
    }
    
    func tempSetupQuiz(){
        answer1.answer.isAnswer = true
        answer1.answer.answerText = "This is a correct answer"
    }

    func tempSetupLeaderBoard(){
        allUsers = []
        for i in 1...30 {
            allUsers.append(Student(userName: "User \(i)", profilePic: UIImage(), friends: [], totalPoints: 0, hasChangedUsername: false))
        }
        allUsers.insert(user, at: currPos-1)
        updateLeaderboard()
    }
    @IBAction func tempBackPressed(_ sender: Any) {
        self.dismiss(animated: false) {
        }
    }
    @IBAction func tempNextQPressed(_ sender: Any) {
        nextQuestion()
    }
}

extension QuizActivityVC:SelectsAnswer {
    func answerSelected(answer: AnswerView) {
        var time:Int = 0
//        timer.invalidate()
//        answer1.answer.points = seconds
        questionsTimer.pause()
        answer1.answer.points = questionsTimer.returnCurrentTime()
        time = questionsTimer.returnCurrentTime()
      
        if(canSelect){
            canSelect = false
            answerViews.forEach { (view) in
                if(view == answer){
                    // check if it's correct and take appropriate action
                    let selectedAnswer = view.answer
                    if(selectedAnswer.isAnswer)!{
                        view.showCorrect()
                        pointsEarned += time
                        //moveUpPosition()
                        //moveDownPosition()
                        //updateLeaderboard()
                        updateUserInLeaderboard()
                    }
                    else{
                        view.fadeAnswer()
                        view.showWrong()
                        if(pointsEarned - time < 0){
                            pointsEarned = 0
                        }
                        else{
                            pointsEarned -= time
                        }
                        //updateLeaderboard()
                        updateUserInLeaderboard()
                    }

                }
                else if(!view.answer.isAnswer!){
                    view.fadeAnswer()
                }
            }
        }

    }
}

