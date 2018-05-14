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
var OurColorHelper = ColorHelper()



//Color helper class
class ColorHelper{
    
    //Colors
    //lazy to allow variables to use method in self
    lazy var pharmAppTeal = hexStringToUIColor(hex: "6FE5CB")
    lazy var pharmAppDarkTeal = hexStringToUIColor(hex: "9AD5D2")
    lazy var pharmAppBlue = hexStringToUIColor(hex: "439EC4")
    lazy var pharmAppDarkBlue = hexStringToUIColor(hex: "30718D")
    lazy var pharmAppYellow = hexStringToUIColor(hex: "FFE483")
    lazy var pharmAppOrange = hexStringToUIColor(hex: "FFC484")
    lazy var pharmAppPurple = hexStringToUIColor(hex: "8884FF")
    lazy var pharmAppRed = hexStringToUIColor(hex: "FF8D84")
    lazy var pharmAppGrey = hexStringToUIColor(hex: "979797")
    
    lazy var pharmAppAnswerOne = hexStringToUIColor(hex: "BB7AE1")
    lazy var pharmAppAnswerTwo = hexStringToUIColor(hex: "DCA480")
    lazy var pharmAppAnswerThree = hexStringToUIColor(hex: "DA7E7E")
    lazy var pharmAppAnswerFour = hexStringToUIColor(hex: "88D3E5")
    
    
    lazy var pharmAppGameLeaderboardUserOne = hexStringToUIColor(hex: "98D8C0")
    lazy var pharmAppGameLeaderboardUserTwo = hexStringToUIColor(hex: "C892D8")
    lazy var pharmAppGameLeaderboardCurrentUser = hexStringToUIColor(hex: "FDFFA1")
    lazy var pharmAppGameLeaderboardUserThree = hexStringToUIColor(hex: "A1ABFF")
    lazy var pharmAppGameLeaderboardUserFour = hexStringToUIColor(hex: "D8939B")
    
    
    lazy var pharmAppLeaderboardColors = [pharmAppGameLeaderboardUserOne, pharmAppGameLeaderboardUserTwo, pharmAppGameLeaderboardCurrentUser, pharmAppGameLeaderboardUserThree, pharmAppGameLeaderboardUserFour]

    lazy var pharmAppAnswerColors = [pharmAppAnswerOne ,pharmAppAnswerTwo, pharmAppAnswerThree, pharmAppAnswerFour]

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
