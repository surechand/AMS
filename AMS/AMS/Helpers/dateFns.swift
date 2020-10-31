//
//  dateConversion.swift
//  AMS
//
//  Created by Maciej Zajecki on 25/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation

class DateFns {
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
    
    // returns true if date 1 is newer than date 2
    func compareDates(startDate: String, finishDate: String) -> Bool {
        let date1 = startDate.components(separatedBy: "T")[0].components(separatedBy: "-")
        let date2 = finishDate.components(separatedBy: "T")[0].components(separatedBy: "-")
        if (date1[0] != date2[0]) {
            return date1[0] < date2[0] ? true : false
        } else if (date1[1] != date2[1] ) {
            return date1[1] < date2[1] ? true : false
        } else if (date1[2] != date2[2] ) {
            return date1[1] < date2[1] ? true : false
        }
        let time1 = startDate.components(separatedBy: "T")[1].components(separatedBy: ":")
        let time2 = finishDate.components(separatedBy: "T")[1].components(separatedBy: ":")
        if (time1[0] != time2[0]) {
            return time1[0] < time2[0] ? true : false
        } else {
            return time1[1] < time2[1] ? true : false
        }
    }
    
}

