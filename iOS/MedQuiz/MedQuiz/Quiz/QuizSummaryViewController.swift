//
//  QuizSummaryViewController.swift
//  MedQuiz
//
//  Created by Harnack, Paul (Student) on 3/17/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

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
    
    @IBAction func btn_donePressed(_ sender: Any) {
//        self.splitViewController?.preferredDisplayMode = .automatic
//        self.splitViewController?.presentsWithGesture = true
//        performSegue(withIdentifier: "summaryToHome", sender: nil)

        globalBusy = false
        self.dismiss(animated: false) {
        }
    }
    
    func setUsernameLabel(username:String){
        lab_username.text = username
    }
    
    func setProfileImage(profileImage:UIImage){
        iv_profilePic.image = profileImage
    }
    
    func setRankLabel(position:Int){
        let rank = String.ordinalNumberFormat(number: position)

        lab_rank.text = "You ranked \(rank)"
    }

    func setEarnedPointsLabel(points:Int){
        let earnedPoints = points > 0 ? "+\(points)" : "\(points)"
        lab_earnedPoints.text = "Earned \(earnedPoints) points"
    }

    func setScoreDiffLabel(startPoints:Int, endPoints:Int){
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedStart = formatter.string(from: NSNumber(value: startPoints))
        let formattedEnd = formatter.string(from: NSNumber(value: endPoints))
        let changeWord = endPoints - startPoints > 0 ? "up" : "down"

        lab_scoreDiff.text = "Score went \(changeWord) from \(formattedStart!) to \(formattedEnd!)"
    }

    func setQuestionsRightLabel(questionsRight:Int){
        lab_questionsRight.text = "Got \(questionsRight) questions right"
    }

    func setQuestionsWrongLabel(questionsWrong:Int){
        lab_questionsWrong.text = "Got \(questionsWrong) questions wrong"
    }

    func setTotalPointsLabel(totalPoints:Int){
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedScore = formatter.string(from: NSNumber(value:totalPoints))
        lab_score.text = formattedScore
    }


    func setTempValues(){
        setRankLabel(position: 5)
        setEarnedPointsLabel(points: -400)
        setScoreDiffLabel(startPoints: 900, endPoints: 500)
        setQuestionsRightLabel(questionsRight: 10)
        setQuestionsWrongLabel(questionsWrong: 2)
        setTotalPointsLabel(totalPoints: 900)
    }
}
