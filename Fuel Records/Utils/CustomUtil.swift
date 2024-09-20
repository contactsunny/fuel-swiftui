//
//  CustomUtil.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import Foundation

class CustomUtil {
    
    static func getFormattedDateFromTimestamp(timestamp: Double) -> String {
        let date = NSDate(timeIntervalSince1970: timestamp / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date as Date)
        return localDate
    }
    
    static func getFormattedString(str: String) -> String {
        var formattedStr: String
        var separator: String = ""
        var containsSpecialChar: Bool = false
        
        if str.contains("_") {
            separator = "_"
            containsSpecialChar = true
        } else if str.contains(" ") {
            separator = " "
            containsSpecialChar = true
        } else if str.contains("-") {
            separator = "-"
            containsSpecialChar = true
        }
        
        if containsSpecialChar {
            let splits = str.split(separator: separator)
            var words: [String] = []
            for split in splits {
                let firstLetter = split.prefix(1).capitalized
                let remainingLetters = split.dropFirst().lowercased()
                words.append(firstLetter + remainingLetters)
            }
            formattedStr = words.joined(separator: " ")
        } else {
            formattedStr = str
        }
        
        return formattedStr
    }
}
