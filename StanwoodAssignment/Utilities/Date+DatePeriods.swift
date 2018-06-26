//
//  Date+DatePeriods.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import Foundation

extension Date {
    
    func pastMonth() -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.month = -1
        
        return calendar.date(byAdding: components, to: self)
    }
    
    func pastWeek() -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.day = -7
        
        return calendar.date(byAdding: components, to: self)
    }
    
    func pastDay() -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.day = -1
        
        return calendar.date(byAdding: components, to: self)
    }
    
    func toStringISO() -> String {
        
        let dateString = Formatter.iso8601.string(from: self)
        
        return dateString
    }
}
