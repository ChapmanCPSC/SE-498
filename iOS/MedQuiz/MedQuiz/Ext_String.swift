//
// Created by Harnack, Paul (Student) on 2/28/18.
// Copyright (c) 2018 Omar Sherief. All rights reserved.
//

import Foundation

extension String {

    /*
     Return string with corresponding ordinal ending component for specified int.
     */
    
    static func ordinalNumberFormat(number: Int) -> String {
        var ending = "th"

        let ones = number % 10
        let tens = ((number / 10) % 10) as Int

        if tens != 1 { // tens == 1 will always end in "th"
            switch ones {
            case 1:
                ending = "st"
            case 2:
                ending = "nd"
            case 3:
                ending = "rd"
            default:
                print("String.ordinalNumberFormat(\(number)) defaulting to \(ending)")
            }
        }

        return "\(number)\(ending)"
    }

}
