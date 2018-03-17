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
    
    @IBOutlet weak var lobbyPlayersCollectionView: UICollectionView!
    
//    struct LobbyPlayer{
//        var avatar: UIImage!
//        var username: String!
//        var score: String!
//    }
    
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
        lobbyPlayersCollectionView.showsVerticalScrollIndicator = false
        
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loadingIndicatorView.transform = CGAffineTransform.init(scaleX: loadingIndicatorViewScale, y: loadingIndicatorViewScale)
        loadingIndicatorView.startAnimating()
        loadingIndicatorView.color = loadingIndicatorViewColor
        
        statusLabel.text = loadingString

        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, !connected {
                self.errorOccured(title: "Connection Error", message: "Connection to database lost.")
            }
        })
        
        GameModel.WhereAndKeepObserving(child: GameModel.GAME_PIN, equals: gamePin) { (gamesFound) in
            if(gamesFound.isEmpty){
                self.errorOccured(title: "Quiz Not Found", message: "Quiz for supplied pin not found through query.")
            }
            
            let theGame = gamesFound[0]
            
            QuizModel.From(key: theGame.quizKey!, completion: { (aQuiz) in
                //self.gameQuiz = Quiz(aQuiz)
            })
            
            for studentModel:StudentModel in theGame.gameStudents{
                StudentModel.FromAndKeepObserving(key: studentModel.key, completion: { (aStudent) in
                    //self.lobbyPlayers.append(Student(studentModel: aStudent))
                })
                self.lobbyPlayersCollectionView.reloadData()
            }
        }
        self.loadingQuizComplete()
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
        cell.avatarImageView.image = UIImage(named: lobbyPlayers[indexPath.row].profilePic)
        cell.usernameLabel.text = lobbyPlayers[indexPath.row].userName
        cell.scoreLabel.text = String(lobbyPlayers[indexPath.row].totalPoints)
        
        return cell
    }
    
    func addLobbyPlayer(lobbyPlayer:Student){
        lobbyPlayers.append(lobbyPlayer)
        lobbyPlayersCollectionView.reloadData()
    }
    
    func loadingQuizComplete(){
        print("Loading Quiz complete")
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
        self.dismiss(animated: false) {
        }
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
