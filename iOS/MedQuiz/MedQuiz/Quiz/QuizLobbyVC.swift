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

        //Testing quiz students retrieval in lobby
        // in this case we assume a student entered a pin: 8419
        //let testPin = "8419"
        print("Testing quiz students retrieval in lobby")
        GameModel.Where(child: GameModel.GAME_PIN, equals: gamePin) { (gamesFound) in
            //this query returns an array of games, I called it "gamesFound"
            // since there can only be one game with that game pin
            // i can just assume the game is the first one in the array "gamesFound"
            // returned.
            let theGame = gamesFound[0]
            //I then traverse through the students snapshot for that game and
            // traverse through the keys in that snapshot
            let theGameStudentsSnapshot = theGame.gameStudents
            for studentSnapshot in theGameStudentsSnapshot{
                //Querying for the students in the game and querying
                // and printing their name.
                //You can see how this can be used to populate an
                // array of students joining the game
                StudentModel.From(key: studentSnapshot.key, completion: { (aStudent) in
                    //print((aStudent.snapshot.value as! [String:AnyObject])["username"] as! String)
                    print(aStudent.studentUsername!)
                })
            }

        }
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
        statusLabel.text = waitingString
        loadingIndicatorView.stopAnimating()
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
