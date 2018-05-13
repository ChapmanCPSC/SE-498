//
//  QuizSummaryViewController.swift
//  MedQuiz
//
//  Created by Harnack, Paul (Student) on 3/17/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

/*
 QuizSummaryViewController displays QuizActivityVC results.
 */

class QuizSummaryViewController: UIViewController {

    @IBOutlet weak var iv_profilePic: UIImageView!
    @IBOutlet weak var lab_username: UILabel!
    @IBOutlet weak var lab_score: UILabel!
    @IBOutlet weak var lab_rank: UILabel!
    @IBOutlet weak var lab_earnedPoints: UILabel!
    @IBOutlet weak var lab_scoreDiff: UILabel!
    @IBOutlet weak var lab_questionsRight: UILabel!
    @IBOutlet weak var lab_questionsWrong: UILabel!
    
    @IBOutlet weak var summaryCard: UIView!
    @IBOutlet weak var summaryDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryCard.backgroundColor = OurColorHelper.pharmAppRed
        summaryDone.backgroundColor = OurColorHelper.pharmAppBlue
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Set busy status to false and dismiss view.
     */
    
    @IBAction func btn_donePressed(_ sender: Any) {
//        self.splitViewController?.preferredDisplayMode = .automatic
//        self.splitViewController?.presentsWithGesture = true
//        performSegue(withIdentifier: "summaryToHome", sender: nil)

        globalBusy = false
        let userHeadToHeadRequestReference = Database.database().reference().child("student").child(currentUserID)
        userHeadToHeadRequestReference.child("headtoheadgamerequest").removeValue()
        
        self.dismiss(animated: false) {
        }
    }
    
    /*
     Set username label text using provided string.
     */
    
    func setUsernameLabel(username:String){
        lab_username.text = username
    }
    
    /*
     Set profile image using provided image.
     */
    
    func setProfileImage(profileImage:UIImage){
        iv_profilePic.image = profileImage
    }
    
    /*
     Set rank label text using provided position int.
     */
    
    func setRankLabel(position:Int){
        let rank = String.ordinalNumberFormat(number: position)

        lab_rank.text = "You ranked \(rank)"
    }
    
    /*
     Set earned points label text using provided points int.
     */

    func setEarnedPointsLabel(points:Int){
        let earnedPoints = points > 0 ? "+\(points)" : "\(points)"
        lab_earnedPoints.text = "Earned \(earnedPoints) points"
    }

    /*
     Set score difference label text using provided startPoints and endPoints ints. changeWord depends on whether
     user gained or lost points.
     */
    
    func setScoreDiffLabel(startPoints:Int, endPoints:Int){
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedStart = formatter.string(from: NSNumber(value: startPoints))
        let formattedEnd = formatter.string(from: NSNumber(value: endPoints))
        let changeWord = endPoints - startPoints > 0 ? "up" : "down"

        lab_scoreDiff.text = "Score went \(changeWord) from \(formattedStart!) to \(formattedEnd!)"
    }

    /*
     Set questions right label text using provided int.
     */
    
    func setQuestionsRightLabel(questionsRight:Int){
        lab_questionsRight.text = "Got \(questionsRight) questions right"
    }
    
    /*
     Set questions wrong label text using provided int.
     */

    func setQuestionsWrongLabel(questionsWrong:Int){
        lab_questionsWrong.text = "Got \(questionsWrong) questions wrong"
    }
    
    /*
     Set total points label text using provided totalPoints int.
     */

    func setTotalPointsLabel(totalPoints:Int){
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedScore = formatter.string(from: NSNumber(value:totalPoints))
        lab_score.text = formattedScore
    }

    /*
     Testing function that assigned example values to components.
     */

    func setTempValues(){
        setRankLabel(position: 5)
        setEarnedPointsLabel(points: -400)
        setScoreDiffLabel(startPoints: 900, endPoints: 500)
        setQuestionsRightLabel(questionsRight: 10)
        setQuestionsWrongLabel(questionsWrong: 2)
        setTotalPointsLabel(totalPoints: 900)
    }
}
