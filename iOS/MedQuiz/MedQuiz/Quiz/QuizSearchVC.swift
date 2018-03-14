//
//  QuizSearchVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

class QuizSearchVC: UIViewController {
    
    @IBOutlet weak var bt_closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        
        
        

        
        
        //Testing quiz retrieval by certain tag
        // in this case we assume we're querying for the tag "Biology"
        let testTagName = "Biology"
        
        QuizModel.Where(child:"tags/\(testTagName)", equals: true) { (theQuizzes) in
            //This query returns an array of quiz models by some key I provided "testTagName"
            // where tags/testTageName is equal true
            // I called the quiz model array "theQuizzes"
            // I then traversed through the array of quiz modles
            // and just to test we print the quiz title.
            //You can see how we'd use this to populate the tableview of tags and it's quiz contents/cells
            for quiz in theQuizzes{
                print(quiz.title!)
            }
        }
        
        
        
        
        
        
    }
    
    func setupViews(){
        setInsetsOnCloseButton()
    }
    
    func setInsetsOnCloseButton(){
        bt_closeButton.contentEdgeInsets.top = 5
        bt_closeButton.contentEdgeInsets.bottom = 5
    }
    
}
