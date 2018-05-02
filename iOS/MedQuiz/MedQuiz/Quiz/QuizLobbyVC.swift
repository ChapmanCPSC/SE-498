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
    
    var gameKey:String?
    var quizKey:String!
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
        if (self.quizMode == .Standard){
            self.downloadStandardQuiz()
        }
        else {
            self.downloadQuiz()
        }
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
    
    func checkHeadToHeadGameStatus(completion:(() -> Void)?){
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
            
            completion?()
        })
    }
    
    deinit {
        quiz = nil
        gameKey = nil
        print("-------->Deallocating quiz data")
    }
    
    func downloadStandardQuiz(){
        print("downloading standard quiz")
        _ = Quiz(key: quizKey!) { theQuiz in
            self.quiz = theQuiz
            print("downloading students")
            self.downloadStudents()
        }
    }
    
    func downloadQuiz(){
        _ = Quiz(key: quizKey!) { quiz in
            self.quiz = quiz
            self.loadingQuizComplete()
            
            if self.quizMode == QuizMode.HeadToHead {
                let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(self.gameKey!)
                self.checkHeadToHeadGameStatus(completion: {
                    if !self.lobbyDone && !self.headToHeadReady {
                        if self.isInvitee {
                            headToHeadGameRef.child("invitee").child("ready").setValue(true)
                        }
                        else{
                            headToHeadGameRef.child("inviter").child("ready").setValue(true)
                        }
                        self.headToHeadReady = true
                    }
                })
            }
        }
    }
    
    func downloadStudents(){
        print("downloading students method")
        self.downloadStudentsRef = Database.database().reference(withPath: "game/\(String(describing: self.gameKey!))/students")
        self.downloadStudentsHandle = self.downloadStudentsRef.observe(.value, with: { snapshot in
            self.downloadStudentsSet = true
            
            let userStudentRef = Database.database().reference(withPath: "game/\(String(describing: self.gameKey!))/students/\(currentUserID)")
            userStudentRef.setValue(true)
            
            var gameStudentKeys:[String] = []
            let snapshotChildren = snapshot.children.allObjects as! [DataSnapshot]
            for child:DataSnapshot in snapshotChildren {
                gameStudentKeys.append(child.key)
            }
            
            var studentCount:Int = 0
            for studentKey in gameStudentKeys{
                _ = Student(key: studentKey) { (theStudent) in
                    studentCount += 1
                    
                    print("Student #\(studentCount)")
                    
                    if studentKey != currentUserID && !self.lobbyPlayers.contains(theStudent) && !self.lobbyQueue.contains(theStudent){
                        self.lobbyQueue.append(theStudent)
                        print("For loop status: studentCount: \(studentCount), gameStudentKeys.count: \(gameStudentKeys.count)")
                    }
                    else{
                        print("Skipping student")
                        print("studentKey != currentUserID: \(studentKey != currentUserID)")
                        print("!self.lobbyPlayers.contains(theStudent): \(!self.lobbyPlayers.contains(theStudent))")
                        print("!self.lobbyQueue.contains(theStudent): \(!self.lobbyQueue.contains(theStudent))")
                    }
                    
                    if studentCount == gameStudentKeys.count {
                        print("Ready to start adding queued students to lobby")
                        self.addStudentToLobby()
                    }
                }
            }
        })
    }
    
    func addStudentToLobby(){
        print("Lobby queue empty in addStudentToLobby: \(lobbyQueue.isEmpty)")
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
            print("Initial student download complete")
            loadingQuizComplete()
        }
    }
    
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
                lobbyPlayers.append(currentGlobalStudent)
                destinationVC.allUsers = lobbyPlayers
                break
            case .HeadToHead:
                print("head to head")
                destinationVC.quizMode = QuizMode.HeadToHead
                destinationVC.gameKey = gameKey
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
    
    func errorOccurred(title:String, message:String, completion:(() -> Void)?){
        lobbyDone = true
        removeListeners()
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
            if self.quizMode == QuizMode.HeadToHead {
                globalHeadToHeadBusy = false
            }
            completion?()
            self.dismiss(animated: false, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tempQuizActivityPressed(_ sender: Any) {
        startQuiz()
    }
    
    @IBAction func tempBckPressed(_ sender: Any) {
        errorOccurred(title: "Error Test", message: "This is what should happen when an error occurs in the Lobby.", completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        lobbyDone = true
        removeListeners()
        
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
        self.dismiss(animated: false, completion: nil)
    }
    
    func removeListeners(){
        switch quizMode! {
        case .Standard:
            //checkGameStartRef.removeObserver(withHandle: checkGameStartHandle)
            
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
    
    func deleteDBHeadToHeadGame(){
        let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(gameKey!)
        headToHeadGameRef.removeValue()
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
