//
//  HeadToHeadRequestVC.swift
//  MedQuiz
//
//  Created by Chad Johnson on 4/11/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

/*
 HeadToHeadRequestVC displays head to head game request information and allows the user to either accept or decline the request.
 */

class HeadToHeadRequestVC: UIViewController {

    var headToHeadGameKey:String!
    var headToHeadQuizKey:String!
    var headToHeadQuizTitle:String!
    
    var requestFinished:Bool = false
    
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userUserNameLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var opponentAvatarImageView: UIImageView!
    @IBOutlet weak var opponentUserNameLabel: UILabel!
    @IBOutlet weak var opponentScoreLabel: UILabel!
    
    var opponent:Student!
    
    var checkRequestRef:DatabaseReference!
    var checkRequestHandle:DatabaseHandle!
    var checkRequestSet = false
    
    /*
     Check attribute values. Setup components and check request status.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HeadToHeadRequestVC loaded")
        
        if headToHeadGameKey == nil || headToHeadQuizKey == nil || headToHeadQuizTitle == nil || opponent == nil {
            let alert = UIAlertController(title:"Info Download Error", message:"Head to Head game data in database not found or is corrupted.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
            })
            self.present(alert, animated: true, completion: nil)
        }
        else{
            setup()
            
            checkRequestStatus()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Observe chanes in head to head game object in database that indicate game cancellation by inviter.
     */
    
    func checkRequestStatus(){
        checkRequestRef = Database.database().reference().child("head-to-head-game").child(headToHeadGameKey!)
        checkRequestHandle = checkRequestRef.observe(.value, with: { snapshot in
            self.checkRequestSet = true
            if snapshot.value is NSNull && !self.requestFinished {
                self.requestFinished = true
                self.removeListeners()
                print("Head to Head game cancelled in request VC")
                let alert = UIAlertController(title:"Head to Head Game Cancelled", message:"Head to head game against \(String(describing: self.opponent.userName!)) cancelled.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
                    globalBusy = false
                    self.dismiss(animated: false, completion: nil)
                })
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    /*
     Remove database connections.
     */
    
    func removeListeners(){
        if checkRequestSet {
            checkRequestRef.removeObserver(withHandle: checkRequestHandle)
        }
    }
    
    /*
     Decline request. Set busy status to false and exit view.
     */
    
    @IBAction func hideButtonPressed(_ sender: Any) {
        self.requestFinished = true
        print("Request hidden")
        let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(headToHeadGameKey!)
        headToHeadGameRef.child("decided").setValue(true)
        headToHeadGameRef.child("accepted").setValue(false)
        removeListeners()
        globalBusy = false
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     Accept request. Transition to QuizLobbyVC.
     */
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
        self.requestFinished = true
        print("Request accepted")
        let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(headToHeadGameKey!)
        headToHeadGameRef.child("accepted").setValue(true)
        headToHeadGameRef.child("decided").setValue(true)
        let quizStoryboard = UIStoryboard(name: "Quiz", bundle: nil)
        let quizLobbyVC = quizStoryboard.instantiateViewController(withIdentifier: "quizLobbyVC") as! QuizLobbyVC
        quizLobbyVC.quizKey = headToHeadQuizKey
        quizLobbyVC.gameKey = headToHeadGameKey
        quizLobbyVC.headToHeadOpponent = opponent
        quizLobbyVC.quizMode = QuizLobbyVC.QuizMode.HeadToHead
        quizLobbyVC.isInvitee = true
        quizLobbyVC.headToHeadAccepted = true
        quizLobbyVC.headToHeadRequestRef = self
        removeListeners()
        globalBusy = true
        print("Presenting lobby from head to head request.")
        self.present(quizLobbyVC, animated: false, completion: nil)
        print("Lobby presented from head to head request.")
    }
    
    /*
     Set values for components.
     */
    
    func setup(){
        quizTitleLabel.text = headToHeadQuizTitle
        
        userAvatarImageView.image = globalProfileImage
        userUserNameLabel.text = globalUsername
        userScoreLabel.text = String(describing: globalHighscore)
        
        opponentAvatarImageView.image = opponent.profilePic
        opponentUserNameLabel.text = opponent.userName
        opponentScoreLabel.text = String(describing: opponent.totalPoints!)
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
