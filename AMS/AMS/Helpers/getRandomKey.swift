//
//  getRandomKey.swift
//  AMS
//
//  Created by Angelika Jeziorska on 24/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation

func randomKey() -> String {
  let signs = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+?><:"
  return String((0..<11).map{ _ in signs.randomElement()! })
}
