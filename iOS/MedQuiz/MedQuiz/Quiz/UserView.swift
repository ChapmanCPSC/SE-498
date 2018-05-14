//
//  UserView.swift
//  
//
//  Created by Harnack, Paul (Student) on 2/26/18.
//

import UIKit

/*
 UserView displays player information in the leaderboard.
 */

class UserView: UIView {

    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var lab_position: UILabel!
    @IBOutlet weak var lab_username: UILabel!
    @IBOutlet weak var iv_profile: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    var overallScore: Int = 0
    var currStudent:Student!
    var position:Int = 0
    var nonUserBg:String = "FFFFFF"
    var nonUserBgUIColor:UIColor = UIColor.white

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    /*
     Perform initial setup operations.
     */
    
    func setupView(){
        Bundle.main.loadNibNamed("UserView", owner: self, options: nil)
        addSubviews()
    }
    
    /*
     Add subviews to viewMain.
     */
    
    func addSubviews(){
        addSubview(viewMain)
        viewMain.frame = self.bounds
        viewMain.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    /*
     Set background color using provided string for hex conversion.
     */
    
    func setBackgroundColor(color:String){
        self.nonUserBg = color
        viewBG.backgroundColor = UIColor.hexStringToUIColor(hex: color)
    }
    
    /*
     Set background color using provided color..
     */
    
    func setBackgroundColor(color:UIColor){
        nonUserBgUIColor = color
        viewBG.backgroundColor = color
    }

    /*
     Display non-score info for new student.
     */
    
    func updateView(student:Student, position:Int){
        self.currStudent = student
        displayUsername(username: student.userName!)
        displayProfileImage(profileImage: student.profilePic!)
        displayPosition(position: position)
    }
    
    /*
     Display all info for new student.
     */
    
    func updateView(student:Student, position:Int, score:Int){
        self.currStudent = student
        displayUsername(username: student.userName!)
        displayProfileImage(profileImage: student.profilePic!)
        displayPosition(position: position)
        updateScore(score: score)
    }

    /*
     Change username label text using provided string.
     */
    
    func displayUsername(username:String){
        lab_username.text = username
    }
    
    /*
     Change profile image using provided image.
     */
    
    func displayProfileImage(profileImage:UIImage){
        iv_profile.image = profileImage
    }

    /*
     Change position label text using provided position int.
     */
    
    func displayPosition(position:Int){
        self.position = position
        lab_position.text = String.ordinalNumberFormat(number: position)
    }
    
    /*
     Change score label text using provided score int.
     */
    
    func updateScore(score: Int){
        overallScore = score
        scoreLabel.text = String(score)
    }
    
    /*
     Redisplay assigned values for visual components.
     */
    
    func reupdate(){
        updateView(student: self.currStudent, position: self.position, score: self.overallScore)
    }
    
    /*
     Remove all components from view.
     */
    
    func removeViews(){
        viewMain.removeFromSuperview()
        lab_position.removeFromSuperview()
        lab_username.removeFromSuperview()
        iv_profile.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        viewBG.removeFromSuperview()
    }
    
    /*
     Highlight view as belonging to the user.
     */
    
    func convertToCurrUser(){
        removeViews()
        Bundle.main.loadNibNamed("CurrUserView", owner: self, options: nil)
        addSubviews()
        viewBG.backgroundColor = OurColorHelper.pharmAppGameLeaderboardCurrentUser
        reupdate()
    }
    
    /*
     Set view as non-user user view.
     */
    
    func convertToOtherUser(){
        removeViews()
        Bundle.main.loadNibNamed("UserView", owner: self, options: nil)
        addSubviews()
        self.setBackgroundColor(color: self.nonUserBgUIColor)
        reupdate()
    }
}
