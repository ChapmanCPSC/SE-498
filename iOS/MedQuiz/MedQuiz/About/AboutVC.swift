//
//  AboutVC.swift
//  MedQuiz
//
//  Created by Omar Sherief on 11/9/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit
import Firebase

/*
 AboutVC presents the About text description from the database.
 */

class AboutVC: UIViewController {
    @IBOutlet weak var aboutTextView: UITextView!
    
    /*
     Set text component using database text value.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference() //reference from firebase
        
        //It displays the about description text from firebase
        ref.child("about-description").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            self.aboutTextView.text = (snapshot.value as! String).replacingOccurrences(of: "\\n", with: "\n")
        }
        
    }
    
    /*
     Set scroll position.
     */
    
    override func viewDidLayoutSubviews() {
        self.aboutTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
}

