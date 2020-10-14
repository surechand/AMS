//
//  PlanDataClasses.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 05/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation

class Day {
    var workouts = [Workout]()
}

class Week {
    var days = [Day]()
}

class Plan {
    var weeks = [Week]()
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
