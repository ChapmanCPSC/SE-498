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

class QuizLobbyVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var headToHeadRequestRef:UIViewController!
    
    var quiz:Quiz!
    
    var gamePin:String?
    var gameKey:String?
    var quizKey:String!
    var quizStarted:Bool = false
    
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
    
    enum QuizMode{
        case Standard
        case HeadToHead
        case Solo
    }
    
    var quizMode:QuizMode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if quizKey != nil {
            print("quiz lobby")
            
            hideSidebar()
            statusLabel.text = loadingString
            loadingIndicatorView.hidesWhenStopped = true
            loadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            loadingIndicatorView.transform = CGAffineTransform.init(scaleX: loadingIndicatorViewScale, y: loadingIndicatorViewScale)
            loadingIndicatorView.startAnimating()
            loadingIndicatorView.color = loadingIndicatorViewColor
            
            switch quizMode! {
                
            case .Standard:
                waitingString = "Waiting for other players..."
                lobbyPlayersCollectionView.isHidden = false
                
                lobbyPlayersCollectionView.delegate = self
                lobbyPlayersCollectionView.dataSource = self
                lobbyPlayersCollectionView.showsVerticalScrollIndicator = false
                break
            case .HeadToHead:
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
                break
            case .Solo:
                waitingString = "Ready to start..."
                break
            }
            
            download()
        }
        else{
            print("quiz key in lobby not set")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        print("quiz lobby appeared")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideSidebar(){
        self.splitViewController?.preferredDisplayMode = .primaryHidden
        // TODO Should be switched back to true after finishing quiz?
        self.splitViewController?.presentsWithGesture = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lobbyPlayers.count
    }
    
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
    
    func download(){
        self.checkConnection {
            if (self.quizMode == QuizMode.Standard){
                self.downloadStandardQuiz()
            }
            else {
                self.downloadQuiz()
            }
        }
    }
    
    func checkConnection(completion: @escaping () -> Void){
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, !connected {
                self.errorOccurred(title: "You have lost connection to the database", message: "Check your internet connection.")
            }
            completion()
        })	
    }
    
    func checkStandardGameStart(completion: @escaping () -> Void){
//        let gameStartedRef = Database.database().reference(withPath: "game/\(gameModel.key)/hasstarted")
//        gameStartedRef.observe(.value, with: { snapshot in
//            if let hasStarted = snapshot.value as? Bool, hasStarted {
//                if self.quizDownloaded{
//                    self.quizStarted()
//                }
//                else{
//                    self.errorOccurred(title: "Download Not Finished", message: "Quiz started before download could be finished.")
//                }
//            }
//            completion()
//        })
        
//        GameModel.WhereAndKeepObserving(child: GameModel.GAME_PIN, equals: self.gamePin) { (gamesFound) in
//            let theGame = gamesFound[0]
//
//            if let hasStarted = theGame.hasstarted, hasStarted {
//                if self.quizDownloaded {
//                    self.quizStarted()
//                }
//                else{
//                    self.errorOccurred(title: "Download Not Finished", message: "Quiz started befire download could be finished.")
//                }
//            }
//            completion()
//        }
    }
    
    func checkHeadToHeadGameStatus(completion: @escaping () -> Void){
        print("game key" + gameKey!)
        let headToHeadGameRef = Database.database().reference().child("head-to-head-game/\(gameKey!)")
        headToHeadGameRef.observe(.value, with: { snapshot in
            if !self.quizStarted {
                if snapshot.value! is NSNull {
                    //cancelled
                    print("Head to Head game cancelled in lobby")
                    self.errorOccurred(title: "Head to Head Game Cancelled", message: "Head to head game against \(String(describing: self.headToHeadOpponent.userName!)) cancelled.")
                }
                    
                else if ((snapshot.value as! [String:AnyObject])["decided"] as! Bool) {
                    if ((snapshot.value as! [String:AnyObject])["accepted"] as! Bool) {
                        if !self.headToHeadAccepted {
                            //acceptance
                            self.headToHeadAccepted = true
                            print("Head to head game accepted")
                            self.statusLabel.text = self.headToHeadAcceptedString
                        }
                    }
                    else{
                        self.deleteDBHeadToHeadData()
                        print("Head to Head invitation declined in lobby")
                        self.errorOccurred(title: "Invitation Declined", message: "Head to head game has been declined.")
                    }
                }
            }
            completion()
        })
    }
    
    //readiness
    func checkHeadToHeadReady(completion: @escaping () -> Void){
        let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(gameKey!)
        headToHeadGameRef.observe(.value, with: {(snapshot) in
            if !(snapshot.value is NSNull) && !self.quizStarted {
                if snapshot.childSnapshot(forPath: "inviter").childSnapshot(forPath: "ready").value! as! Bool {
                    if snapshot.childSnapshot(forPath: "invitee").childSnapshot(forPath: "ready").value! as! Bool {
                        self.startQuiz()
                    }
                }
            }
            completion()
        })
    }
    
    deinit {
        quiz = nil
        gamePin = nil
        gameKey = nil
        print("-------->Deallocating quiz data")
    }
    
    func downloadStandardQuiz(){
        print("downloading standard quiz")
        GameModel.Where(child: GameModel.GAME_PIN, equals: self.gamePin) { (gamesFound) in
            let theGame = gamesFound[0]
            self.gameKey = theGame.key
            
            _ = Quiz(key: theGame.quizKey!) { theQuiz in
                self.quiz = theQuiz
                print("downloading students")
                self.downloadStudents()
                print("done downloading students")
            }
        }
    }
    
    func downloadQuiz(){
        _ = Quiz(key: quizKey!) { quiz in
            self.quiz = quiz
            self.loadingQuizComplete()
            
            if self.quizMode == QuizMode.HeadToHead {
                let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(self.gameKey!)
                self.checkHeadToHeadGameStatus {
                    self.checkHeadToHeadReady {
                        if self.isInvitee {
                            headToHeadGameRef.child("invitee").child("ready").setValue(true)
                        }
                        else{
                            headToHeadGameRef.child("inviter").child("ready").setValue(true)
                        }
                    }
                }
            }
            else if self.quizMode == QuizMode.Solo {
                //TODO
            }
        }
    }
    
    func downloadStudents(){
        print("downloading students method")
        GameModel.Where(child: GameModel.GAME_PIN, equals: self.gamePin) { (gamesFound) in            
            let userStudentRef = Database.database().reference(withPath: "game/\(gamesFound[0].key)/students").child(currentUserID)
            userStudentRef.setValue(true)
            
            GameModel.WhereAndKeepObserving(child: GameModel.GAME_PIN, equals: self.gamePin) { (gamesFound) in
                let theGame = gamesFound[0]
                var gameStudentKeys:[String] = []
                
                for studentModel:StudentModel in theGame.gameStudents{
                    gameStudentKeys.append(studentModel.key)
                }
                
                var studentCount:Int = 0
                for studentKey in gameStudentKeys{
                    _ = Student(key: studentKey) { (theStudent) in
                        studentCount += 1
                        if studentKey != currentUserID && !self.lobbyPlayers.contains(theStudent) && !self.lobbyQueue.contains(theStudent){
                            self.lobbyQueue.append(theStudent)
                            if studentCount == gameStudentKeys.count {
                                self.addStudentToLobby()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addStudentToLobby(){
        if !lobbyQueue.isEmpty{
            usleep(100000)
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
    
    func loadingQuizComplete(){
        if !quizDownloaded {
            print("Loading Quiz complete")
            quizDownloaded = true
            statusLabel.text = waitingString
            loadingIndicatorView.stopAnimating()
        }
    }
    
    func startQuiz(){        
        if !quizStarted {
            quizStarted = true
            let destinationVC : QuizActivityVC = storyboard?.instantiateViewController(withIdentifier: "quiz_act") as! QuizActivityVC
            destinationVC.currQuiz = quiz
            destinationVC.quizLobbyRef = self
            
            switch quizMode! {
            case .Standard:
                destinationVC.quizMode = QuizMode.Standard
                destinationVC.gameKey = gameKey
                lobbyPlayers.append(currentGlobalStudent)
                destinationVC.allUsers = lobbyPlayers
                break
            case .HeadToHead:
                destinationVC.quizMode = QuizMode.HeadToHead
                destinationVC.gameKey = gameKey
                destinationVC.allUsers = [currentGlobalStudent, headToHeadOpponent]
                destinationVC.headToHeadOpponent = headToHeadOpponent
                destinationVC.isInvitee = isInvitee
                break
            case .Solo:
                destinationVC.quizMode = QuizMode.Solo
                break
            }
            
            destinationVC.onDoneBlock = { result in
                self.dismiss(animated: false, completion: nil)
            }
            
            self.present(destinationVC, animated: false, completion: nil)
        }
    }
    
    func errorOccurred(title:String, message:String){
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
            self.dismiss(animated: false, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tempQuizActivityPressed(_ sender: Any) {
        startQuiz()
    }
    
    @IBAction func tempBckPressed(_ sender: Any) {
        errorOccurred(title: "Error Test", message: "This is what should happen when an error occurs in the Lobby.")
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        switch quizMode! {
        case .Standard:
            //TODO
            break
        case .HeadToHead:
            deleteDBHeadToHeadData()
            break
        case .Solo: 
            //TODO
            break
        }
    }
    
    func deleteDBHeadToHeadData(){
        let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(gameKey!)
        headToHeadGameRef.removeValue()
        
        let opponentHeadToHeadRequestRef = Database.database().reference().child("student/\((String(describing: headToHeadOpponent.databaseID!)))/headtoheadgamerequest")
        opponentHeadToHeadRequestRef.removeValue()
        
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
