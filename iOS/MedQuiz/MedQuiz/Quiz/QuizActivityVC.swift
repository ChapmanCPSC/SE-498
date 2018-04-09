//
//  QuizActivityVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class QuizActivityVC: UIViewController {
    
    //TODO: Delete this and use a wrapper
    let dataRef = Database.database().reference()

    var currQuestion:Question!
    var currQuestionIdx:Int = -1 // start at -1 so that first call can call nextQuestion
    var currQuiz:Quiz!
    var quizCancelled:Bool = false
    
    var canSelect:Bool = false
    var currPos:Int!
    var user:Student!
    
    var gameKey:String!
    var inGameLeaderboardKey:String!
    var userInGameLeaderboardObjectKey:String!
    var allUsers:[Student]! // TODO kinda working off assumption there'll be an array that'll be updated in firebase that we can use
    var allScores:[Int]!
    
    var headToHeadGameKey:String!
    var headToHeadOpponent:Student!
    
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
    
    @IBOutlet weak var backCancelButton: UIButton!
    
    @IBOutlet weak var con_questionContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var con_questionImageHeight: NSLayoutConstraint!
    
    var seconds = 10
    var secondsForNextQ = 3
    var timer = Timer()
    var timerForNextQ = Timer()
    var isTimerRunning = false
    //temp value set to match test db
    var pointsEarned: Int = 0
    var firstLoad: Bool = true
    
    @IBOutlet weak var questionsTimer: SRCountdownTimer!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var quizMode:QuizLobbyVC.QuizMode!
    
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

        if(quizMode == QuizLobbyVC.QuizMode.HeadToHead){
            backCancelButton.isHidden = false
        }
        else if(quizMode == QuizLobbyVC.QuizMode.Standard){
            backCancelButton.isHidden = true
        }
        else if(quizMode == QuizLobbyVC.QuizMode.Solo){
            backCancelButton.isHidden = false
        }
        print("Multiplier of image is: \(con_questionImageHeight.multiplier)")
        
//        tempSetupQuiz() // TODO Remove this after finishing testing
        //tempSetupLeaderBoard()

        nextQuestion()

        if quizMode == QuizLobbyVC.QuizMode.Standard {
            let inGameLeaderboardRef = Database.database().reference(withPath: "inGameLeaderboards")
            inGameLeaderboardRef.observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    if ((child.value as! [String:AnyObject])["game"] as! String) == self.gameKey {
                        self.inGameLeaderboardKey = child.key
                        let inGameLeaderboardStudentsRef = inGameLeaderboardRef.child(child.key).child("students")
                        inGameLeaderboardStudentsRef.observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                            for child in snapshot.children.allObjects as! [DataSnapshot] {
                                if ((child.value as! [String:AnyObject])["studentKey"] as! String) == self.user.databaseID {
                                    self.userInGameLeaderboardObjectKey = child.key
                                    
                                    //Temp set value
                                    self.dataRef.child("inGameLeaderboards").child(self.inGameLeaderboardKey).child("students").child(self.userInGameLeaderboardObjectKey).child("studentScore").setValue(0)
                                    
                                    
                                    inGameLeaderboardStudentsRef.queryOrdered(byChild: "studentScore").observe(.value, with: { (snapshot:DataSnapshot) in
                                        var leaderboardStudentKeys = [String]()
                                        self.allScores = []
                                        for child in snapshot.children.allObjects as! [DataSnapshot] {
                                            let key = (child.value as! [String:AnyObject])["studentKey"] as! String
                                            leaderboardStudentKeys.append(key)
                                            let score = (child.value as! [String:AnyObject])["studentScore"] as! Int
                                            self.allScores.append(score)
                                        }
                                        
                                        leaderboardStudentKeys.reverse()
                                        self.allScores.reverse()
                                        
                                        var newAllUsers:[Student] = []
                                        var leaderboardPosCounter = 0
                                        for key in leaderboardStudentKeys {
                                            for student in self.allUsers {
                                                if key == student.databaseID {
                                                    leaderboardPosCounter += 1
                                                    newAllUsers.append(student)
                                                    if key == self.user.databaseID {
                                                        self.currPos = leaderboardPosCounter
                                                    }
                                                    break
                                                }
                                            }
                                        }
                                        
                                        self.allUsers = newAllUsers
                                        self.updateLeaderboard()
                                        self.updateUserInLeaderboard()
                                    })
                                }
                            }
                        })
                    }
                }
            })
        }
        
        else if quizMode == QuizLobbyVC.QuizMode.HeadToHead {
            checkRequestStatus {
                //TODO
            }
        }
        
        else if quizMode == QuizLobbyVC.QuizMode.Solo {
            //TODO
        }
    }

    func hideAnswersForTime(){
        //Hides answers for 5 sec and then calls showLabels func
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(showLabels), userInfo: nil, repeats: false)
    }

    //timer that waits for 3 seconds to pass and then calls the nextQuestion func
    func runTimerForNextQ(){
        //TODO: Should timer repeat be on true? Or should we just call it everytime the user selects an answer
        timerForNextQ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimerForNextQ)), userInfo: nil, repeats: true)
    }

    @objc func updateTimerForNextQ(){
        secondsForNextQ -= 1
        if secondsForNextQ == 0 {
            timerForNextQ.invalidate()
            secondsForNextQ = 3
            nextQuestion() //after 3 seconds it calls nextQuestion
        }
    }

    func runTimer() {
        //TODO: Should timer repeat be on true?
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "activityToMain" {
//            let destinationVC = segue.destination as! QuizVC
//            
//        }
//    }
    
    func checkRequestStatus(completion: @escaping () -> Void){
        if quizMode == QuizLobbyVC.QuizMode.HeadToHead {
            StudentModel.FromAndKeepObserving(key: user.databaseID!) {userStudent in
                guard userStudent.headToHeadGameRequest != nil else {
                    print("Head to Head quiz cancelled.")
                    self.quizCancelled = true
                    let alert = UIAlertController(title:"Head to Head Game Cancelled", message:"The Head to Head game has been cancelled.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
                        self.dismiss(animated: false, completion: {
                            
                        })
                        completion()
                    })
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        completion()
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
        canSelect = false
        print("Calling nextQuestion")
        currQuestionIdx += 1
        if(currQuestionIdx >= (currQuiz.questions?.count)!){
            finishQuiz()
            return
        }
        currQuestion = currQuiz.questions![currQuestionIdx]
        // test with 3 choices
        /*currQuestion = Question(points: 10, imageForQuestion: false, imagesForAnswers: false, correctAnswer: "sdfgsdf", answers: [
            Answer(answerText: "sdfgdf", points: 5, isAnswer: false),
            Answer(answerText: "sdfgdf", points: 5, isAnswer: false),
            Answer(answerText: "sdfgdf", points: 5, isAnswer: false)
        ], image: UIImage(), tags: [], title: "dfgsdfg")*/
        // test with 2 choices
        /*currQuestion = Question(points: 10, imageForQuestion: false, imagesForAnswers: false, correctAnswer: "sdfgsdf", answers: [
            Answer(answerText: "sdfgdf", points: 5, isAnswer: false),
            Answer(answerText: "sdfgdf", points: 5, isAnswer: false)
        ], image: UIImage(), tags: [], title: "dfgsdfg")*/
        hideAnswersForTime()
        reloadView()
    }

    func reloadView(){
        // upon getting a new question update the view
        updateQuestionNumber()
        updateQuestionText()
        updateAnswers()
        //updateUserInLeaderboard()
        //runTimerForNextQ()
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
            if(idx >= answers.count){
                currView.setBlank()
            }
            else{
                currView.setAnswer(answer: answers[idx])
            }
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
                view.updateView(student: userSubset[count], position: startingPosition + count + 1, score: 0)
                count += 1
                }
            firstLoad = false
        }
        else{
            userViews.forEach { view in
                //TODO: make generic, hardcoded for demo
                //view.updateView(student: userSubset[count], position: startingPosition + count + 1, score: allScores[startingPosition + count])
                view.updateView(student: userSubset[count], position: count + 1, score: allScores[count])
                count += 1
            }
        }
    }
    
    func updateUserInLeaderboard(){
        userViews.forEach { view in
            if(view.currStudent.userName == user.userName!){
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
            currPos! -= 1
            allUsers.insert(appUser, at: currPos-1)
            updateLeaderboard()
            updateUserInLeaderboard()
        }
    }

    func moveDownPosition(){
        if(currPos < allUsers.count){
            let appUser = allUsers.remove(at: currPos-1)
            currPos! += 1
            allUsers.insert(appUser, at: currPos-1)
            updateLeaderboard()
            updateUserInLeaderboard()
        }
    }


    func finishQuiz(){
         //segue to quiz summary

        updatePersonalScore()

//        let quizSummaryVC = self.storyboard?.instantiateViewController(withIdentifier: "quizSummary") as! QuizSummaryViewController
//        self.dismiss(animated: false) {
//            self.present(quizSummaryVC, animated: false, completion: {
//            })
//        }
        
        let quizSummaryVC = self.storyboard?.instantiateViewController(withIdentifier: "quizSummary") as! QuizSummaryViewController
        
        self.dismiss(animated: false, completion: {
            mainQuizVC.present(quizSummaryVC, animated: false) {
                print("hey")
                
            }
        })

//        performSegue(withIdentifier: "quizActToSummary", sender: nil)
    }

    func updatePersonalScore(){

        //TODO make sure to use key of student currently logged in, for
        // now just assuming b29fks9mf9gh37fhh1h9814 is logged in from
        // quiz lobby vc

        //84y1jn1n12n8n0f80n180289398n1 is the key for that student's
        // score in the score dataset

        dataRef.child("score").child("84y1jn1n12n8n0f80n180289398n1").child("points").setValue(pointsEarned)
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
        print("tempQuestionInvertPressed")
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if quizMode == QuizLobbyVC.QuizMode.Standard {
            performSegue(withIdentifier: "QuizVC", sender: nil)
        }
        
        else if quizMode == QuizLobbyVC.QuizMode.HeadToHead {
            
            let alert = UIAlertController(title: "Are you sure you want to exit the quiz?", message: "All your progress will be lost.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{ action in
                let opponentHeadToHeadRequestRef = Database.database().reference().child("student/\(String(describing: self.headToHeadOpponent.databaseID!))/headtoheadgamerequest")
                opponentHeadToHeadRequestRef.removeValue()
                
                let userHeadToHeadRequestRef = Database.database().reference().child("student/\(String(describing: self.user.databaseID!))/headtoheadgamerequest")
                userHeadToHeadRequestRef.removeValue()
                
                let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(self.headToHeadGameKey!)
                headToHeadGameRef.removeValue()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler:{ action in
                alert.dismiss(animated: false, completion: {
                })
            }))
            
            self.present(alert, animated: true)
            
        }
        
        else if quizMode == QuizLobbyVC.QuizMode.Solo {
            
            let alert = UIAlertController(title: "Are you sure you want to exit the quiz?", message: "All your progress will be lost.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{ action in
                //TODO:Delete data and any realted progress from db
                self.dismiss(animated: false, completion: {
                })
                //performSegue(withIdentifier: "QuizVC", sender: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler:{ action in
                alert.dismiss(animated: false, completion: {
                })
            }))
            
            self.present(alert, animated: true)
            
        }
    }
    
    @IBAction func tempNextQPressed(_ sender: Any) {
        nextQuestion()
    }

    deinit {
        answerViews = []
        print("deallocation quizActivity")
    }
    @IBAction func tempQuizSumarryPressed(_ sender: Any) {
        let quizSummaryVC = self.storyboard?.instantiateViewController(withIdentifier: "quizSummary") as! QuizSummaryViewController
        
        self.dismiss(animated: false, completion: {
            mainQuizVC.present(quizSummaryVC, animated: false) {
                print("hey")
                
            }
        })
        
        
    }
    
}

extension QuizActivityVC:SelectsAnswer {
    func answerSelected(answer: AnswerView) {
        var time:Int = 0
//        timer.invalidate()
//        answer1.answer.points = seconds

      
        if(canSelect){
            canSelect = false

            questionsTimer.pause()
            answer1.answer.points = questionsTimer.returnCurrentTime()
            time = questionsTimer.returnCurrentTime()

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

                        //TODO: Temporary way of updating student score in leaderboard on db.
                        // until db team come up with a solution
                        // will probably use wrappers
                        // for now assu,ing current user is b29fks9mf9gh37fhh1h9814
                        // from quiz lobby, later change to whichever student is currently logged in

//                        dataRef.child("inGameLeaderboards").child("-L8UmIrtot-ouAefIWuq").child("students").child("-L8Ur3M5CegQC3t4Orkk").child("studentScore").setValue(String(pointsEarned))
                        
                    dataRef.child("inGameLeaderboards").child(inGameLeaderboardKey).child("students").child(userInGameLeaderboardObjectKey).child("studentScore").setValue(pointsEarned)

                        //Also TODO: Make leaderboard update by listening to changes from
                        // db leaderboard

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
                    }

                }
                else if(!view.answer.isAnswer!){
                    view.fadeAnswer()
                }
            }
            runTimerForNextQ()//Call this timer, to automatically go to the next question after 3 seconds pass by when the student answers a question
        }
    }
}

