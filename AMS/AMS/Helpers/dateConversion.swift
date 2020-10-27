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
    
    func stringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func dateFromString(string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
    
    func basicDateFromString(string: String) -> String {
        let date: Date? = dateFromString(string: string)
        if date != nil {
            let basicFormatter = DateFormatter()
            basicFormatter.dateFormat = "HH:mm dd/MM"
            return basicFormatter.string(from: date!)
        } else {
            return ""
        }

    }
    
}

