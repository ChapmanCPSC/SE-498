//
//  ColorHelper.swift
//  MedQuiz
//
//  Created by Omar Sherief on 2/14/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import Foundation
import UIKit


//
//https://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
//



//use this class helper instance throught app to help with colors
var OurColorHelper = colorHelper()

//Colors
let leaderBoardSwitchFriends = OurColorHelper.hexStringToUIColor(hex: "6FE5CB")
let leaderBoardSwitchGlobal = OurColorHelper.hexStringToUIColor(hex: "E5896F")
let leaderBoardHiglightUser = OurColorHelper.hexStringToUIColor(hex: "FFE483")





//Color helper class
class colorHelper{
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func hexStringToUIColorWithAlpha (hex:String, theAlpha: CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: theAlpha
        )
    }
    

}
