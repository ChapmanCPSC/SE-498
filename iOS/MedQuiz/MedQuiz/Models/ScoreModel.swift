//
//  ScoreModel.swift
//  MedQuiz
//
//  Created by Omar Sherief on 4/14/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation
import Foundation

/*
 Firebase wrapper for Score. Abstracts the process of accessing attributes of Score objects stored in the database.
 */

class ScoreModel: FIRModel,FIRQueryable
    
{
    static var COLLECTION_NAME: String = "score"
    
    static var TOTAL_POINTS = "points"
    
    var points: Int? { return self.get(ScoreModel.TOTAL_POINTS) }
    
    
}
