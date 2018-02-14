//
//  QuizVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

class QuizVC: UIViewController {
    @IBOutlet weak var tf_quizPin: UITextField!
    @IBOutlet weak var iv_closeButton: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        setBorderColor()
        setPlaceholderColor()
        setTFDelegate()
        setIVCloseTapped()
    }
    
    func setBorderColor(){
        tf_quizPin.borderStyle = .line
        tf_quizPin.layer.borderWidth = 5.0
        tf_quizPin.layer.borderColor = UIColor.orange.cgColor
        
    }
    func setPlaceholderColor(){
        tf_quizPin.attributedPlaceholder = NSAttributedString(string: "Enter Quiz Pin", attributes: [NSForegroundColorAttributeName: UIColor.hexStringToUIColor(hex: "#ffd293")])
        
    }
    
    func setTFDelegate(){
        tf_quizPin.delegate = self
    }
    
    func setIVCloseTapped(){
        iv_closeButton.isUserInteractionEnabled = true
        iv_closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QuizVC.iv_pressed)))
    }
    
    func showCloseButton(){
        self.iv_closeButton.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.iv_closeButton.alpha = 0.75
        })
    }
    
    @IBAction func tf_pressed(_ sender: Any) {
        showCloseButton()
    }
    
    @objc func iv_pressed(){

        UIView.animate(withDuration: 0.25, animations: {
            self.iv_closeButton.alpha = 0
        }, completion:{(Bool) in
            self.iv_closeButton.isHidden = true
        })
        
        // TODO hide keyboard
        self.view.endEditing(true)
    }
    
    
}

extension QuizVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
