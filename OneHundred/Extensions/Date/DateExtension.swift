//
//  DateExtension.swift
//  App Architecture
//
//  Created by Fabio Ferrero on 22/12/2018.
//  Copyright © 2018 Fabio Ferrero. All rights reserved.
//

import Foundation

extension Date {
    
    private func getString(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "IT_it")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var day: Day {
        let string = getString(withFormat: "dd-E")
        let components = string.components(separatedBy: "-")
        
        guard let dayNumber = Int(components[0]) else {
            preconditionFailure("Cannot create a day with value \(string)")
        }
        
        if let weekday = Day.Weekday(from: components[1]) {
            return .dayWeekday(dayNumber, weekday)
        } else {
            return .day(dayNumber)
        }
    }
    
    var month: Month {
        let string = getString(withFormat: "MM")
        guard let monthNumber = Int(string), let month = Month(rawValue: monthNumber) else {
            preconditionFailure("Cannot create a month with value \(string)")
        }
        return month
    }
    
    var year: Year {
        let string = getString(withFormat: "yyy")
        guard let yearNumber = Int(string) else {
            preconditionFailure("Cannot create an year with value \(string)")
        }
        return Year(number: yearNumber)
    }
    
    var components: (day: Day, month: Month, year: Year) {
        return (day, month, year)
    }
}
