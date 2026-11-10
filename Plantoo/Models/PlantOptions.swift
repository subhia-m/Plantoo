//
//  PlantsOperation.swift
//  Plantoo
//
//  Created by subhia  on 10/11/2026.
//

import Foundation

// MARK:- Light

// String = each case has a text value (rawValue)
// CaseIterable = gives me "enum".allCases for the Picker
// Identifiable = lets SwiftUI tell each case apart in ForEach
enum Light: String, CaseIterable, Identifiable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case lowLight = "Low Light"
    
    // Required by Identifiable. Uses the display text as the unique id.
    var id: String { rawValue }
}

// MARK:- Room
enum Room: String, CaseIterable, Identifiable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    case bathroom = "Bathroom"
    
    // Required by Identifiable. Uses the display text as the unique id.
    var id: String { rawValue }
}

// MARK:- watering Days
enum WateringDays: String, CaseIterable, Identifiable {
    
    case daily = "Every day"
    case everyTwoDays = "Every 2 days"
    case everyThreeDays = "Every 3 days"
    case weekly = "Once a week"
    case everyTenDays = "Every 10 days"
    case everyTwoWeeks = "Every 2 weeks"
    
    // Required by Identifiable. Uses the display text as the unique id.
    var id: String { rawValue }
    
    // Turns the case into a number of days, because notifications need numbers, not text.
    var intervalInDays: Int {
        // Look at which case this is and return the matching number
        switch self {
        case .daily: return 1
        case .everyTwoDays: return 2
        case .everyThreeDays: return 3
        case .weekly: return 7
        case .everyTenDays: return 10
        case .everyTwoWeeks: return 14
        }
    }
}


// MARK:- Water
enum Water: String, CaseIterable, Identifiable {
    
    case low = "20-50 ml"
    case moderate = "50-100 ml"
    case high = "100-200 ml"
    case veryHigh = "200-300 ml"
    
    // Required by Identifiable. Uses the display text as the unique id.
    var id: String { rawValue }
}
