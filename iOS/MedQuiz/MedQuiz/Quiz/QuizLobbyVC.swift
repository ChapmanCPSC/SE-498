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
    
    var quiz:Quiz?
    
    var gamePin:String?
    var gameKey:String?
    var quizKey:String?
    
    var quizDownloaded:Bool = false
    
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
    
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    let loadingIndicatorViewScale:CGFloat = 2.0
    let loadingIndicatorViewColor = UIColor.hexStringToUIColor(hex: "FFDF00")
    
    var lobbyPlayers = [Student]()
    var headToHeadOpponent:Student?
    
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

        if (quizMode == QuizMode.Standard){
            waitingString = "Waiting for other players..."
            lobbyPlayersCollectionView.isHidden = false
            
            lobbyPlayersCollectionView.delegate = self
            lobbyPlayersCollectionView.dataSource = self
            
            lobbyPlayersCollectionView.showsVerticalScrollIndicator = false
            loadingIndicatorView.hidesWhenStopped = true
            loadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            loadingIndicatorView.transform = CGAffineTransform.init(scaleX: loadingIndicatorViewScale, y: loadingIndicatorViewScale)
            loadingIndicatorView.startAnimating()
            loadingIndicatorView.color = loadingIndicatorViewColor
        }
        else if (quizMode == QuizMode.HeadToHead){
            waitingString = "Waiting for " + (headToHeadOpponent?.userName)!
            
            headToHeadUserAvatarImageView.isHidden = false
            headToHeadUserUserNameLabel.isHidden = false
            headToHeadUserScoreLabel.isHidden = false
            headToHeadOpponentAvatarImageView.isHidden = false
            headToHeadOpponentUserNameLabel.isHidden = false
            headToHeadOpponentScoreLabel.isHidden = false
        }
        else if (quizMode == QuizMode.Solo){
            waitingString = "Ready to start..."
        }
        
        download()
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
        checkConnection {
            if (self.quizMode == QuizMode.Standard){
                self.downloadGameQuiz {
                    self.downloadStudents {
                        self.loadingQuizComplete()
                    }
                }
            }
            else {
                self.downloadQuiz {
                    self.loadingQuizComplete()
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
    
    deinit {
        quiz = nil
        gamePin = nil
        gameKey = nil
        print("-------->Deallocating quiz data")
    }
    
    func downloadGameQuiz(completion: @escaping () -> Void){
        GameModel.Where(child: GameModel.GAME_PIN, equals: self.gamePin) { (gamesFound) in
            let theGame = gamesFound[0]
            self.gameKey = theGame.key
            
            _ = Quiz(key: theGame.quizKey!) { theQuiz in
                self.quiz = theQuiz
                completion()
            }
        }
    }
    
    func downloadQuiz(completion:@escaping () -> Void){
        _ = Quiz(key: quizKey!) { quiz in
            self.quiz = quiz
            completion()
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
                        if studentKey != self.userStudentKey && !self.lobbyPlayers.contains(theStudent){
                            self.lobbyPlayers.append(theStudent)
                            if studentCount == gameStudentKeys.count {
                                self.lobbyPlayersCollectionView.reloadData()
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadingQuizComplete(){
        print("Loading Quiz complete")
        quizDownloaded = true
        statusLabel.text = waitingString
        loadingIndicatorView.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO: Delete if not using segues anymore
        if(segue.identifier == "QuizActivitySegue"){
            let destinationVC = segue.destination as! QuizActivityVC
            destinationVC.currQuiz = quiz
            destinationVC.gameKey = gameKey
            destinationVC.user = user
            lobbyPlayers.append(user)
            destinationVC.allUsers = lobbyPlayers
        }
    }
    
    func quizStarted(){
        //TODO: Probably dismiss this current view
        // and present a new one rather than perform a segue
        //performSegue(withIdentifier: "QuizActivitySegue", sender: nil)
    }
    
    func errorOccurred(title:String, message:String){
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
            self.dismiss(animated: false, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func tempQuizActivityPressed(_ sender: Any) {
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "quiz_act") as! QuizActivityVC
        destinationVC.currQuiz = quiz
        destinationVC.gameKey = gameKey
        destinationVC.user = user
        lobbyPlayers.append(user)
        destinationVC.allUsers = lobbyPlayers
        
            self.dismiss(animated: false, completion: {
                mainQuizVC.present(destinationVC, animated: false) {
                print("hey")
                    
                }
            })
            
    }
    
    @IBAction func tempBckPressed(_ sender: Any) {
        errorOccurred(title: "Error Test", message: "This is what should happen when an error occurs in the Lobby.")
    }
    
    
}
