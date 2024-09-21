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
    
    static func addOrSubtractMonth(month: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: month, to: Date())!
    }
    
    static func addOrSubtractDay(day: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: day, to: Date())!
    }
    
    static func getFormattedDateString(date: Date, startTime: Bool) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: date)
        if startTime {
            return "\(dateString)000000"
        }
        return "\(dateString)235959"
    }
    
    static func getDateStringForApiCalls(date: Date?) -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        /// "2020-05-28 00:20:00 GMT+5:30"
        var stringDate = dtf.string(from: Date.now)
        if date != nil {
            stringDate = dtf.string(from: date!)
        }
        stringDate = stringDate.replacingOccurrences(of: " ", with: "T")
        stringDate = stringDate + "Z"
        
        return stringDate
    }
}
