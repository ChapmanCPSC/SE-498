//
//  LoginVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/13/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {

    var MainStoryBoard:UIStoryboard? = nil
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    @IBOutlet weak var loginBackground: UIScrollView!
    
    var currView:UIViewController!
    
    var loggedIn = false
//    var tags : TagModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Example of using OurColorHelper colors
        // please follow througout app to make any color
        // changes or edits very easy and
        // to keep a sense of unity in the way we assign colors
        // and refrain from assigning them to some hex value or
        // UIcolor value or any other value ,unless
        // needed.
        // If you set the color of view in the storyboard try to
        // still assign it programatically like so. I know it's redundant
        // but if for any reason during future maintenance
        // they want to change color values they can easily do so through
        // ColorHelper and it will affect all views/objects.
        loginBackground.backgroundColor = OurColorHelper.pharmAppDarkBlue

        
        //Reference to the Quiz's storyboard
        MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        // Do any additional setup after loading the view.
        
        //Testing user login
        //Here I created a variable testUserLoginInput, assume
        // this would be used for example on successful login/authentication
        // from Firebase. We have the input from the usernameTextField
        // and we can use that on login to get the username and profile pic etc.
//        let testUserLoginInput = "b29fks9mf9gh37fhh1h9814"
        //I query a student by the key and I print the student's username on success
//        StudentModel.From(key: testUserLoginInput) { (aStudent) in
//            print("Testing user login")
//            print(aStudent.studentUsername!)
//        }
        
        //Example of a query that will keep observing for any changes/additions/deletions
        // at a specific key path
//        StudentModel.FromAndKeepObserving(key: testUserLoginInput) { (aStudent) in
//            print("Testing user login")
//            print(aStudent.studentUsername!)
//        }
        
        
        //Example of getting all the profile pictures for all students
        // (not sure this is usefull but just an example of use)
//        StudentModel.All { (students) in
//            for student in students{
//                print(student.studentUsername!)
//                student.getProfilePic(completion: { (anImage) in
//                    print(anImage!.description)
//                })
//            }
//        }
        
        //Example of getting specific profile picture for one student
        // (not sure this is usefull but just an example of use)
//        let testUserLoginInput2 = "lylenator2000"
//        StudentModel.Where(child: "username", equals: testUserLoginInput2) { (studentModelsReturned) in
//            let theStudent = studentModelsReturned[0]
//            print(theStudent.studentUsername!)
//            theStudent.getProfilePic(completion: { (theProfilePic) in
//                print(theProfilePic!.description)
//            })
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        //UNCOMMENT LATER - for when we need to check username/password with db
        
        if(!usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty){
            
            Auth.auth().signIn(withEmail: usernameTextField.text! + "@mail.chapman.edu", password: passwordTextField.text!) { (signedInUser, error) in
                
                if(signedInUser != nil){
                    self.loggedIn = true
                }
                
                //logged in
                if (self.loggedIn){
                    self.present((self.MainStoryBoard?.instantiateInitialViewController())!, animated: false, completion: nil)
                    self.checkHeadToHeadRequest(userStudentKey: "b29fks9mf9gh37fhh1h9814")
                }
                    
                //not logged in
                else{
                    self.loginErrorLabel.text = "Incorrect username/password"
                    self.loginErrorLabel.isHidden = false
                }
                
            }
        }
        
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
    
    func checkHeadToHeadRequest(userStudentKey:String){
        StudentModel.FromAndKeepObserving(key: userStudentKey) {user in
            if user.headToHeadGameRequest != nil {
                print("Presenting head to head request")
                let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let headToHeadRequestVC:HeadToHeadRequestVC = sb.instantiateViewController(withIdentifier: "headToHeadRequest") as! HeadToHeadRequestVC
                headToHeadRequestVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        print(type(of: topController))
                        topController = presentedViewController
                    }
                    
                    let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(user.headToHeadGameRequest!)
                    headToHeadGameRef.observeSingleEvent(of: .value, with: {(snapshot) in
                        //temp user student reference
                        _ = Student(key: user.key) { userStudent in
                            _ = Student(key: snapshot.childSnapshot(forPath: "inviter").childSnapshot(forPath: "student").value! as! String) { inviter in
                                headToHeadRequestVC.user = userStudent
                                headToHeadRequestVC.opponent = inviter
                                headToHeadRequestVC.headToHeadGameKey = user.headToHeadGameRequest
                                let quizKey:String = snapshot.childSnapshot(forPath: "quizkey").value! as! String
                                QuizModel.From(key: quizKey){ quiz in
                                    headToHeadRequestVC.headToHeadQuizTitle = quiz.title
                                    headToHeadRequestVC.headToHeadQuizKey = quizKey
                                    topController.present(headToHeadRequestVC, animated: true) {
                                        print("Request presented")
                                        print(type(of: topController))
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
    }
}
