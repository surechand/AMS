//
//  dateConversion.swift
//  AMS
//
//  Created by Maciej Zajecki on 25/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation

class DateConversion {
    let dateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
    let basicDateFormatter: DateFormatter = DateFormatter()
    
    func stringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func dateFromString(string: String) -> Date {
        return dateFormatter.date(from: string) ?? Date()
    }
    
    func stringFromDate(date: Date, format: String) -> String {
        basicDateFormatter.dateFormat = format
        return basicDateFormatter.string(from: date)
    }
}

