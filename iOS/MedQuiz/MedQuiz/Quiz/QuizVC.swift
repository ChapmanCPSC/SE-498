//
//  QuizVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit
import Firebase
var mainQuizVC : UIViewController!

/*
 QuizVC searches the database for standard games matching the pin entered by the user.
 */

class QuizVC: UIViewController {
    @IBOutlet weak var tf_quizPin: UITextField!
    @IBOutlet weak var iv_closeButton: UIImageView!
    @IBOutlet weak var sv_search: UIView!
    
    var gamePin:String?
    
    /*
     Setup views.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        mainQuizVC = self
    }
    
    /*
     Set conditions for various UI elements.
     */
    
    func setupViews(){
        setBorderColor()
        setPlaceholderColor()
        setTFDelegate()
        setIVCloseTapped()
        setSearchTapped()
        
        tf_quizPin.textColor = OurColorHelper.pharmAppPurple
    }
    
    /*
     Set border width and color for pin input field.
     */
    
    func setBorderColor(){
        tf_quizPin.borderStyle = .line
        tf_quizPin.layer.borderWidth = 8.0
        tf_quizPin.layer.borderColor = UIColor.hexStringToUIColor(hex: "#F5A623").cgColor
    }
    
    /*
     Set color for text without user input.
     */
    func setPlaceholderColor(){
        tf_quizPin.attributedPlaceholder = NSAttributedString(string: "Enter Quiz Pin", attributes: [NSAttributedStringKey.foregroundColor: UIColor.hexStringToUIColor(hex: "#f7c87b")])
    }
    
    /*
     Set delegate for tf_quizPin.
     */
    
    func setTFDelegate(){
        tf_quizPin.delegate = self
    }
    
    /*
     Set close button.
     */
    
    func setIVCloseTapped(){
        iv_closeButton.isUserInteractionEnabled = true
        iv_closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QuizVC.iv_pressed)))
    }

    /*
     Set search button.
     */
    
    func setSearchTapped(){
        sv_search.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QuizVC.sv_searchPressed)))
    }
    
    /*
     Segue to QuizSearch then search pressed.
     */
    
    @objc func sv_searchPressed(){
        self.performSegue(withIdentifier: "QuizSearchSegue", sender: nil)
    }
    
    /*
     Display close button.
     */
    
    func showCloseButton(){
        self.iv_closeButton.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.iv_closeButton.alpha = 0.75
        })
    }
    
    /*
     Hide close button.
     */
    
    func hideCloseButton(){
        UIView.animate(withDuration: 0.25, animations: {
            self.iv_closeButton.alpha = 0
        }, completion:{(Bool) in
            self.iv_closeButton.isHidden = true
        })
    }
    
    /*
    Check database for standard game with a pin matching user input. If found, set busy status to true and transition to lobby.
     */
    
    func checkForPin(){
        guard let inputPin = Int(self.tf_quizPin.text!) else {
            print("Quiz pin was not a number")
            self.showAlert(title: "Failure", message: "The provided pin was not a number")
            self.clearPin()
            return
        }
        
        GameModel.Where(child: GameModel.GAME_PIN, equals: inputPin) { (gamesFound) in
            if(!gamesFound.isEmpty){
                QuizModel.From(key: gamesFound[0].key, completion: { (quiz) in                    
                    print("Pin does exist")
                    self.gamePin = String(inputPin)
                    
                    globalBusy = true
                    let userHeadToHeadRequestReference = Database.database().reference().child("student").child(currentUserID)
                    userHeadToHeadRequestReference.child("headtoheadgamerequest").setValue("busy")
                    
                    let quizLobbyVC = self.storyboard?.instantiateViewController(withIdentifier: "quizLobbyVC") as! QuizLobbyVC
                    quizLobbyVC.gameKey = gamesFound[0].key
                    quizLobbyVC.quizKey = gamesFound[0].quizKey
                    quizLobbyVC.quizMode = QuizLobbyVC.QuizMode.Standard
                    mainQuizVC.present(quizLobbyVC, animated: false, completion: nil)
                })
            }
            else{
                GameModel.Where(child: GameModel.GAME_PIN, equals: String(inputPin)) { (gamesFound) in
                    if(!gamesFound.isEmpty){
                        QuizModel.From(key: gamesFound[0].key, completion: { (quiz) in
                            print("Pin does exist")
                            self.gamePin = String(inputPin)
                            
                            let userHeadToHeadRequestReference = Database.database().reference().child("student").child(currentUserID)
                            userHeadToHeadRequestReference.child("headtoheadgamerequest").setValue("busy")
                            globalBusy = true
                            
                            let quizLobbyVC = self.storyboard?.instantiateViewController(withIdentifier: "quizLobbyVC") as! QuizLobbyVC
                            quizLobbyVC.gameKey = gamesFound[0].key
                            quizLobbyVC.quizKey = gamesFound[0].quizKey
                            quizLobbyVC.quizMode = QuizLobbyVC.QuizMode.Standard
                            mainQuizVC.present(quizLobbyVC, animated: false, completion: nil)
                        })
                    }
                    else{
                        print("Pin does not exist")
                        self.showAlert(title: "Failure", message: "The provided pin does not match a quiz")
                    }
                }
            }
        }
    }

    /*
     Set observer to trigger when keyboardWillDisappear.
     */
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    /*
     Hide close button when keyboard is about to disappear.
     */
    
    @objc func keyboardWillDisappear(){
        hideCloseButton()
    }

    /*
     Set pin input field text to empty string.
     */
    
    func clearPin(){
        tf_quizPin.text = ""
    }
    /*
     Display alert with provided title and message strings.
     */
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style:.default, handler: nil))
        
        self.present(alert, animated:true, completion: nil)
    }
    
    /*
     Show close button when tf pressed.
     */
    
    @IBAction func tf_pressed(_ sender: Any) {
        showCloseButton()
    }
    
    /*
     Hide close button when iv pressed.
     */
    
    @objc func iv_pressed(){
        hideCloseButton()
        self.view.endEditing(true)
    }
    
}

/*
 Delegate extansion for text field. Establishes pin input maximum length.
 */

extension QuizVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == tf_quizPin){
            textField.resignFirstResponder()
            hideCloseButton()
            checkForPin()
            return false
        }
        return true
    }
}

