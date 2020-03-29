//
//  CalendarVars.swift
//  Calendar
//
//  Created by gandrey on 29/03/2020.
//  Copyright © 2020 GlAndrey. All rights reserved.
//

import Foundation


let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day, from: date)
var weekday = calendar.component(.weekday, from: date) - 1
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)
