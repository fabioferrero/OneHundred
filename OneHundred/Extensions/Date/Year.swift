//
//  Year.swift
//  App Architecture
//
//  Created by Fabio Ferrero on 22/12/2018.
//  Copyright © 2018 Fabio Ferrero. All rights reserved.
//

import Foundation

extension Date {
    
    struct Year {
        var number: Int
    }
}

extension Date.Year: CustomStringConvertible {
    var description: String {
        return number.description
    }
}

extension Date.Year: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self.init(number: value)
    }
}
