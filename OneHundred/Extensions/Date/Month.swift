//
//  Month.swift
//  App Architecture
//
//  Created by Fabio Ferrero on 22/12/2018.
//  Copyright © 2018 Fabio Ferrero. All rights reserved.
//

import Foundation

extension Date {
    
    enum Month: Int {
        case january = 1
        case february
        case march
        case april
        case may
        case june
        case july
        case agoust
        case september
        case october
        case november
        case december
    }
}

extension Date.Month: CustomStringConvertible {
    var description: String {
        switch self {
        case .january: return "Gennaio"
        case .february: return "Febbraio"
        case .march: return "Marzo"
        case .april: return "Aprile"
        case .may: return "Maggio"
        case .june: return "Giugno"
        case .july: return "Luglio"
        case .agoust: return "Agosto"
        case .september: return "Settembre"
        case .october: return "Ottobre"
        case .november: return "Novembre"
        case .december: return "Dicembre"
        }
    }
}

extension Date.Month: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        switch value {
        case 1: self = .january
        case 2: self = .february
        case 3: self = .march
        case 4: self = .april
        case 5: self = .may
        case 6: self = .june
        case 7: self = .july
        case 8: self = .agoust
        case 9: self = .september
        case 10: self = .october
        case 11: self = .november
        case 12: self = .december
        default:
            preconditionFailure("Impossible to create a month with value \(value)")
        }
    }
}
