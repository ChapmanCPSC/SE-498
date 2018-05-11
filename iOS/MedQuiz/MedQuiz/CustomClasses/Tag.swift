//
// Created by Harnack, Paul (Student) on 3/17/18.
// Copyright (c) 2018 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit

class Tag {
    var color:String?
    var name:String?
    var complete:Bool!

    init(color:String, name:String){
        self.color = color
        self.name = name
        self.complete = true
    }

    init(key: String, completion: @escaping (Tag) -> Void){
        TagModel.From(key: key, completion: { (aTagModel) in
            self.complete = true
            
            if let color = aTagModel.tagColor {
                self.color = color
            }
            else{
                self.color = "blue"
                self.complete = false
                print("ERROR: Tag color not found.")
            }
            
            if let name = aTagModel.tagName {
                self.name = name
            }
            else{
                self.name = "name"
                self.complete = false
                print("ERROR: Tag name not found.")
            }

            completion(self)
        })
    }
    
    deinit {
        color = ""
        name = ""
    }
}
