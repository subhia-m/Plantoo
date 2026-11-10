//
//  RemindersViewModel.swift
//  Plantoo
//
//  Created by subhia  on 10/11/2026.
//

import Foundation
import Observation

@Observable
class RemindersViewModel {
    var reminders: [Reminder] = Reminder.samples
    //For testing: start with Reminder.samples
    // TODO: start empty before final version.
    
    // MARK: - Derived state
    
    var isEmpty: Bool {
        reminders.isEmpty
    }
    
    var completedCount: Int {
        reminders.filter { $0.isDone }.count
    }
    
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
    
    func toggle(_ reminder: Reminder) {
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }
        reminders[index].isDone.toggle()
    }
    
    func delete(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
    }
    
}
