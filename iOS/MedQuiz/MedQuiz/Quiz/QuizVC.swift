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

class QuizVC: UIViewController {
    @IBOutlet weak var tf_quizPin: UITextField!
    @IBOutlet weak var iv_closeButton: UIImageView!
    @IBOutlet weak var sv_search: UIView!
    
    let gameRef = Database.database().reference(withPath: "game")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        
        
        
        //Testing quiz pin retrieval
        // in this case we assume a student entered a pin: 8419
        let testPin = "8419"
        GameModel.Where(child: GameModel.GAME_PIN, equals: testPin) { (gamesFound) in
            //this query returns an array of games, I called it "gamesFound"
            // since there can only be one game with that game pin
            // i can just assume the game is the first one in the array "gamesFound"
            // returned.
            let theGame = gamesFound[0]
            //since theGame is of type GameModel I can use its variable quizKey and
            // and then get access to that quiz using the quiz key
            let quizKeyForGame = theGame.quizKey!
            QuizModel.From(key: quizKeyForGame, completion: { (aQuiz) in
                //This query returns an a quiz model by some key I provided "quizKeyForGame". I called the quiz model "aQuiz"
                //Just to test we return the quiz title
                print("Testing quiz pin retrieval")
                print(aQuiz.title!)
            })
        }
        
        
        
        
    }
    
    func setupViews(){
        setBorderColor()
        setPlaceholderColor()
        setTFDelegate()
        setIVCloseTapped()
        setSearchTapped()
    }
    
    func setBorderColor(){
        tf_quizPin.borderStyle = .line
        tf_quizPin.layer.borderWidth = 8.0
        tf_quizPin.layer.borderColor = UIColor.hexStringToUIColor(hex: "#F5A623").cgColor
        
    }
    func setPlaceholderColor(){
        tf_quizPin.attributedPlaceholder = NSAttributedString(string: "Enter Quiz Pin", attributes: [NSAttributedStringKey.foregroundColor: UIColor.hexStringToUIColor(hex: "#f7c87b")])
        
    }
    
    func setTFDelegate(){
        tf_quizPin.delegate = self
    }
    
    func setIVCloseTapped(){
        iv_closeButton.isUserInteractionEnabled = true
        iv_closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QuizVC.iv_pressed)))
    }

    func setSearchTapped(){
        sv_search.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QuizVC.sv_searchPressed)))
    }

    @objc func sv_searchPressed(){
        self.performSegue(withIdentifier: "QuizSearchSegue", sender: nil)
    }
    
    func showCloseButton(){
        self.iv_closeButton.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.iv_closeButton.alpha = 0.75
        })
    }
    
    func hideCloseButton(){
        UIView.animate(withDuration: 0.25, animations: {
            self.iv_closeButton.alpha = 0
        }, completion:{(Bool) in
            self.iv_closeButton.isHidden = true
        })
    }
    
    //Scheduling used to make pin check wait fot Firebase query to finish, not sure if optimal
    func checkForPin(){
        var currentPins = [String]()
        
        let group = DispatchGroup()
        
        group.enter()
        
        gameRef.queryOrderedByKey().observe(.value, with:{ (snapshot: DataSnapshot) in
            for snap in snapshot.children {
                currentPins.append(((snap as! DataSnapshot).value as! [String:AnyObject])["gamepin"] as! String)
            }
            group.leave()
        })
        
        group.notify(queue: .main){
            guard let inputPin = Int(self.tf_quizPin.text!) else {
                print("Quiz pin was not a number")
                self.showAlert(title: "Failure", message: "The provided pin was not a number")
                self.clearPin()
                return
            }
            
            if(currentPins.contains(String(inputPin))){
                print("Pin does exist")
                self.showAlert(title: "Success", message: "The provided pin matches a quiz")
                self.performSegue(withIdentifier: "QuizPinSegue", sender: nil)
            }
            else{
                print("Pin does not exist")
                self.showAlert(title: "Failure", message: "The provided pin does not match a quiz")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillDisappear(){
        hideCloseButton()
    }

    func clearPin(){
        tf_quizPin.text = ""
    }
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style:.default, handler: nil))
        
        self.present(alert, animated:true, completion: nil)
    }
    
    @IBAction func tf_pressed(_ sender: Any) {
        showCloseButton()
    }
    
    @objc func iv_pressed(){
        hideCloseButton()
        self.view.endEditing(true)
    }
    
    
}

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
