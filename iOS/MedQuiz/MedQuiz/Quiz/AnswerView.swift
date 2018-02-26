//
//  AnswerView.swift
//  MedQuiz
//
//  Created by Harnack, Paul (Student) on 2/25/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

class AnswerView: UIView {

    @IBOutlet weak var iv_answer: UIImageView!
    @IBOutlet weak var iv_correct: UIImageView!
    @IBOutlet weak var iv_wrong: UIImageView!
    @IBOutlet weak var lab_answerText: UILabel!
    @IBOutlet weak var lab_points: UILabel!
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewFade: UIView!
    
    @IBOutlet weak var con_imgAnswerHeight: NSLayoutConstraint!
    @IBOutlet weak var con_textImg: NSLayoutConstraint!
    
    var answer:AnswerModel = AnswerModel(answerText: "Some answer Text", points: 10, isAnswer: false, imageLink: "")
    var parent:SelectsAnswer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView(){
        Bundle.main.loadNibNamed("AnswerView", owner: self, options: nil)
        addSubviews()
        addListenerToMain()
    }

    func addSubviews(){
        addSubview(viewMain)
        viewMain.frame = self.bounds
        viewMain.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewMain.addSubview(iv_answer)
        viewMain.addSubview(iv_wrong)
        viewMain.addSubview(iv_correct)
        viewMain.addSubview(lab_answerText)
        viewMain.addSubview(lab_points)
        viewMain.addSubview(viewFade)

    }

    func addListenerToMain(){
        viewMain.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(wasTapped)))
    }

    @objc func wasTapped(){
        parent.answerSelected(answer: self)
    }

    func setAnswer(answer:AnswerModel) {
        self.answer = answer
        resetViews()
    }
    
    func showCorrect() {
        iv_correct.isHidden = false
    }
    
    func showWrong() {
        iv_wrong.isHidden = false
    }

    func hideCorrect() {
        iv_correct.isHidden = true
    }

    func hideWrong() {
        iv_wrong.isHidden = true
    }
    
    func resetViews() {
        UIView.animate(withDuration: 0.25) { () -> Void in
            if (self.answer.hasImage){
                self.hideText()
            }
            else{
                self.hideImage()
            }
            self.hidePoints()
            self.hideWrong()
            self.hideCorrect()
            self.viewFade.alpha = 0
         }

    }
    
    func hideImage() {
        let newConstraint = con_imgAnswerHeight.constraintWithMultipler(0.0000000000000001)
        viewMain.removeConstraint(con_imgAnswerHeight)
        con_imgAnswerHeight = newConstraint
        viewMain.addConstraint(con_imgAnswerHeight)
        viewMain.layoutIfNeeded()
        con_textImg.constant = -10
//        lab_answerText.layoutIfNeeded()
        showText()
    }
    
    func hideText() {
        lab_answerText.isHidden = true

        con_textImg.constant = 10


        showImage()
    }
    
    private func showImage() {
        let newConstraint = con_imgAnswerHeight.constraintWithMultipler(0.5)
        viewMain.removeConstraint(con_imgAnswerHeight)
        con_imgAnswerHeight = newConstraint
        viewMain.addConstraint(con_imgAnswerHeight)
        viewMain.layoutIfNeeded()
    }
    
    private func showText() {
        lab_answerText.isHidden = false
    }
    
    func showPoints() {
        
    }
    
    func hidePoints() {
        
    }

    func setBackgroundColor(color:String) {
        viewMain.backgroundColor = UIColor.hexStringToUIColor(hex: color)
    }

    func fadeAnswer(){
        UIView.animate(withDuration: 0.25) { () -> Void in
            self.viewFade.alpha = 0.3
         }
    }

}




















