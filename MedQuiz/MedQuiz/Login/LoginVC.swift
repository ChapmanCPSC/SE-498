//
//  LoginVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/13/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    var MainStoryBoard:UIStoryboard? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Reference to the Quiz's storyboard
        MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        print("woo")
        present((MainStoryBoard?.instantiateInitialViewController())!, animated: false, completion: nil)
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
