//
//  Reminder.swift
//  Plantoo
//
//  Created by subhia  on 10/11/2026.
//

import Foundation

// One plant care reminder. A struct because it is plain data.
struct Reminder: Identifiable {
    // Unique tag, set once and never changed
    let id = UUID()
    var plantName: String
    var room: Room
    var light: Light
    var wateringDays: WateringDays
    var water: Water
    // New reminders start as not done
    var isDone: Bool = false
}
