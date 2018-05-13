//
//  QuizSelectMode.swift
//  MedQuiz
//
//  Created by Omar Sherief on 4/4/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

/*
 QuizSelectModeVC transitions to HeadToHeadVC is head to head game is selected or to QuizLobbyVC if
 solo game is selected.
 */

class QuizSelectModeVC: UIViewController {

    var quizKey:String!
    
    @IBOutlet weak var leftCard: UIView!
    @IBOutlet weak var rightCard: UIView!
    
    /*
     Set card colors.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leftCard.backgroundColor = OurColorHelper.pharmAppRed
        rightCard.backgroundColor = OurColorHelper.pharmAppPurple
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Dismiss view.
     */
    
    @IBAction func exitPracticeModeSelect(_ sender: Any) {
        self.dismiss(animated: false) {
        }
    }
    
    /*
     Transition to HeadToHeadVC.
     */
    
    @IBAction func headToHeadButtonPressed(_ sender: Any) {
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "headToHead") as! HeadToHeadVC
        destinationVC.quizKey = quizKey
        present(destinationVC, animated: false, completion: nil)
    }
    
    /*
     Transition to lobby in Solo quizMode.
     */
    
    @IBAction func soloButtonPressed(_ sender: Any) {
        let userHeadToHeadRequestReference = Database.database().reference().child("student").child(currentUserID)
        userHeadToHeadRequestReference.child("headtoheadgamerequest").setValue("busy")
        globalBusy = true
        
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "quizLobbyVC") as! QuizLobbyVC
        destinationVC.quizKey = quizKey
        destinationVC.quizMode = QuizLobbyVC.QuizMode.Solo
        present(destinationVC, animated: false, completion: nil)
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
