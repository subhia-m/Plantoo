//
//  RemindersViewModel.swift
//  Plantoo
//
//  Created by subhia  on 10/11/2026.
//

import Foundation
import Observation

//@Observable lets SwiftUI watch the ViewModel and refresh the screen when its data changes.”
@Observable
// A class (not a struct) so the list, form and progress bar all share the same data
class RemindersViewModel {
    var reminders: [Reminder] = []
  
    // MARK: - Derived state
    
    var isEmpty: Bool {
        reminders.isEmpty
    }
    // $0 = the reminder currently being checked as the array is searched
    var completedCount: Int {
        reminders.filter { $0.isDone }.count
    }
    
    //if the list is empty, return 0 right away and skip the division.”
    var progress: Double {
        guard !reminders.isEmpty else { return 0 }
        return Double(completedCount) / Double(reminders.count)
    }
    
    var allDone: Bool {
        // true only when the list is NOT empty AND every reminder is done
        !reminders.isEmpty && reminders.allSatisfy { $0.isDone }
    }
    
    var progressMessage: String {
        if completedCount == 0 {
            return "waiting for a sip 💦"
        }
        return "\(completedCount) of your plants feel loved today ✨"
    }
    
    // MARK: - Actions
    
    func add(_ reminder: Reminder) {
        reminders.append(reminder)
    }
    
    // Replaces an existing reminder with its edited version
    func update(_ reminder: Reminder) {
        // Find where the old version sits in the array (nil if it isn't there)
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }
        reminders[index] = reminder
    }
    
    //guard let safely unwraps an optional. If the value is nil, the function exits early, so the rest of the code can rely on it
    func toggle(_ reminder: Reminder) {
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }
           reminders[index].isDone.toggle()
        
    }
    
    func delete(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
    }
    
}
