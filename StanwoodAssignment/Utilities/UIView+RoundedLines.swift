//
//  UIView+RoundedLines.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundedLine() {
        let layer: CALayer? = self.layer
        layer?.masksToBounds = true
        layer?.cornerRadius = CGFloat.smallRadius
        layer?.borderColor = UIColor.border.cgColor
        layer?.borderWidth = 1.0
        
    }
    
    func roundedLineMedium() {
        let layer: CALayer? = self.layer
        layer?.masksToBounds = true
        layer?.cornerRadius = CGFloat.mediumRadius
        layer?.borderColor = UIColor.border.cgColor
        layer?.borderWidth = 1.0
        
    }
    
    func roundedLineLarge() {
        let layer: CALayer? = self.layer
        layer?.masksToBounds = true
        layer?.cornerRadius = CGFloat.largeRadius
        layer?.borderColor = UIColor.border.cgColor
        layer?.borderWidth = 1.0
        
    }
    
}
