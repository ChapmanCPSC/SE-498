//
//  QuizLobbyVC.swift
//  MedQuiz
//
//  Created by Chad Johnson on 3/11/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit
import Firebase

/*
 QuizLobbyVC performs downloads of quiz and student data before transitioning to QuizActivityVC while displaying player information for standard
 and head to head games. Data errors will prompt an alert and trigger view dismissal. Actions/cancellations made by other players are reflected through
 changes to the lobbyPlayersCollectionView and alerts.
 */

class QuizLobbyVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var headToHeadRequestRef:UIViewController!
    
    var quiz:Quiz!
    
    var gameKey:String?
    var quizKey:String!
    var leaderboardKey:String?
    var userInLeaderboardKey:String?
    var lobbyDone:Bool = false
    
    var quizDownloaded:Bool = false
    
    @IBOutlet weak var lobbyPlayersCollectionView: UICollectionView!
    
    @IBOutlet weak var headToHeadUserAvatarImageView: UIImageView!
    @IBOutlet weak var headToHeadUserUserNameLabel: UILabel!
    @IBOutlet weak var headToHeadUserScoreLabel: UILabel!
    @IBOutlet weak var headToHeadOpponentAvatarImageView: UIImageView!
    @IBOutlet weak var headToHeadOpponentUserNameLabel: UILabel!
    @IBOutlet weak var headToHeadOpponentScoreLabel: UILabel!
    @IBOutlet weak var andLabel: UILabel!
    
    var headToHeadAccepted:Bool = false
    var headToHeadReady:Bool = false
    
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    let loadingIndicatorViewScale:CGFloat = 2.0
    let loadingIndicatorViewColor = UIColor.hexStringToUIColor(hex: "FFDF00")
    
    @IBOutlet weak var backButton: UIButton!
    
    var lobbyPlayers = [Student]()
    var lobbyQueue = [Student]()
    var headToHeadOpponent:Student!
    var isInvitee:Bool!
    
    @IBOutlet weak var statusLabel: UILabel!
    var loadingString:String = "Loading Quiz"
    var waitingString:String!
    var headToHeadAcceptedString:String = "Request accepted. Starting game..."
    
    enum QuizMode {
        case Standard
        case HeadToHead
        case Solo
    }
    
    var quizMode:QuizMode!
    
    var checkGameStartRef:DatabaseReference!
    var checkGameStartHandle:DatabaseHandle!
    var checkGameStartSet = false
    var checkHeadToHeadGameStatusRef:DatabaseReference!
    var checkHeadToHeadGameStatusHandle:DatabaseHandle!
    var checkHeadToHeadGameStatusSet = false
    var downloadStudentsRef:DatabaseReference!
    var downloadStudentsHandle:DatabaseHandle!
    var downloadStudentsSet = false
    
    /*
     Setup various visual components, then perform start.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("quiz lobby")
        
        hideSidebar()
        statusLabel.text = loadingString
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loadingIndicatorView.transform = CGAffineTransform.init(scaleX: loadingIndicatorViewScale, y: loadingIndicatorViewScale)
        loadingIndicatorView.startAnimating()
        loadingIndicatorView.color = loadingIndicatorViewColor
        
        start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        print("quiz lobby appeared")
    }

    /*
     Check for missing attribute values. Adjust UI elements based on quizMode. Perform download.
     */
    
    func start(){
        if quizKey == nil || quizMode == nil {
            errorOccurred(title: "Game/Quiz Info Missing", message: "Information for the current game/quiz was not properly transfered to the lobby.", completion: nil)
        }
        else{
            switch quizMode! {
            case .Standard:
                if gameKey == nil {
                    errorOccurred(title: "Game Info Missing", message: "Information for the current  game was not properly transfered to the lobby.", completion: nil)
                }
                else{
                    waitingString = "Waiting for other players..."
                    lobbyPlayersCollectionView.isHidden = false

                    lobbyPlayersCollectionView.delegate = self
                    lobbyPlayersCollectionView.dataSource = self
                    lobbyPlayersCollectionView.showsVerticalScrollIndicator = false
                }

                break
            case .HeadToHead:
                if gameKey == nil || isInvitee == nil || headToHeadOpponent == nil {
                    errorOccurred(title: "Head to Head Info Missing", message: "Information for the current Head to Head game was not properly transfered to the lobby.", completion: nil)
                }
                else{
                    if isInvitee{
                        headToHeadRequestRef.dismiss(animated: false, completion: nil)
                    }

                    waitingString = "Waiting for " + headToHeadOpponent.userName!

                    headToHeadUserAvatarImageView.isHidden = false
                    headToHeadUserUserNameLabel.isHidden = false
                    headToHeadUserScoreLabel.isHidden = false
                    headToHeadOpponentAvatarImageView.isHidden = false
                    headToHeadOpponentUserNameLabel.isHidden = false
                    headToHeadOpponentScoreLabel.isHidden = false
                    andLabel.isHidden = false

                    headToHeadUserAvatarImageView.image = globalProfileImage
                    headToHeadUserUserNameLabel.text = globalUsername
                    headToHeadUserScoreLabel.text = String(describing: globalHighscore)
                    headToHeadOpponentAvatarImageView.image = headToHeadOpponent.profilePic!
                    headToHeadOpponentUserNameLabel.text = headToHeadOpponent.userName!
                    headToHeadOpponentScoreLabel.text = String(describing: headToHeadOpponent.totalPoints!)
                }
                break
            case .Solo:
                waitingString = "Ready to start..."
                break
            }

            download()

        }
        
        
        
        
//                switch quizMode! {
//                case .Standard:
//                    waitingString = "Waiting for other players..."
//
//                    lobbyPlayersCollectionView.isHidden = false
//                    lobbyPlayersCollectionView.delegate = self
//                    lobbyPlayersCollectionView.dataSource = self
//                    lobbyPlayersCollectionView.showsVerticalScrollIndicator = false
//                    break
//                case .HeadToHead:
//                    if isInvitee{
//                        headToHeadRequestRef.dismiss(animated: false, completion: nil)
//                    }
//
//                    waitingString = "Waiting for " + headToHeadOpponent.userName!
//
//                    headToHeadUserAvatarImageView.isHidden = false
//                    headToHeadUserUserNameLabel.isHidden = false
//                    headToHeadUserScoreLabel.isHidden = false
//                    headToHeadOpponentAvatarImageView.isHidden = false
//                    headToHeadOpponentUserNameLabel.isHidden = false
//                    headToHeadOpponentScoreLabel.isHidden = false
//                    andLabel.isHidden = false
//
//                    headToHeadUserAvatarImageView.image = globalProfileImage
//                    headToHeadUserUserNameLabel.text = globalUsername
//                    headToHeadUserScoreLabel.text = String(describing: globalHighscore)
//                    headToHeadOpponentAvatarImageView.image = headToHeadOpponent.profilePic!
//                    headToHeadOpponentUserNameLabel.text = headToHeadOpponent.userName!
//                    headToHeadOpponentScoreLabel.text = String(describing: headToHeadOpponent.totalPoints!)
//                    break
//                case .Solo:
//                    waitingString = "Ready to start..."
//                    break
//                }
//
//        //        if !lobbyDone {
//        //            download()
//        //        }
//
//                download()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Hide the sidebar from the splitViewController.
     */
    
    func hideSidebar(){
        self.splitViewController?.preferredDisplayMode = .primaryHidden
        // TODO Should be switched back to true after finishing quiz?
        self.splitViewController?.presentsWithGesture = false
    }
    
    /*
     Return data count for collectionView.
     */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lobbyPlayers.count
    }
    
    /*
     Set and return cell for position at indexPath.
     */
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = lobbyPlayersCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LobbyPlayersCollectionViewCell
        let scoreFormatter = NumberFormatter()
        scoreFormatter.numberStyle = NumberFormatter.Style.decimal
        
        //Making the avatarImageView/images of the players rounded like a circle
        cell.avatarImageView.layer.masksToBounds = true
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width/2
        
        cell.avatarImageView.image = lobbyPlayers[indexPath.row].profilePic
        cell.usernameLabel.text = lobbyPlayers[indexPath.row].userName
        cell.scoreLabel.text = scoreFormatter.string(from: lobbyPlayers[indexPath.row].totalPoints! as NSNumber)
        return cell
    }
    
    /*
     Select download function based on quizMode.
     */
    
    func download(){
        if (self.quizMode == .Standard){
            self.downloadStandardQuiz()
        }
        else {
            self.downloadQuiz()
        }
    }
    
    /*
     Observe changes to standard game start condition.
     */
    
    func checkStandardGameStart(completion:(() -> Void)?){
        checkGameStartRef = Database.database().reference(withPath: "game/\(gameKey!)/started")
        checkGameStartHandle = checkGameStartRef.observe(.value, with: { snapshot in
            self.checkGameStartSet = true
            
            if let hasStarted = snapshot.value as? Bool {
                if hasStarted {
                    if self.quizDownloaded {
                        self.startQuiz()
                    }
                    else{
                        self.removeListeners()
                        self.errorOccurred(title: "Quiz Already Started", message: "The quiz has already started. Download incomplete", completion: nil)
                    }
                }
                else {
                    completion?()
                }
            }
            else{
                self.errorOccurred(title: "Game Download Error", message: "Game data corrupted.", completion: nil)
            }
            
//            if let hasStarted = snapshot.value as? Bool, hasStarted {
//                if self.quizDownloaded {
//                    self.startQuiz()
//                }
//                else{
//                    self.removeListeners()
//                    self.errorOccurred(title: "Quiz Already Started", message: "The quiz has already started. Download incomplete", completion: nil)
//                }
//            }
//            else{
//                completion?()
//            }
        })
    }
    
    /*
     Observe changes to indicators for head to head game cancellation, acceptance by invitee, and readiness of opponent.
     */
    
    func checkHeadToHeadGameStatus(){
        print("game key" + gameKey!)
        checkHeadToHeadGameStatusRef = Database.database().reference().child("head-to-head-game").child(gameKey!)
        checkHeadToHeadGameStatusHandle = checkHeadToHeadGameStatusRef.observe(.value, with: { snapshot in
            self.checkHeadToHeadGameStatusSet = true
            
            if !self.lobbyDone {
                if snapshot.childSnapshot(forPath: "quiz").value is NSNull {
                    //cancelled
                    print("Head to Head game cancelled in lobby")
                    self.deleteDBHeadToHeadGame()
                    self.errorOccurred(title: "Head to Head Game Cancelled", message: "Head to head game against \(String(describing: self.headToHeadOpponent.userName!)) cancelled.", completion: nil)
                }
                else{
                    if (snapshot.childSnapshot(forPath: "decided").value as! Bool) {
                        if (snapshot.childSnapshot(forPath: "accepted").value as! Bool) {
                            if !self.headToHeadAccepted && !self.lobbyDone{
                                //acceptance
                                self.headToHeadAccepted = true
                                print("Head to head game accepted")
                                self.statusLabel.text = self.headToHeadAcceptedString
                            }
                        }
                        else if !self.lobbyDone {
                            self.deleteDBHeadToHeadData()
                            print("Head to Head invitation declined in lobby")
                            self.errorOccurred(title: "Invitation Declined", message: "Head to head game has been declined.", completion: nil)
                        }
                    }
                    
                    if snapshot.childSnapshot(forPath: "inviter").childSnapshot(forPath: "ready").value! as! Bool {
                        if snapshot.childSnapshot(forPath: "invitee").childSnapshot(forPath: "ready").value! as! Bool {
                            if !self.lobbyDone {
                                //readiness
                                print("starting game")
                                self.startQuiz()
                            }
                        }
                    }
                }
            }
        })
    }
    
    /*
     Deinitialize QuizLobbyVC.
     */
    
    deinit {
        quiz = nil
        gameKey = nil
        print("-------->Deallocating quiz data")
    }
    
    /*
     Download quiz data for a standard game. Find matching leaderboard object. Perform downloadStudents after quiz download is finished.
     */
    
    func downloadStandardQuiz(){
        checkStandardGameStart(completion: {
            print("Finding leaderboard")
            let inGameLeaderboardsRef = Database.database().reference(withPath: "inGameLeaderboards")
            inGameLeaderboardsRef.observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    if (child.childSnapshot(forPath: "game").value as! String) == self.gameKey! {
                        self.leaderboardKey = child.key
                        break
                    }
                }
                //leaderboard not found
                if self.leaderboardKey == nil {
                    let inGameLeaderboardRef = inGameLeaderboardsRef.child(self.gameKey!)
                    inGameLeaderboardRef.child("game").setValue(self.gameKey!)
                    self.leaderboardKey = inGameLeaderboardRef.key
                }
            })
            print("downloading standard quiz")
            _ = Quiz(key: self.quizKey!) { theQuiz in
                if theQuiz.complete {
                    self.quiz = theQuiz
                    print("downloading students")
                    self.downloadStudents()
                }
                else{
                    self.errorOccurred(title: "Quiz Download Error", message: "Quiz data corrupted.", completion: nil)
                }
            }
        })
    }
    
    /*
     Download quiz data for non-standard game. Find matching leaderboard object for head to head game. Indicate user is ready for head to head to start through
     head to head game object in database.
     */
    
    func downloadQuiz(){
        _ = Quiz(key: quizKey!) { quiz in
            if quiz.complete {
                self.quiz = quiz
                if self.quizMode == .HeadToHead {
                    self.checkHeadToHeadGameStatus()
                    let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(self.gameKey!)
                    let inGameLeaderboardsRef = Database.database().reference(withPath: "inGameLeaderboards")
                    inGameLeaderboardsRef.observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                        for child in snapshot.children.allObjects as! [DataSnapshot] {
                            if (child.childSnapshot(forPath: "game").value as! String) == self.gameKey! {
                                self.leaderboardKey = child.key
                                inGameLeaderboardsRef.child(child.key).child("students").observeSingleEvent(of: .value, with: { snapshot in
                                    for child in snapshot.children.allObjects as! [DataSnapshot] {
                                        if (child.childSnapshot(forPath: "studentKey").value as! String) == currentUserID {
                                            self.userInLeaderboardKey = child.key
                                            self.loadingQuizComplete()
                                            if !self.lobbyDone && !self.headToHeadReady {
                                                if self.isInvitee {
                                                    headToHeadGameRef.child("invitee").child("ready").setValue(true)
                                                }
                                                else{
                                                    headToHeadGameRef.child("inviter").child("ready").setValue(true)
                                                }
                                                self.headToHeadReady = true
                                            }
                                            break
                                        }
                                    }
                                })
                                break
                            }
                        }
                    })
                }
                else if self.quizMode == .Solo {
                    self.loadingQuizComplete()
                }
            }
            else{
                self.errorOccurred(title: "Quiz Download Error", message: "Quiz data corrupted.", completion: {
                    if self.quizMode == .HeadToHead {
                        self.deleteDBHeadToHeadData()
                    }
                })
            }

            
            
//            self.quiz = quiz
//            if self.quizMode == .HeadToHead {
//                self.checkHeadToHeadGameStatus()
//                let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(self.gameKey!)
//                let inGameLeaderboardsRef = Database.database().reference(withPath: "inGameLeaderboards")
//                inGameLeaderboardsRef.observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
//                    for child in snapshot.children.allObjects as! [DataSnapshot] {
//                        if (child.childSnapshot(forPath: "game").value as! String) == self.gameKey! {
//                            self.leaderboardKey = child.key
//                            inGameLeaderboardsRef.child(child.key).child("students").observeSingleEvent(of: .value, with: { snapshot in
//                                for child in snapshot.children.allObjects as! [DataSnapshot] {
//                                    if (child.childSnapshot(forPath: "studentKey").value as! String) == currentUserID {
//                                        self.userInLeaderboardKey = child.key
//                                        self.loadingQuizComplete()
//                                        if !self.lobbyDone && !self.headToHeadReady {
//                                            if self.isInvitee {
//                                                headToHeadGameRef.child("invitee").child("ready").setValue(true)
//                                            }
//                                            else{
//                                                headToHeadGameRef.child("inviter").child("ready").setValue(true)
//                                            }
//                                            self.headToHeadReady = true
//                                        }
//                                        break
//                                    }
//                                }
//                            })
//                            break
//                        }
//                    }
//                })
//            }
//            else if self.quizMode == .Solo {
//                self.loadingQuizComplete()
//            }
        }
    }
    
    /*
     Download student data for standard game. Add user data to game and leaderboard objects in database.
     */
    
    func downloadStudents(){
        print("downloading students method")
        
        if leaderboardKey == nil {
            errorOccurred(title: "Leaderboard Connection Issue", message: "Could not find or connect to game leaderboard.", completion: nil)
        }
        
        Database.database().reference(withPath: "game/\(String(describing: self.gameKey!))/students/\(currentUserID)").setValue(true)
        
        let userInLeaderboardRef = Database.database().reference().child("inGameLeaderboards").child(leaderboardKey!).child("students").child(currentUserID)
        userInLeaderboardRef.child("studentKey").setValue(currentUserID)
        userInLeaderboardRef.child("studentScore").setValue(0)
        userInLeaderboardKey = userInLeaderboardRef.key
        
        self.downloadStudentsRef = Database.database().reference(withPath: "game/\(String(describing: self.gameKey!))/students")
        self.downloadStudentsHandle = self.downloadStudentsRef.observe(.value, with: { snapshot in
            self.downloadStudentsSet = true
            
            var gameStudentKeys:[String] = []
            let snapshotChildren = snapshot.children.allObjects as! [DataSnapshot]
            for child:DataSnapshot in snapshotChildren {
                gameStudentKeys.append(child.key)
            }
            
            if !self.lobbyQueue.isEmpty {
                var queueRemovalIndices:[Int] = []
                for i:Int in 0...self.lobbyQueue.count - 1 {
                    let studentInGameStudentKeys = gameStudentKeys.contains { element in
                        if element == self.lobbyQueue[i].databaseID {
                            return true
                        }
                        else{
                            return false
                        }
                    }
                    if !studentInGameStudentKeys {
                        queueRemovalIndices.append(i)
                    }
                }
                
                for index:Int in queueRemovalIndices {
                    self.lobbyQueue.remove(at: index)
                }
            }
            
            if !self.lobbyPlayers.isEmpty {
                var playersRemovalIndices:[Int] = []
                for i:Int in 0...self.lobbyPlayers.count - 1 {
                    let studentInGameStudentKeys = gameStudentKeys.contains { element in
                        if element == self.lobbyPlayers[i].databaseID {
                            return true
                        }
                        else{
                            return false
                        }
                    }
                    if !studentInGameStudentKeys {
                        playersRemovalIndices.append(i)
                    }
                }
                
                if !playersRemovalIndices.isEmpty {
                    for index:Int in playersRemovalIndices {
                        self.lobbyPlayers.remove(at: index)
                        print("Missing student removed from players")
                    }
                    self.lobbyPlayersCollectionView.reloadData()
                }
            }
            
            var studentCount:Int = 0
            for studentKey in gameStudentKeys{
                _ = Student(key: studentKey, addFriends: false) { (theStudent) in
                    studentCount += 1
                    if !theStudent.complete {
                        self.errorOccurred(title: "Player Download Error", message: "Player data corrupted.", completion: nil)
                    }
                    
                    if studentKey != currentUserID {
                        if !self.lobbyPlayers.contains(theStudent) && !self.lobbyQueue.contains(theStudent) {
                            self.lobbyQueue.append(theStudent)
                        }
                    }
                    if studentCount == gameStudentKeys.count {
                        self.addStudentToLobby()
                    }
                }
            }
        })
    }
    
    /*
     Add student in lobbyQueue to lobbyPlayers and reaload lobbyPlayersCollectionView data. The sleep is used to prevent reloadData from being called in rapid succession,
     which seems to cause lag.
     */
    
    func addStudentToLobby(){
        if !lobbyQueue.isEmpty{
            usleep(100000)
            print("Adding student to lobby")
            lobbyPlayers.append(lobbyQueue.popLast()!)
            lobbyPlayersCollectionView.reloadData()
            DispatchQueue.main.async(execute: {
                self.addStudentToLobby()
            })
        }
        else{
            loadingQuizComplete()
        }
    }
    
    /*
     Inform the user that the quiz download, and students download for standard games, is complete. If the quizMode is Solo, the game starts immediately.
     */
    
    func loadingQuizComplete(){
        if !quizDownloaded {
            print("Loading Quiz complete")
            quizDownloaded = true
            statusLabel.text = waitingString
            loadingIndicatorView.stopAnimating()
            if quizMode == .Solo {
                startQuiz()
            }
        }
    }
    
    /*
     Transition from QuizLobbyVC to QuizActivityVC. Set relevent values in QuizActivityVC.
     */
    
    func startQuiz(){
        print("start quiz method")
        if !lobbyDone {
            print("quiz not started")
            lobbyDone = true
            removeListeners()
            let destinationVC : QuizActivityVC = storyboard?.instantiateViewController(withIdentifier: "quiz_act") as! QuizActivityVC
            destinationVC.currQuiz = quiz
            destinationVC.quizLobbyRef = self
            
            switch quizMode! {
                case .Standard:
                    print("standard")
                    destinationVC.quizMode = QuizMode.Standard
                    destinationVC.gameKey = gameKey
                    destinationVC.inGameLeaderboardKey = leaderboardKey!
                    destinationVC.userInGameLeaderboardObjectKey = userInLeaderboardKey!
                    lobbyPlayers.append(currentGlobalStudent)
                    destinationVC.allUsers = lobbyPlayers
                    break
                case .HeadToHead:
                    print("head to head")
                    destinationVC.quizMode = QuizMode.HeadToHead
                    destinationVC.gameKey = gameKey
                    destinationVC.inGameLeaderboardKey = leaderboardKey!
                    destinationVC.userInGameLeaderboardObjectKey = userInLeaderboardKey!
                    destinationVC.allUsers = [currentGlobalStudent, headToHeadOpponent]
                    destinationVC.headToHeadOpponent = headToHeadOpponent
                    destinationVC.isInvitee = isInvitee
                    break
                case .Solo:
                    print("solo")
                    destinationVC.quizMode = QuizMode.Solo
                    break
            }

            print("presenting destination")
            self.present(destinationVC, animated: false, completion: nil)
        }
    }
    
    /*
     Display an alert with an error message to the user. Changes busy status to false. Dismiss view.
     */
    
    func errorOccurred(title:String, message:String, completion:(() -> Void)?){
        prepLobbyExit()
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
            globalBusy = false
            let userHeadToHeadRequestReference = Database.database().reference().child("student").child(currentUserID)
            userHeadToHeadRequestReference.child("headtoheadgamerequest").removeValue()
            self.dismiss(animated: false, completion: nil)
            completion?()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     Test function for immediately starting quiz.
     */
    @IBAction func tempQuizActivityPressed(_ sender: Any) {
        startQuiz()
    }
    
    /*
     Test function for triggering errorOccurred.
     */
    
    @IBAction func tempBckPressed(_ sender: Any) {
        errorOccurred(title: "Error Test", message: "This is what should happen when an error occurs in the Lobby.", completion: nil)
    }
    
    /*
     Prepare to exiting lobby. Dismiss view.
     */
    
    @IBAction func backButtonPressed(_ sender: Any) {
        prepLobbyExit()
        self.dismiss(animated: false, completion: nil)
    }
    
    /*
     Remove relevent database connections and values depending on quizMode.
     */
    
    func prepLobbyExit(){
        lobbyDone = true
        removeListeners()
        
        switch quizMode! {
            case .Standard:
                deleteDBStandardData()
                break
            case .HeadToHead:
                deleteDBHeadToHeadData()
                break
            case .Solo:
                break
        }
    }
    
    /*
     Remove set database observers.
     */
    
    func removeListeners(){
        if quizMode != nil {
            switch quizMode! {
                case .Standard:
                    if checkGameStartSet {
                        checkGameStartRef.removeObserver(withHandle: checkGameStartHandle)
                    }
                    if downloadStudentsSet {
                        downloadStudentsRef.removeObserver(withHandle: downloadStudentsHandle)
                    }
                    break
                case .HeadToHead:
                    if checkHeadToHeadGameStatusSet {
                        checkHeadToHeadGameStatusRef.removeObserver(withHandle: checkHeadToHeadGameStatusHandle)
                    }
                    break
                case .Solo:
                    break
            }
        }
    }
    
    /*
     Remove user data from standard game objects in database.
     */
    
    func deleteDBStandardData(){
        if leaderboardKey != nil && userInLeaderboardKey != nil {
            Database.database().reference().child("game").child(gameKey!).child("students").child(currentUserID).removeValue()
            Database.database().reference().child("inGameLeaderboards").child(leaderboardKey!).child("students").child(userInLeaderboardKey!).removeValue()
        }
        
//        Database.database().reference().child("game").child(gameKey!).child("students").child(currentUserID).removeValue()
//        Database.database().reference().child("inGameLeaderboards").child(leaderboardKey!).child("students").child(userInLeaderboardKey!).removeValue()
    }
    
    /*
     Delete game object for head to head game.
     */
    
    func deleteDBHeadToHeadGame(){
        let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(gameKey!)
        headToHeadGameRef.removeValue()
    }
    
    /*
     Delete all relevent objects for head to head game. 
     */
    
    func deleteDBHeadToHeadData(){
        deleteDBHeadToHeadGame()
        
        if headToHeadOpponent != nil {
            let opponentHeadToHeadRequestRef = Database.database().reference().child("student/\((String(describing: headToHeadOpponent.databaseID!)))/headtoheadgamerequest")
            opponentHeadToHeadRequestRef.removeValue()
        }
        
//        let opponentHeadToHeadRequestRef = Database.database().reference().child("student/\((String(describing: headToHeadOpponent.databaseID!)))/headtoheadgamerequest")
//        opponentHeadToHeadRequestRef.removeValue()
        
        let userHeadToHeadRequestRef = Database.database().reference().child("student/\((String(describing: currentUserID)))/headtoheadgamerequest")
        userHeadToHeadRequestRef.removeValue()
        
        let inGameLeaderboardsRef = Database.database().reference(withPath: "inGameLeaderboards")
        inGameLeaderboardsRef.observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if ((child.value as! [String:AnyObject])["game"] as! String) == self.gameKey {
                    let inGameLeaderboardRef = inGameLeaderboardsRef.child(child.key)
                    inGameLeaderboardRef.removeValue()
                }
            }
        })
    }
}
