//
//  AnswerView.swift
//  MedQuiz
//
//  Created by Harnack, Paul (Student) on 2/25/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

/*
 AnswerView displays question answer information and recieves selection events.
 */

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
    
    var answer:Answer = Answer(answerText: "Some answer Text", isAnswer: false)
    var parent:SelectsAnswer!
    public private(set) var isBlank:Bool = false

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
        Bundle.main.loadNibNamed("AnswerView", owner: self, options: nil)
        addSubviews()
        addListenerToMain()
        //TODO stop autosetting this after testing
        answer = Answer(answerText: "This is an example answer", isAnswer: false)
    }

    /*
     Add subviews to viewMain.
     */
    
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

    /*
     Add gesture receiever to viewMain.
     */
    
    func addListenerToMain(){
        viewMain.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(wasTapped)))
    }

    /*
     Signal parent when view tapped.
     */
    
    @objc func wasTapped(){
        if(!self.isBlank){ // only send wasTapped if it's a valid choice
            parent.answerSelected(answer: self)
        }
    }

    /*
     Set self.answer using answer. Reset views.
     */
    
    func setAnswer(answer:Answer) {
        self.isBlank = false
        self.answer = answer
        resetViews()
    }
    
    /*
     Visually indicate correct answer selection.
     */
    
    func showCorrect() {
        iv_correct.isHidden = false
        showPoints(wasCorrect: true)
    }
    
    /*
     Visually indicate wrong answer selection.
     */
    
    func showWrong() {
        iv_wrong.isHidden = false
        showPoints(wasCorrect: false)
    }

    /*
     Hide correct visual indication.
     */
    
    func hideCorrect() {
        iv_correct.isHidden = true
    }
    
    /*
     Hide incorrect visual indication.
     */

    func hideWrong() {
        iv_wrong.isHidden = true
    }
    
    /*
     Hide all visual elements.
     */
    
    func resetViews() {
        UIView.animate(withDuration: 0.25) { () -> Void in
            /*if (self.answer.hasImage){
                self.hideText()
            }
            else{
                self.hideImage()
            }*/
            self.hideImage()
            self.hideText()
            self.hidePoints()
            self.hideWrong()
            self.hideCorrect()
            self.viewFade.alpha = 0
         }

    }

    /*
     Show answer information depending on whether answer has an image.
     */
    
    func displayAnswer(){
        if(self.isBlank){
            return
        }
        if(self.answer.hasImage)!{
            self.showImage()
        }
        else{
            self.showText()
        }
    }
    
    /*
     Hide image component of view.
     */
    
    func hideImage() {
        let newConstraint = con_imgAnswerHeight.constraintWithMultipler(0.0000000000000001)
        viewMain.removeConstraint(con_imgAnswerHeight)
        con_imgAnswerHeight = newConstraint
        viewMain.addConstraint(con_imgAnswerHeight)
        viewMain.layoutIfNeeded()
        con_textImg.constant = -10
//        lab_answerText.layoutIfNeeded()
    }
    
    /*
     Hide text component of view.
     */
    
    func hideText() {
        lab_answerText.isHidden = true

        con_textImg.constant = 10
    }
    
    /*
     Show image component of view.
     */
    
    private func showImage() {
        iv_answer.image = answer.image
        let newConstraint = con_imgAnswerHeight.constraintWithMultipler(0.5)
        viewMain.removeConstraint(con_imgAnswerHeight)
        con_imgAnswerHeight = newConstraint
        viewMain.addConstraint(con_imgAnswerHeight)
        viewMain.layoutIfNeeded()
    }
    
    /*
     Show text component of view.
     */
    
    private func showText() {
        lab_answerText.text = answer.answerText
        lab_answerText.isHidden = false
    }
    
    /*
     Show answer points.
     */
    
    func showPoints(wasCorrect:Bool) {
        if(wasCorrect){
            lab_points.text = "+\(answer.points)"
        }
        else{
            lab_points.text = ""
        }
        lab_points.isHidden = false
    }
    
    /*
     Hide answer points.
     */
    
    func hidePoints() {
        lab_points.isHidden = true
    }

    /*
     Set background color using provided string for hex conversion.
     */
    
    func setBackgroundColor(color:String) {
        viewMain.backgroundColor = UIColor.hexStringToUIColor(hex: color)
    }

    func setBackgroundColor(color:UIColor) {
        viewMain.backgroundColor = color
    }

    /*
     Adjust answer transparency through animation.
     */
    
    func fadeAnswer(){
        var decimal:CGFloat
        if(self.isBlank){
            decimal = 1
        }
        else {
            decimal = 0.3
        }
        UIView.animate(withDuration: 0.25) { () -> Void in
            self.viewFade.alpha = decimal
        }
    }
    
    /*
     Hide all components and set blank status to true.
     */
    
    func setBlank(){
        self.isBlank = true
        hideText()
        hideImage()
        hideCorrect()
        hideWrong()
        hidePoints()
        fadeAnswer()
    }
    
}




















