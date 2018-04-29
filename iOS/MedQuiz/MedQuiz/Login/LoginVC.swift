//
//  LoginVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/13/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//


extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

import UIKit
import FirebaseAuth
import Firebase

//global variables to use throughout app
var currentGlobalStudent : Student!
var currentUserID = ""
var globalUsername = ""
var globalHighscore = 0
var globalProfileImage : UIImage!
var globalHeadToHeadBusy = false
//make a global list/array

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
    
    
    func getCorrectAnswers( completion: @escaping () -> Void){
        let correctRef = Database.database().reference().child("choices").child("d83j59d642c938g928f8").child("correctanswers")
        print(correctRef)
        correctRef.observeSingleEvent(of: .value, with: { (snap: DataSnapshot) in
            print("correct snapshot")
            print(snap.value!)
        
            for child in snap.children{
                print("new correct answer")
                print(child)
            }
            completion()
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = "darwi103"
        passwordTextField.text = "123456"
        
        getCorrectAnswers {
            print("done")
        }

        
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
        
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        //UNCOMMENT LATER - for when we need to check username/password with db
        
        if(!usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty){
            
            Auth.auth().signIn(withEmail: usernameTextField.text! + "@mail.chapman.edu", password: passwordTextField.text!) { (signedInUser, error) in
                
                //logged in
                if(signedInUser != nil){
                    self.loggedIn = true
                    currentUserID = (signedInUser?.uid)!
                    print("signed in and uid = " + currentUserID)
                    
                    currentGlobalStudent = Student(key: currentUserID, completion: { (aCurrentStudent) in
                        
                        print("done getting student")
                        globalUsername = aCurrentStudent.userName!
                        print(globalUsername)
                        globalHighscore = aCurrentStudent.totalPoints!
                        print(globalHighscore)
                        globalProfileImage = aCurrentStudent.profilePic!
                        print(globalProfileImage)
                        self.checkConnection()
                        
                        print("done")
                    Firebase.Database.database().reference().child("student").child(signedInUser!.uid).child("friends").observeSingleEvent(of: .value, with: { (snap: DataSnapshot) in
                            
                            for s in snap.children {
                                let friend = FriendModel(snapshot: s as! DataSnapshot)
                                Firebase.Database.database().reference().child("student").child(friend.key).observeSingleEvent(of: .value, with: { (friendSnap: DataSnapshot) in
                                    print(friendSnap)
                            
                                })
                            }
                        })
                        
                        
                        self.present((self.MainStoryBoard?.instantiateInitialViewController())!, animated: false, completion: nil)
                        UIViewController.removeSpinner(spinner: sv)
                        self.checkHeadToHeadRequest()
                    })
                    
                    
                }
                
                    
                //not logged in
                else{
                    
                    UIViewController.removeSpinner(spinner: sv)
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
    
    func getTopController(_ parent:UIViewController? = nil) -> UIViewController {
        if let vc = parent {
            if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
                return getTopController(selected)
            } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
                return getTopController(top)
            } else if let presented = vc.presentedViewController {
                return getTopController(presented)
            } else {
                return vc
            }
        } else {
            return getTopController(UIApplication.shared.keyWindow!.rootViewController!)
        }
    }
    
    func logout(){
        print("logged out")
        //TODO
    }
    
    func checkConnection(){
        let connectedRef = Database.database().reference().child(".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            guard let connected = snapshot.value as? Bool, connected else {
                let topController = self.getTopController()
                switch topController {
                case is QuizActivityVC:
                    (topController as! QuizActivityVC).errorOccurred(title: "You have lost connection to the database", message: "Check your internet connection.", completion: self.logout)
                    break
                case is QuizLobbyVC:
                    (topController as! QuizLobbyVC).errorOccurred(title: "You have lost connection to the database", message: "Check your internet connection.", completion: self.logout)
                    break
                default:
                    print("disconnected")
                    break
                }
                
                print(type(of: topController))
                return
            }
            let currUserOnline = Database.database().reference().child("student/\(currentUserID)/online")
            currUserOnline.onDisconnectSetValue(false)
            currUserOnline.setValue(true)
        })
    }
    
    func checkHeadToHeadRequest(){
        StudentModel.FromAndKeepObserving(key: currentUserID, completion: { student in
            if student.headToHeadGameRequest != nil && !globalHeadToHeadBusy{
                print("Presenting head to head request")
                globalHeadToHeadBusy = true
                let headToHeadGameRef = Database.database().reference().child("head-to-head-game").child(student.headToHeadGameRequest!)
                headToHeadGameRef.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let inviterKey = snapshot.childSnapshot(forPath: "inviter").childSnapshot(forPath: "student").value! as? String {
                        if inviterKey != currentUserID {
                            let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let headToHeadRequestVC:HeadToHeadRequestVC = sb.instantiateViewController(withIdentifier: "headToHeadRequestVC") as! HeadToHeadRequestVC
                            headToHeadRequestVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                            _ = Student(key: inviterKey) { inviter in
                                headToHeadRequestVC.opponent = inviter
                                headToHeadRequestVC.headToHeadGameKey = headToHeadGameRef.key
                                let quizKey:String = snapshot.childSnapshot(forPath: "quiz").value! as! String
                                QuizModel.From(key: quizKey){ quiz in
                                    headToHeadRequestVC.headToHeadQuizTitle = quiz.title
                                    headToHeadRequestVC.headToHeadQuizKey = quizKey
                                    self.getTopController().present(headToHeadRequestVC, animated: true) {
                                        print("Request presented")
                                    }
                                }
                            }
                        }
                    }
                })
            }
        })
    }
}
