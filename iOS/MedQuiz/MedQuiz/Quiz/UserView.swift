//
//  UserView.swift
//  
//
//  Created by Harnack, Paul (Student) on 2/26/18.
//

import UIKit

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView(){
        Bundle.main.loadNibNamed("UserView", owner: self, options: nil)
        addSubviews()
    }
    
    func addSubviews(){
        addSubview(viewMain)
        viewMain.frame = self.bounds
        viewMain.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setBackgroundColor(color:String){
        self.nonUserBg = color
        viewBG.backgroundColor = UIColor.hexStringToUIColor(hex: color)
    }
    
    func setBackgroundColor(color:UIColor){
        viewMain.backgroundColor = color
    }

    func updateView(student:Student, position:Int){
        self.currStudent = student
        displayUsername(username: student.userName!)
        displayPosition(position: position)
    }
    func updateView(student:Student, position:Int, score:Int){
        self.currStudent = student
        displayUsername(username: student.userName!)
        displayPosition(position: position)
        updateScore(score: score)
    }


    func displayUsername(username:String){
        lab_username.text = username
    }

    func displayPosition(position:Int){
        self.position = position
        lab_position.text = String.ordinalNumberFormat(number: position)
    }
    
    func updateScore(score: Int){
        overallScore += score
        scoreLabel.text = String(score)
    }
    func reupdate(){
        updateView(student: self.currStudent, position: self.position, score: self.overallScore)
    }
    
    func removeViews(){
        viewMain.removeFromSuperview()
        lab_position.removeFromSuperview()
        lab_username.removeFromSuperview()
        iv_profile.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        viewBG.removeFromSuperview()
    }
    
    func convertToCurrUser(){
        removeViews()
        Bundle.main.loadNibNamed("CurrUserView", owner: self, options: nil)
        addSubviews()
        viewBG.backgroundColor = UIColor.hexStringToUIColor(hex: "FFE483")
        reupdate()
    }
    func convertToOtherUser(){
        removeViews()
        Bundle.main.loadNibNamed("UserView", owner: self, options: nil)
        addSubviews()
        self.setBackgroundColor(color: self.nonUserBg)
        reupdate()
    }

}
