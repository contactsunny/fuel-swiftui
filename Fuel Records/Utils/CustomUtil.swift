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
}
