//
//  GameModel.swift
//  MedQuiz
//
//  Created by Omar Sherief on 3/13/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation

/*
 Firebase wrapper for Game. Abstracts the process of accessing attributes of Game objects stored in the database.
 */

class GameModel: FIRModel, FIRQueryable
{
    static var COLLECTION_NAME: String = "game"
    
    static var GAME_PIN = "gamepin"
    static var QUIZ = "quiz"
    static var STUDENTS = "students"
    
    var gamePin: String? { return self.get(GameModel.GAME_PIN) }
    var quizKey: String? { return self.get(GameModel.QUIZ) }
    var gameStudents: [StudentModel] { return self.get(GameModel.STUDENTS)}
    
}
