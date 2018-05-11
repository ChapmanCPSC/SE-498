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
        })
    }
    
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
    
    deinit {
        quiz = nil
        gameKey = nil
        print("-------->Deallocating quiz data")
    }
    
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
        }
    }
    
    func downloadStudents(){
        print("downloading students method")
        
        Database.database().reference(withPath: "game/\(String(describing: self.gameKey!))/students/\(currentUserID)").setValue(true)
        let userInLeaderboardRef = Database.database().reference().child("inGameLeaderboards").child(leaderboardKey!).child("students").childByAutoId()
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
                _ = Student(key: studentKey) { (theStudent) in
                    studentCount += 1
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
    
    func errorOccurred(title:String, message:String, completion:(() -> Void)?){
        lobbyDone = true
        removeListeners()
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
            let userHeadToHeadRequestReference = Database.database().reference().child("student").child(currentUserID)
            userHeadToHeadRequestReference.child("headtoheadgamerequest").removeValue()
            
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
        prepLobbyExit()
        self.dismiss(animated: false, completion: nil)
    }
    
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
            //TODO
            break
        }
    }
    
    func removeListeners(){
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
    
    func deleteDBStandardData(){
        Database.database().reference().child("game").child(gameKey!).child("students").child(currentUserID).removeValue()
        Database.database().reference().child("inGameLeaderboards").child(leaderboardKey!).child("students").child(userInLeaderboardKey!).removeValue()
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
