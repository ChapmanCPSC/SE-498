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
    var quizLobbyRef:UIViewController!

    var currQuestion:Question!
    var currQuestionIdx:Int = -1 // start at -1 so that first call can call nextQuestion
    var currQuiz:Quiz!
    var quizEnded:Bool = false
    
    var canSelect:Bool = false
    var currPos:Int!
    var prevPos:Int!
    
    var gameKey:String!
    var inGameLeaderboardKey:String!
    var userInGameLeaderboardObjectKey:String!
    var allUsers:[Student]! // TODO kinda working off assumption there'll be an array that'll be updated in firebase that we can use
    var allScores:[Int]!
    
    var headToHeadOpponent:Student!
    var isInvitee:Bool!
    
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
    
    var checkConcessionRef:DatabaseReference!
    var checkConcessionHandle:DatabaseHandle!
    var checkConcessionSet = false
    var inGameLeaderboardStudentsQuery:DatabaseQuery!
    var inGameLeaderboardStudentsHandle:DatabaseHandle!
    var inGameLeaderboardStudentsSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //quizLobbyRef.dismiss(animated: false, completion: nil)
        
        questionsTimer.backgroundColor = UIColor.clear
        questionsTimer.labelTextColor = UIColor.black
        questionsTimer.lineColor = UIColor.yellow
        questionsTimer.trailLineColor = UIColor.white
        questionsTimer.lineWidth = 5.0
        questionsTimer.isHidden = true
        
        answerViews = [answer1, answer2, answer3, answer4]
        userViews = [UserView]()
        answerViews.forEach { view in view.parent = self }
        hideAnswerLabels()
        setAnswerColors()
        setUserColors()
        hideSidebar()

        hideAnswersForTime()

        switch quizMode! {
        case .Standard:
            getLeaderboardInfo()
            backCancelButton.isHidden = true
            break
        case .HeadToHead:
            getLeaderboardInfo()
            backCancelButton.isHidden = false
            break
        case .Solo:
            allUsers = [currentGlobalStudent]
            allScores = [0]
            uv_first.updateView(student: allUsers[0], position: 0, score: allScores[0])
            uv_first.lab_position.isHidden = true
            userViews = [uv_first]
            uv_fifth.removeFromSuperview()
            uv_fourth.removeFromSuperview()
            uv_third.removeFromSuperview()
            uv_second.removeFromSuperview()
            backCancelButton.isHidden = false
            break
        }
        
        print("Multiplier of image is: \(con_questionImageHeight.multiplier)")
        
//        tempSetupQuiz() // TODO Remove this after finishing testing
        //tempSetupLeaderBoard()
        
        registerFirebaseListeners()

        nextQuestion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //quizLobbyRef.dismiss(animated: false, completion: nil)
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
        switch quizMode! {
        case .Standard:
            //TODO
            break
        case .HeadToHead:
            checkConcession()
            break
        case .Solo:
            //TODO
            break
        }
    }
    
    func getLeaderboardInfo(){
        let inGameLeaderboardsRef = Database.database().reference(withPath: "inGameLeaderboards")
        inGameLeaderboardsRef.observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if (child.childSnapshot(forPath: "game").value as! String) == self.gameKey! {
                    print("leaderboard found")
                    self.inGameLeaderboardKey = child.key
                    inGameLeaderboardsRef.child(child.key).child("students").observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                        for child in snapshot.children.allObjects as! [DataSnapshot] {
                            print("Leaderboard student key: \(child.childSnapshot(forPath: "studentKey").value as! String)")
                            if (child.childSnapshot(forPath: "studentKey").value as! String) == currentUserID {
                                print("user found in leaderboard")
                                self.userInGameLeaderboardObjectKey = child.key
                                
                                //Temp set value
                                Database.database().reference().child("inGameLeaderboards").child(self.inGameLeaderboardKey).child("students").child(self.userInGameLeaderboardObjectKey).child("studentScore").setValue(0)
                                
                                self.inGameLeaderboardStudentsQuery = inGameLeaderboardsRef.child(self.inGameLeaderboardKey).child("students").queryOrdered(byChild: "studentScore")
                                self.inGameLeaderboardStudentsHandle = self.inGameLeaderboardStudentsQuery.observe(.value, with: { (snapshot:DataSnapshot) in
                                    
                                    if !(snapshot.value is NSNull){
                                        self.inGameLeaderboardStudentsSet = true
                                        
                                        var leaderboardStudentKeys = [String]()
                                        self.allScores = []
                                        for child in snapshot.children.allObjects as! [DataSnapshot] {
                                            let key = child.childSnapshot(forPath: "studentKey").value as! String
                                            leaderboardStudentKeys.append(key)
                                            let score = child.childSnapshot(forPath: "studentScore").value as! Int
                                            self.allScores.append(score)
                                        }
                                        
                                        leaderboardStudentKeys.reverse()
                                        self.allScores.reverse()
                                        
                                        var newAllUsers:[Student] = []
                                        var leaderboardPosCounter = 0
                                        for key in leaderboardStudentKeys {
                                            for student in self.allUsers {
                                                if key == student.databaseID {
                                                    newAllUsers.append(student)
                                                    if key == currentUserID {
                                                        self.currPos = leaderboardPosCounter
                                                    }
                                                    leaderboardPosCounter += 1
                                                    break
                                                }
                                            }
                                        }
                                        
                                        if self.firstLoad {
                                            // set userViews
                                            if newAllUsers.count >= 5 {
                                                self.userViews = [self.uv_first, self.uv_second, self.uv_third, self.uv_fourth, self.uv_fifth]
                                            }
                                            else if newAllUsers.count == 4 {
                                                self.userViews = [self.uv_first, self.uv_second, self.uv_third, self.uv_fourth]
                                                self.uv_fifth.removeFromSuperview()
                                            }
                                            else if newAllUsers.count == 3 {
                                                self.userViews = [self.uv_first, self.uv_second, self.uv_third]
                                                self.uv_fifth.removeFromSuperview()
                                                self.uv_fourth.removeFromSuperview()
                                            }
                                            else if newAllUsers.count == 2 {
                                                self.userViews = [self.uv_first, self.uv_second]
                                                self.uv_fifth.removeFromSuperview()
                                                self.uv_fourth.removeFromSuperview()
                                                self.uv_third.removeFromSuperview()
                                            }
                                            else{
                                                self.userViews = [self.uv_first]
                                                self.uv_fifth.removeFromSuperview()
                                                self.uv_fourth.removeFromSuperview()
                                                self.uv_third.removeFromSuperview()
                                                self.uv_second.removeFromSuperview()
                                            }
                                        }
                                        
                                        self.allUsers = newAllUsers
                                        self.updateLeaderboard()
                                        self.updateUserInLeaderboard()
                                    }
                                })
                            }
                        }
                    })
                }
            }
        })
    }
    
    func checkConcession(){
        print("checkConcession")
        checkConcessionRef = Database.database().reference().child("head-to-head-game").child(self.gameKey!)
        checkConcessionHandle = checkConcessionRef.observe(.value, with: { snapshot in
            self.checkConcessionSet = true
            
            if snapshot.value is NSNull && !self.quizEnded {
                self.winByConcession()
            }
        })
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
//        var count = 0
//        userViews.forEach { (view) in
//            view.setBackgroundColor(color: userColors[count])
//            count += 1
//        }
        uv_first.setBackgroundColor(color: userColors[0])
        uv_second.setBackgroundColor(color: userColors[1])
        uv_third.setBackgroundColor(color: userColors[2])
        uv_fourth.setBackgroundColor(color: userColors[3])
        uv_fifth.setBackgroundColor(color: userColors[4])
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
        var userSubset = [Student]()
        var startingPosition = 0
        
        // user is in first or second
        if(currPos == 0 || currPos == 1){
            startingPosition = 0
            userSubset = Array(allUsers[0...userViews.count - 1])
        }
            // user is in second to last or last
        else if(currPos == allUsers.count-1 || currPos == allUsers.count){
            startingPosition = allUsers.count - userViews.count
            userSubset = Array(allUsers[allUsers.count-userViews.count...allUsers.count-1])
        }
            // user is somewhere in between
        else if userViews.count == 5{
            startingPosition = currPos-2
            userSubset = Array(allUsers[currPos-2...currPos+2])
        }
        
        var count = 0
        
        print("CURR POS \(currPos!)")
        
        if(firstLoad){
            userViews.forEach { view in
                view.updateView(student: userSubset[count], position: startingPosition + count + 1, score: 0)
                if startingPosition + count == currPos {
                    view.convertToCurrUser()
                }
                
                count += 1
                }
            firstLoad = false
        }
        else{
            userViews.forEach { view in
                view.updateView(student: userSubset[count], position: count + 1, score: allScores[count])
                if startingPosition + count == currPos {
                    view.convertToCurrUser()
                }
                else if startingPosition + count == prevPos {
                    view.convertToOtherUser()
                }
                
                count += 1
            }
        }
        prevPos = currPos
    }
    
    func updateUserInLeaderboard(){
        
        //TODO: Uncomment and see why it causes crash
//        userViews.forEach { view in
//            if(view.currStudent.userName == globalUsername){
//                view.convertToCurrUser()
//            }
//            else{
//                view.convertToOtherUser()
//            }
//         }
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

    func headToHeadConcede(){
        print("Game conceded")
        quizEnded = true
        deleteDBHeadToHeadData()
    }
    
    func winByConcession(){
        print("Won by concession")
        quizEnded = true
        let userHeadToHeadRequestReference = Database.database().reference().child("student").child(currentUserID)
        userHeadToHeadRequestReference.child("headtoheadgamerequest").removeValue()
        removeListeners()
        updatePersonalScore()
        let quizSummaryVC = self.storyboard?.instantiateViewController(withIdentifier: "quizSummary") as! QuizSummaryViewController
        self.dismiss(animated: false, completion: {
            mainQuizVC.present(quizSummaryVC, animated: false, completion: {
                let alert = UIAlertController(title:"Game Conceded", message:"Head to Head game with conceded by your opponent.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
                    alert.dismiss(animated: false, completion: nil)
                })
            })
        })
    }
    
    func finishQuiz(){
         //segue to quiz summary

        removeListeners()
        
        updatePersonalScore()

//        let quizSummaryVC = self.storyboard?.instantiateViewController(withIdentifier: "quizSummary") as! QuizSummaryViewController
//        self.dismiss(animated: false) {
//            self.present(quizSummaryVC, animated: false, completion: {
//            })
//        }
        
        // delete head to head game data as second person out
//        if quizMode == .HeadToHead {
//            if isInvitee {
//                let headToHeadReadyRef = Database.database().reference(withPath: "head-to-head-game/\(gameKey!)/invitee/ready")
//                headToHeadReadyRef.setValue(false)
//
//                let headToHeadOpponentReadyRef = Database.database().reference(withPath: "head-to-head-game/\(gameKey!)/inviter/ready")
//                headToHeadOpponentReadyRef.observeSingleEvent(of: .value, with: { snapshot in
//                    if !(snapshot.value as! Bool){
//                        self.deleteDBHeadToHeadData()
//                    }
//                })
//            }
//            else{
//                let headToHeadReadyRef = Database.database().reference(withPath: "head-to-head-game/\(gameKey!)/inviter/ready")
//                headToHeadReadyRef.setValue(false)
//
//                let headToHeadOpponentReadyRef = Database.database().reference(withPath: "head-to-head-game/\(gameKey!)/invitee/ready")
//                headToHeadOpponentReadyRef.observeSingleEvent(of: .value, with: { snapshot in
//                    if !(snapshot.value as! Bool){
//                        self.deleteDBHeadToHeadData()
//                    }
//                })
//            }
//        }
        
        let quizSummaryVC = self.storyboard?.instantiateViewController(withIdentifier: "quizSummary") as! QuizSummaryViewController
        
        self.dismiss(animated: false, completion: {
            self.quizLobbyRef.dismiss(animated: false, completion: {
                mainQuizVC.present(quizSummaryVC, animated: false) {
                    print("hey")
                }
            })

        })
        print("->>>>>>>>>>>>>>>>>>>>>>>>>>")
        

//        performSegue(withIdentifier: "quizActToSummary", sender: nil)
    }

    func updatePersonalScore(){

        //TODO make sure to use key of student currently logged in, for
        // now just assuming b29fks9mf9gh37fhh1h9814 is logged in from
        // quiz lobby vc

        //84y1jn1n12n8n0f80n180289398n1 is the key for that student's
        // score in the score dataset
        
        
        //TODO update current user not some random one
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
//        if(isCurrUser){
//            uv_third.convertToOtherUser()
//        }
//        else{
//            uv_third.convertToCurrUser()
//        }
//        isCurrUser = !isCurrUser
        
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
        allUsers.insert(currentGlobalStudent, at: currPos-1)
        updateLeaderboard()
    }
    
    func removeListeners(){
        switch quizMode! {
        case .Standard:
            if inGameLeaderboardStudentsSet {
                            inGameLeaderboardStudentsQuery.removeObserver(withHandle: inGameLeaderboardStudentsHandle)
            }
            break
        case .HeadToHead:
            if checkConcessionSet {
                checkConcessionRef.removeObserver(withHandle: checkConcessionHandle)
            }
            //inGameLeaderboardStudentsRef.removeObserver(withHandle: inGameLeaderboardStudentsHandle)
            break
        case .Solo:
            break
        }
    }
    
    func exitQuiz(completion:(() -> Void)?){
        removeListeners()

        let userHeadToHeadRequestReference = Database.database().reference().child("student").child(currentUserID)
        userHeadToHeadRequestReference.child("headtoheadgamerequest").removeValue()
        
        self.dismiss(animated: false, completion: {
            self.quizLobbyRef.dismiss(animated: false, completion: {
                completion?()
            })
        })
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to exit the quiz?", message: "All your progress will be lost.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{ action in
            switch self.quizMode! {
            case .Standard:
                //TODO
                break
            case .HeadToHead:
                self.headToHeadConcede()
                break
            case .Solo:
                //TODO
                break
            }
            
            self.exitQuiz(completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler:{ action in
            alert.dismiss(animated: false, completion: {
            })
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func tempNextQPressed(_ sender: Any) {
        nextQuestion()
    }

    deinit {
        answerViews = []
        print("deallocation quizActivity")
    }
    @IBAction func tempQuizSumarryPressed(_ sender: Any) {
        removeListeners()
        
        let quizSummaryVC = self.storyboard?.instantiateViewController(withIdentifier: "quizSummary") as! QuizSummaryViewController
        
        self.dismiss(animated: false, completion: {
            mainQuizVC.present(quizSummaryVC, animated: false) {
                print("hey")
                
            }
        })
    }
    
    func errorOccurred(title:String, message:String, completion:(() -> Void)?){
        print("error occurred")
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
            self.exitQuiz(completion: {
                completion!()
            })
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteDBHeadToHeadData(){
        let opponentHeadToHeadRequestRef = Database.database().reference().child("student/\(String(describing: headToHeadOpponent.databaseID!))/headtoheadgamerequest")
        opponentHeadToHeadRequestRef.removeValue()
        
        let userHeadToHeadRequestRef = Database.database().reference().child("student/\(String(describing: currentUserID))/headtoheadgamerequest")
        userHeadToHeadRequestRef.removeValue()
        
        let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(gameKey!)
        headToHeadGameRef.removeValue()
        
        let headToHeadGameLeaderboardRef = Database.database().reference().child("inGameLeaderboards/\(inGameLeaderboardKey!)")
        headToHeadGameLeaderboardRef.removeValue()
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
                        if quizMode != .Solo {
                            updateUserInLeaderboard()
                        dataRef.child("inGameLeaderboards").child(inGameLeaderboardKey).child("students").child(userInGameLeaderboardObjectKey).child("studentScore").setValue(pointsEarned)
                        }
                        else{
                            uv_first.updateView(student: allUsers[0], position: 0, score: pointsEarned)
                        }
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

