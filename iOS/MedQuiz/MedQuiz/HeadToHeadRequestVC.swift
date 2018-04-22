//
//  HeadToHeadRequestVC.swift
//  MedQuiz
//
//  Created by Chad Johnson on 4/11/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

class HeadToHeadRequestVC: UIViewController {

    var headToHeadGameKey:String!
    var headToHeadQuizKey:String!
    var headToHeadQuizTitle:String!
    
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userUserNameLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var opponentAvatarImageView: UIImageView!
    @IBOutlet weak var opponentUserNameLabel: UILabel!
    @IBOutlet weak var opponentScoreLabel: UILabel!
    
    var opponent:Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HeadToHeadRequestVC loaded")
        
        setup()
        
        checkRequestStatus()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkRequestStatus(){
        let headToHeadGameRef = Database.database().reference().child("head-to-head-game/\(headToHeadGameKey)")
        headToHeadGameRef.observe(.value, with: { snapshot in
            if snapshot.value is NSNull {
                print("Head to Head game cancelled in request VC")
                let alert = UIAlertController(title:"Head to Head Game Cancelled", message:"Head to head game against \(String(describing: self.opponent.userName!)) cancelled.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { UIAlertAction in
                    self.dismiss(animated: false, completion: nil)
                })
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func hideButtonPressed(_ sender: Any) {
        print("Request hidden")
        let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(self.headToHeadGameKey!)
        headToHeadGameRef.child("decided").setValue(true)
        headToHeadGameRef.child("accepted").setValue(false)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
        print("Request accepted")
        let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(self.headToHeadGameKey!)
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
        self.present(quizLobbyVC, animated: false, completion: nil)
    }
    
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
