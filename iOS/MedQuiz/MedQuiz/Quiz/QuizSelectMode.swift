//
//  QuizSelectMode.swift
//  MedQuiz
//
//  Created by Omar Sherief on 4/4/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

class QuizSelectMode: UIViewController {

    @IBOutlet weak var leftCard: UIView!
    @IBOutlet weak var rightCard: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leftCard.backgroundColor = OurColorHelper.pharmAppRed
        rightCard.backgroundColor = OurColorHelper.pharmAppPurple
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitPracticeModeSelect(_ sender: Any) {
        self.dismiss(animated: false) {
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
