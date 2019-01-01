//
//  UIButtonExtention.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 11/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import UIKit

extension UIButton {
    
    func pulse() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.1
        pulse.fromValue = 1.0
        pulse.toValue = 1.3
        pulse.autoreverses = true
        //pulse.repeatCount = 0
        pulse.initialVelocity = 1.0
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
}
