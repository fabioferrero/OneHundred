//
//  Day.swift
//  App Architecture
//
//  Created by Fabio Ferrero on 22/12/2018.
//  Copyright © 2018 Fabio Ferrero. All rights reserved.
//

import Foundation

extension Date {
    
    enum Day {
        case day(Int)
        case weekday(Weekday)
        case dayWeekday(Int, Weekday)
        
        enum Weekday {
            case monday
            case tuesday
            case wednsday
            case thursday
            case friday
            case saturday
            case sunday
        }
    }
}

extension Date.Day: CustomStringConvertible {
    var description: String {
        switch self {
        case .day(let dayNumber): return dayNumber.description
        case .weekday(let weekday): return weekday.description
        case .dayWeekday(let dayNumber, let weekday): return "\(weekday) \(dayNumber)"
        }
    }
}

extension Date.Day.Weekday {
    
    init?(from string: String) {
        switch string.uppercased() {
        case "LUNEDÌ", "LUN": self = .monday
        case "MARTEDÌ", "MAR": self = .tuesday
        case "MERCOLEDÌ", "MER": self = .wednsday
        case "GIOVEDÌ", "GIO": self = .thursday
        case "VENERDÌ", "VEN": self = .friday
        case "SABATO", "SAB": self = .saturday
        case "DOMENICA", "DOM": self = .sunday
        default: return nil
        }
    }
    
    var shortString: String {
        return String(self.description.prefix(3))
    }
}

extension Date.Day.Weekday: CustomStringConvertible {
    var description: String {
        switch self {
        case .monday: return "lunedì"
        case .tuesday: return "martedì"
        case .wednsday: return "mercoledì"
        case .thursday: return "giovedì"
        case .friday: return "venerdì"
        case .saturday: return "sabato"
        case .sunday: return "domenica"
        }
    }
}
