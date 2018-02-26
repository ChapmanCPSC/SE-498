//
//  ChangeUsernameVC.swift
//  MedQuiz
//
//  Created by Chad Johnson on 2/26/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

class ChangeUsernameVC: UIViewController {

    @IBOutlet weak var warningView: UIView!
    
    @IBOutlet weak var changeUsernameTextField: UITextField!
    
    var warned = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backToProfile(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func changeUsernameTextFieldPressed(_ sender: Any) {
        if (warned == false){
            warningView.isHidden = false
            view.endEditing(true)
        }
    }
    
    
    @IBAction func noPressed(_ sender: Any) {
        warningView.isHidden = true
        view.endEditing(true)
    }
    
    
    @IBAction func yesPressed(_ sender: Any) {
        warningView.isHidden = true
        warned = true
        changeUsernameTextField.becomeFirstResponder()
    }
    
    
    @IBAction func changeUsernameEnd(_ sender: Any) {
        if (warned == true){
            dismiss(animated: false, completion: nil)
        }
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
