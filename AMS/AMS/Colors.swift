//
//  Colors.swift
//  AMS
//
//  Created by Maciej Zajecki on 26/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
            let newRed = CGFloat(red)/255
            let newGreen = CGFloat(green)/255
            let newBlue = CGFloat(blue)/255
            
            self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        }
    
    struct AMSColors {
        static let yellow = UIColor(red: 246, green: 194, blue: 93)
        static let transparentWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        static let transparentYellow = UIColor(red: CGFloat(246/255), green: CGFloat(194/255), blue: CGFloat(93/255), alpha: 1)
        static let lighterBlue = UIColor(red: 64, green: 143, blue: 168)
        static let darkerBlue = UIColor(red: 35, green: 83, blue: 110)
    }
    
}
