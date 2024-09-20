//
//  Extensions.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import Foundation

extension Date {
    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return self}
        
        return localDate
    }
}
