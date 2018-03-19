//
//  LoginVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/13/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    var MainStoryBoard:UIStoryboard? = nil
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    
//    var tags : TagModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Reference to the Quiz's storyboard
        MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        // Do any additional setup after loading the view.
        
        //Testing user login
        //Here I created a variable testUserLoginInput, assume
        // this would be used for example on successful login/authentication
        // from Firebase. We have the input from the usernameTextField
        // and we can use that on login to get the username and profile pic etc.
        let testUserLoginInput = "b29fks9mf9gh37fhh1h9814"
//        //I query a student by the key and I print the student's username on success
        StudentModel.From(key: testUserLoginInput) { (aStudent) in
            print("Testing user login")
            print(aStudent.studentUsername!)
        }
        
        //Example of a query that will keep observing for any changes/additions/deletions
        // at a specific key path
        StudentModel.FromAndKeepObserving(key: testUserLoginInput) { (aStudent) in
            print("Testing user login")
            print(aStudent.studentUsername!)
        }
        
        
        //Example of getting all the profile pictures for all students
        // (not sure this is usefull but just an example of use)
        StudentModel.All { (students) in
            for student in students{
                print(student.studentUsername!)
                student.getProfilePic(completion: { (anImage) in
                    print(anImage!.description)
                })
            }
        }
        
        //Example of getting specific profile picture for one student
        // (not sure this is usefull but just an example of use)
        let testUserLoginInput2 = "lylenator2000"
        StudentModel.Where(child: "username", equals: testUserLoginInput2) { (studentModelsReturned) in
            let theStudent = studentModelsReturned[0]
            print(theStudent.studentUsername!)
            theStudent.getProfilePic(completion: { (theProfilePic) in
                 print(theProfilePic!.description)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        //UNCOMMENT LATER - for when we need to check username/password with db
        
//        if (usernameTextField.text == "username" && passwordTextField.text == "password"){
//            present((MainStoryBoard?.instantiateInitialViewController())!, animated: false, completion: nil)
//        }
//        else{
//            loginErrorLabel.text = "Incorrect username/password"
//            loginErrorLabel.isHidden = false
//        }
        
        present((MainStoryBoard?.instantiateInitialViewController())!, animated: false, completion: nil)

        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == 0){
            passwordTextField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
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
