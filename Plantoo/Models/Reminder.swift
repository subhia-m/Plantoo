//
//  Reminder.swift
//  Plantoo
//
//  Created by subhia  on 10/11/2026.
//

import Foundation

// One plant care reminder. A struct because it is plain data.
struct Reminder: Identifiable, Codable {
    // Unique tag, set once and never changed
    var id = UUID()
    var plantName: String
    var room: Room
    var light: Light
    var wateringDays: WateringDays
    var water: Water
    // New reminders start as not done
   // var isDone: Bool = false
    
    var lastCompletedDate: Date?
        // true = finished plant that has left today's list
        var isArchived = false

        // Done = the next due date hasn't arrived yet
        func isDone(on date: Date = Date()) -> Bool {
            guard let last = lastCompletedDate else { return false }
            let calendar = Calendar.current
            let start = calendar.startOfDay(for: last)
            guard let nextDue = calendar.date(byAdding: .day,
                                              value: wateringDays.intervalInDays,
                                              to: start) else { return false }
            return date < nextDue
        }
}
