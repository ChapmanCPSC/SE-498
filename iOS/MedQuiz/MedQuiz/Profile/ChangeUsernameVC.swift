//
//  ChangeUsernameVC.swift
//  MedQuiz
//
//  Created by Chad Johnson on 2/26/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

protocol ChangeUsernameVCDelegate: class{
    func dataChanged(username: String, usernameChanged: Bool)
}


/*
 ChangeUsernameVC allows the user to change their username if they have not already changed it before.
 */

class ChangeUsernameVC: UIViewController, UITextFieldDelegate {

    let placeholderTextColor = UIColor.hexStringToUIColor(hex: "FF8D84")
    let activeTextColor = UIColor.hexStringToUIColor(hex: "439EC4")
    
    @IBOutlet weak var warningView: UIView!
    
    @IBOutlet weak var changeUsernameTextField: UITextField!
    
    var username: String?
    
    var warned = false
    
    var usernameChanged = false
    
    weak var delegate: ChangeUsernameVCDelegate?
    
    
    /*
     Setup input text field.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        changeUsernameTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
        changeUsernameTextField.delegate = self
        changeUsernameTextField.text = username
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*
     Dismiss view.
     */
    
    @IBAction func backToProfile(_ sender: Any) {
//        delegate?.dataChanged(username: username!, usernameChanged: usernameChanged)
        dismiss(animated: false, completion: nil)
    }
    
    
    /*
     Hide warning after user responds to change username warning with no.
     */
    
    @IBAction func noPressed(_ sender: Any) {
        warningView.isHidden = true
        changeUsernameTextField.becomeFirstResponder()
//        changeUsernameTextField.endEditing(true)
    }
    
    
    /*
     Set new username and dismiss view after user responds to change username warning with yes.
     */
    
    @IBAction func yesPressed(_ sender: Any) {
        warningView.isHidden = true
        //Gets a reference to db and changes the username on the db(firebase) with the text the inputted
        Database.database().reference().child("student").child(currentGlobalStudent.databaseID!).child("username").setValue(changeUsernameTextField.text!)
        //Assigns the new username to the global username
        globalUsername = changeUsernameTextField.text!
        //Assigns the new username to currentGlobal student 
        currentGlobalStudent.userName = changeUsernameTextField.text!
        //Could only change username once
        currentGlobalStudent.hasChangedUsername = true
        
        delegate?.dataChanged(username: changeUsernameTextField.text!, usernameChanged: true)
        dismiss(animated: false, completion: nil)
    }
    
    
    /*
     Adjust input text field text when user starts editing.
     */
    
    @IBAction func changeUsernameTextFieldEditingDidBegin(_ sender: Any) {
        changeUsernameTextField.textColor = activeTextColor
        changeUsernameTextField.selectedTextRange = changeUsernameTextField.textRange(from: changeUsernameTextField.beginningOfDocument, to: changeUsernameTextField.endOfDocument)
    }
    
    
    /*
     Adjust input text field text when user stops editing.
     */
    
    @IBAction func changeUsernameTextFieldEditingDidEnd(_ sender: Any) {
        changeUsernameTextField.textColor = placeholderTextColor
    }
    
    
    /*
     Presents warning if user enters username that is not equal to their current username. Returns true when function content complete.
     */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if (changeUsernameTextField.text == username){
            delegate?.dataChanged(username: changeUsernameTextField.text!, usernameChanged: false)
            dismiss(animated: false, completion: nil)
        }
        else{
            warningView.isHidden = false
            changeUsernameTextField.textColor = placeholderTextColor
            changeUsernameTextField.endEditing(true)
        }

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        
        let length = text.characters.count + string.characters.count - range.length
        
        return length <= 20
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
