//
//  Reminder+Sample.swift
//  Plantoo
//
//  Created by subhia  on 10/11/2026.
//

import Foundation
// An extension adds to Reminder without editing Reminder.swift,
// so the model file stays short and only describes the data.
extension Reminder {
    // Fake data so I can see something on screen before the form works
    static let samples: [Reminder] = [
        Reminder(plantName: "Monstera", room: .kitchen, light: .fullSun,
                 wateringDays: .daily, water: .low),
   
        Reminder(plantName: "Pothos", room: .bedroom, light: .partialSun,
                 wateringDays: .daily, water: .low),

        Reminder(plantName: "Orchid", room: .livingRoom, light: .partialSun,
                 wateringDays: .daily, water: .low),

        Reminder(plantName: "Spider", room: .kitchen, light: .fullSun,
                 wateringDays: .everyTwoWeeks, water: .low)
    ]
}
