//
//  Keychain.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 06/01/2019.
//  Copyright © 2019 fabfer_dev. All rights reserved.
//

import Foundation

final class Keychain {
    
    private init() {}
    
    /// A Key type representing all possible keys into the Keychain
    enum Key: CaseIterable {
        case bestScore      // Int
        case showTutorial   // Bool
        
        var code: String { return String(describing: self) }
    }
    
    static func set(value: Any, for key: Key) {
        UserDefaults.standard.set(value, forKey: key.code)
    }
    
    static func unset(key: Key) {
        UserDefaults.standard.set(nil, forKey: key.code)
    }
    
    static func value<T>(for key: Key) -> T? {
        guard let value = UserDefaults.standard.value(forKey: key.code) as? T? else {
            preconditionFailure("You mistook value type \(T.self) for key \(key).")
        }
        return value
    }
    
    static func reset() {
        for key in Key.allCases {
            Keychain.unset(key: key)
        }
    }
}
