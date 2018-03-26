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
    
    var gameQuiz:Quiz?
    var gamePin:String?
    
    var quizDownloaded:Bool = false
    
    var userStudentKey:String = "b29fks9mf9gh37fhh1h9814"
    
    @IBOutlet weak var lobbyPlayersCollectionView: UICollectionView!
    
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    let loadingIndicatorViewScale:CGFloat = 2.0
    let loadingIndicatorViewColor = UIColor.hexStringToUIColor(hex: "FFDF00")
    
    var lobbyPlayers = [Student]()  
    
    @IBOutlet weak var statusLabel: UILabel!
    var loadingString:String = "Loading Quiz"
    var waitingString:String = "Waiting for other players..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("quiz lobby")
        
        hideSidebar()
        
        lobbyPlayersCollectionView.delegate = self
        lobbyPlayersCollectionView.dataSource = self
        
        lobbyPlayersCollectionView.showsVerticalScrollIndicator = false
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loadingIndicatorView.transform = CGAffineTransform.init(scaleX: loadingIndicatorViewScale, y: loadingIndicatorViewScale)
        loadingIndicatorView.startAnimating()
        loadingIndicatorView.color = loadingIndicatorViewColor
        
        statusLabel.text = loadingString

        downloadGame()
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
    
    func downloadGame(){
        checkConnection {
            self.downloadQuiz(){
                self.downloadStudents(){
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
        gameQuiz = nil
        gamePin = nil
        print("-------->Deallocating quiz data")
    }
    
    func downloadQuiz(completion: @escaping () -> Void){
        GameModel.Where(child: GameModel.GAME_PIN, equals: self.gamePin) { (gamesFound) in
            let theGame = gamesFound[0]

            _ = Quiz(key: theGame.quizKey!) { theQuiz in
                self.gameQuiz = theQuiz
                completion()
            }
        }
    }
    
    func downloadStudents(completion: @escaping () -> Void){
        GameModel.WhereAndKeepObserving(child: GameModel.GAME_PIN, equals: self.gamePin) { (gamesFound) in
            let theGame = gamesFound[0]
            self.lobbyPlayers.removeAll()
            var gameStudentKeys:[String] = []

            for studentModel:StudentModel in theGame.gameStudents{
                gameStudentKeys.append(studentModel.key)
            }
            
            for studentKey in gameStudentKeys{
                _ = Student(key: studentKey) { (theStudent) in
                    if studentKey != self.userStudentKey{
                        self.lobbyPlayers.append(theStudent)
                        self.lobbyPlayersCollectionView.reloadData()
                    }
                }
            }

            let userStudentRef = Database.database().reference(withPath: "game/\(theGame.key)/students").child(self.userStudentKey)
            userStudentRef.setValue(true)
            
            completion()
        }
    }
    
    func loadingQuizComplete(){
        print("Loading Quiz complete")
        quizDownloaded = true
        statusLabel.text = waitingString
        loadingIndicatorView.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "QuizActivitySegue"){
            let destinationVC = segue.destination as! QuizActivityVC
            destinationVC.currQuiz = gameQuiz
        }
    }
    
    func quizStarted(){
        performSegue(withIdentifier: "QuizActivitySegue", sender: nil)
    }
    
    func errorOccurred(title:String, message:String){
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
            self.dismiss(animated: false, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
        
        //TODO: This will not be enough time to show alert to user
        // cause it will immediatly go back
        //self.performSegue(withIdentifier: "LobbyErrorSegue", sender: nil)
    }

    @IBAction func tempBckPressed(_ sender: Any) {
        errorOccurred(title: "Error Test", message: "This is what should happen when an error occurs in the Lobby.")
    }
    
    
}
