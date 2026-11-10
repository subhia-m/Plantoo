//
//  Reminder+Sample.swift
//  Plantoo
//
//  Created by subhia  on 10/11/2026.
//

import Foundation

extension Reminder {
    // Fake data so I can see something on screen before the form works
    static let samples: [Reminder] = [
        Reminder(plantName: "Monstera", room: .kitchen, light: .fullSun,
                 wateringDays: .daily, water: .low, isDone: true),
   
        Reminder(plantName: "Pothos", room: .bedroom, light: .fullSun,
                 wateringDays: .daily, water: .low),

        Reminder(plantName: "Orchid", room: .livingRoom, light: .partialSun,
                 wateringDays: .daily, water: .low),

        Reminder(plantName: "Spider", room: .kitchen, light: .fullSun,
                 wateringDays: .everyTwoWeeks, water: .low)
    ]
}
