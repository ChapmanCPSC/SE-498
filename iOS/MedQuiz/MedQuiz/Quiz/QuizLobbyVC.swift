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
    
    var quiz:Quiz!
    
    var gamePin:String?
    var gameKey:String?
    var headToHeadGameKey:String?
    var quizKey:String?
    
    var quizDownloaded:Bool = false
    var quizCancelled:Bool = false
    var activityStarted:Bool = false
    
    //TODO: To be set by logging in and not be static as such
    var userStudentKey:String = "b29fks9mf9gh37fhh1h9814"
    var user:Student!
    
    @IBOutlet weak var lobbyPlayersCollectionView: UICollectionView!
    
    @IBOutlet weak var headToHeadUserAvatarImageView: UIImageView!
    @IBOutlet weak var headToHeadUserUserNameLabel: UILabel!
    @IBOutlet weak var headToHeadUserScoreLabel: UILabel!
    @IBOutlet weak var headToHeadOpponentAvatarImageView: UIImageView!
    @IBOutlet weak var headToHeadOpponentUserNameLabel: UILabel!
    @IBOutlet weak var headToHeadOpponentScoreLabel: UILabel!
    @IBOutlet weak var andLabel: UILabel!
    
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    let loadingIndicatorViewScale:CGFloat = 2.0
    let loadingIndicatorViewColor = UIColor.hexStringToUIColor(hex: "FFDF00")
    
    @IBOutlet weak var backButton: UIButton!
    
    var lobbyPlayers = [Student]()
    var lobbyQueue = [Student]()
    var headToHeadOpponent:Student!
    
    @IBOutlet weak var statusLabel: UILabel!
    var loadingString:String = "Loading Quiz"
    var waitingString:String!
    
    enum QuizMode{
        case Standard
        case HeadToHead
        case Solo
    }
    
    var quizMode:QuizMode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("quiz lobby")
        
        //Temporary, here just to get Student data for hardcoded user
        _ = Student(key: userStudentKey) {(theStudent) in
            self.user = theStudent
        }
        
        hideSidebar()
        statusLabel.text = loadingString
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loadingIndicatorView.transform = CGAffineTransform.init(scaleX: loadingIndicatorViewScale, y: loadingIndicatorViewScale)
        loadingIndicatorView.startAnimating()
        loadingIndicatorView.color = loadingIndicatorViewColor
        
        self.lobbyPlayersCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)

        if (quizMode == QuizMode.Standard){
            waitingString = "Waiting for other players..."
            lobbyPlayersCollectionView.isHidden = false
            
            lobbyPlayersCollectionView.delegate = self
            lobbyPlayersCollectionView.dataSource = self
            lobbyPlayersCollectionView.showsVerticalScrollIndicator = false

        }
        else if (quizMode == QuizMode.HeadToHead){
            waitingString = "Waiting for " + headToHeadOpponent.userName!
            
            headToHeadUserAvatarImageView.isHidden = false
            headToHeadUserUserNameLabel.isHidden = false
            headToHeadUserScoreLabel.isHidden = false
            headToHeadOpponentAvatarImageView.isHidden = false
            headToHeadOpponentUserNameLabel.isHidden = false
            headToHeadOpponentScoreLabel.isHidden = false
            andLabel.isHidden = false
            
//            headToHeadUserAvatarImageView.image = user.profilePic!
//            headToHeadUserUserNameLabel.text = user.userName!
//            headToHeadUserScoreLabel.text = String(describing: user.totalPoints!)
            headToHeadUserAvatarImageView.image = #imageLiteral(resourceName: "MedicGreen.png");
            headToHeadUserUserNameLabel.text = "tacobell292"
            headToHeadUserScoreLabel.text = String(describing: 2500)
            headToHeadOpponentAvatarImageView.image = headToHeadOpponent.profilePic!
            headToHeadOpponentUserNameLabel.text = headToHeadOpponent.userName!
            headToHeadOpponentScoreLabel.text = String(describing: headToHeadOpponent.totalPoints!)
        }
        else if (quizMode == QuizMode.Solo){
            waitingString = "Ready to start..."
        }
        
        download()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("quiz lobby appeared")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.lobbyPlayersCollectionView.removeObserver(self, forKeyPath: "contentSize")
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView, observedObject == self.lobbyPlayersCollectionView {
//            addStudentToLobby()
//            print("collection view reloaded")
        }
    }
    
    func download(){
        checkRequestStatus {
            self.checkConnection {
                if (self.quizMode == QuizMode.Standard){
                    self.downloadStandardQuiz {}
                }
                else {
                    self.downloadQuiz {}
                }
            }
        }
    }
    
    func checkConnection(completion: @escaping () -> Void){
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, !connected {
                self.errorOccurred(title: "Connection Error", message: "Connection to database lost.")
            }
            completion()
        })	
    }
    
    func checkGameStart(completion: @escaping () -> Void){
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
    
    func checkOpponentReady(){
        HeadToHeadGameModel.FromAndKeepObserving(key: headToHeadGameKey!) { (headToHeadGame) in
            if !self.quizCancelled && !self.activityStarted {
                if headToHeadGame.decided! {
                    if headToHeadGame.accepted! {
                        self.quizStarted()
                    }
                    else{
                        print("Head to Head invitation declined in lobby")
                        self.errorOccurred(title: "Invitation Declined", message: "Your opponent declined your game invitation.")
                    }
                }
            }
        }
    }
    
    func checkRequestStatus(completion: @escaping () -> Void){
        if quizMode == QuizMode.HeadToHead {
            StudentModel.FromAndKeepObserving(key: "b29fks9mf9gh37fhh1h9814") {friend in
                guard friend.headToHeadGameRequest != nil else{
                    if !self.activityStarted {
                        print("Head to Head game cancelled in lobby")
                        self.quizCancelled = true
                        self.errorOccurred(title: "Head to Head Game Cancelled", message: "Head to head game against \(String(describing: self.headToHeadOpponent.userName!)) cancelled.")
                        completion()
                    }
                    return
                }
            }
        }
        completion()
    }
    
    deinit {
        quiz = nil
        gamePin = nil
        gameKey = nil
        print("-------->Deallocating quiz data")
    }
    
    func downloadStandardQuiz(completion: @escaping () -> Void){
        GameModel.Where(child: GameModel.GAME_PIN, equals: self.gamePin) { (gamesFound) in
            let theGame = gamesFound[0]
            self.gameKey = theGame.key
            
            _ = Quiz(key: theGame.quizKey!) { theQuiz in
                self.quiz = theQuiz
                self.downloadStudents {
                    completion()
                }
            }
        }
    }
    
    func downloadQuiz(completion:@escaping () -> Void){
        _ = Quiz(key: quizKey!) { quiz in
            self.quiz = quiz
            self.loadingQuizComplete()
            
            if self.quizMode == QuizMode.HeadToHead {
                self.checkRequestStatus {
                    completion()
                }
            }
            else if self.quizMode == QuizMode.Solo {
                //TODO
                completion()
            }
        }
    }
    
    func downloadStudents(completion: @escaping () -> Void){
        GameModel.Where(child: GameModel.GAME_PIN, equals: self.gamePin) { (gamesFound) in            
            let userStudentRef = Database.database().reference(withPath: "game/\(gamesFound[0].key)/students").child(self.userStudentKey)
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
                        if studentKey != self.userStudentKey && !self.lobbyPlayers.contains(theStudent) && !self.lobbyQueue.contains(theStudent){
                            self.lobbyQueue.append(theStudent)
                            if studentCount == gameStudentKeys.count {
                                self.addStudentToLobby()
                                completion()
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
    
    func quizStarted(){
        //TODO: Probably dismiss this current view
        // and present a new one rather than perform a segue
        //performSegue(withIdentifier: "QuizActivitySegue", sender: nil)
        
        activityStarted = true
        
        performSegue(withIdentifier: "lobbyToActivity", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lobbyToActivity" {
            let destinationVC = segue.destination as! QuizActivityVC
            destinationVC.currQuiz = quiz
            destinationVC.user = user
            
            if (quizMode == QuizMode.Standard){
                destinationVC.quizMode = QuizMode.Standard
                destinationVC.gameKey = gameKey
                lobbyPlayers.append(user)
                destinationVC.allUsers = lobbyPlayers
            }
            else if (quizMode == QuizMode.HeadToHead){
                destinationVC.quizMode = QuizMode.HeadToHead
                destinationVC.headToHeadGameKey = headToHeadGameKey
                destinationVC.headToHeadOpponent = headToHeadOpponent
            }
            else if (quizMode == QuizMode.Solo){
                destinationVC.quizMode = QuizMode.Solo
            }
        }
    }
    
    func errorOccurred(title:String, message:String){
        print("Lobby error occurred")
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
            self.dismiss(animated: false, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func tempQuizActivityPressed(_ sender: Any) {
        quizStarted()
    }
    
    @IBAction func tempBckPressed(_ sender: Any) {
        errorOccurred(title: "Error Test", message: "This is what should happen when an error occurs in the Lobby.")
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if quizMode == QuizMode.Standard {
            //TODO
        }
        else if quizMode == QuizMode.HeadToHead {
            quizCancelled = true
            
            let opponentHeadToHeadRequestRef = Database.database().reference().child("student/\((String(describing: headToHeadOpponent.databaseID!)))/headtoheadgamerequest")
            opponentHeadToHeadRequestRef.removeValue()
            
            let userHeadToHeadRequestRef = Database.database().reference().child("student/\((String(describing: user.databaseID!)))/headtoheadgamerequest")
            userHeadToHeadRequestRef.removeValue()
            
            let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(headToHeadGameKey!)
            headToHeadGameRef.removeValue()
        }
        else if quizMode == QuizMode.Solo {
            //TODO
        }
    }
}
