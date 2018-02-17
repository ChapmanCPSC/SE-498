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
    }
    
    func setupViews(){
        setInsetsOnCloseButton()
    }
    
    func setInsetsOnCloseButton(){
        bt_closeButton.contentEdgeInsets.top = 5
        bt_closeButton.contentEdgeInsets.bottom = 5
    }
    
}
