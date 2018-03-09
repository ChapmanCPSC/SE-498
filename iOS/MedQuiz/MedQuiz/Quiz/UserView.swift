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
    
    var overallScore: Int = 0
    var currStudent:StudentModel!

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
        viewMain.backgroundColor = UIColor.hexStringToUIColor(hex: color)
    }
    
    func setBackgroundColor(color:UIColor){
        viewMain.backgroundColor = color
    }

    func updateView(student:StudentModel, position:Int){
        self.currStudent = student
        displayUsername(username: student.userName)
        displayPosition(position: position)
    }
    func updateView(student:StudentModel, position:Int, score:Int){
        self.currStudent = student
        displayUsername(username: student.userName)
        displayPosition(position: position)
        updateScore(score: score)
    }


    func displayUsername(username:String){
        lab_username.text = username
    }

    func displayPosition(position:Int){
        lab_position.text = String.ordinalNumberFormat(number: position)
    }
    
    func updateScore(score: Int){
        overallScore += score
        scoreLabel.text = String(score)
    }
    
    func convertToCurrUser(){
        Bundle.main.loadNibNamed("CurrUserView", owner: self, options: nil)
        addSubviews()
    }
    func convertToOtherUser(){
        Bundle.main.loadNibNamed("UserView", owner: self, options: nil)
        addSubviews()
    }

}
