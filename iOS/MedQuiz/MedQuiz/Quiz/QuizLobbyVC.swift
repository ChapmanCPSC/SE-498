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
        cell.avatarImageView.image = lobbyPlayers[indexPath.row].profilePic
        cell.usernameLabel.text = lobbyPlayers[indexPath.row].userName
        cell.scoreLabel.text = String(describing: lobbyPlayers[indexPath.row].totalPoints)
        return cell
    }
    
    func addLobbyPlayer(lobbyPlayer:Student){
        lobbyPlayers.append(lobbyPlayer)
        lobbyPlayersCollectionView.reloadData()
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
                self.errorOccured(title: "Connection Error", message: "Connection to database lost.")
            }
            completion()
        })
    }
    
    func checkGameStart(gameModel:GameModel, completion: @escaping () -> Void){
        let gameStartedRef = Database.database().reference(withPath: "game/\(gameModel.key)/hasstarted")
        gameStartedRef.observe(.value, with: { snapshot in
            if let hasStarted = snapshot.value as? Bool, hasStarted {
                if self.quizDownloaded{
                    self.quizStarted()
                }
                else{
                    self.errorOccured(title: "Download Not Finished", message: "Quiz started before download could be finished.")
                }
            }
            completion()
        })
    }
    
    func downloadQuiz(completion: @escaping () -> Void){
        GameModel.Where(child: GameModel.GAME_PIN, equals: self.gamePin) { (gamesFound) in
            if(gamesFound.isEmpty){
                self.errorOccured(title: "Quiz Not Found", message: "Quiz for supplied pin not found through query.")
                completion()
            }
            else{
                let theGame = gamesFound[0]
                _ = Quiz(key: theGame.quizKey!) { theQuiz in
                    self.gameQuiz = theQuiz
                    completion()
                }
            }
        }
    }
    
    func downloadStudents(completion: @escaping () -> Void){
        GameModel.WhereAndKeepObserving(child: GameModel.GAME_PIN, equals: self.gamePin) { (gamesFound) in
            if(gamesFound.isEmpty){
                self.errorOccured(title: "Quiz Not Found", message: "Quiz for supplied pin not found through query.")
                completion()
            }
            else{
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
    
    func errorOccured(title:String, message:String){
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.performSegue(withIdentifier: "LobbyErrorSegue", sender: nil)
    }

    @IBAction func tempBckPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
