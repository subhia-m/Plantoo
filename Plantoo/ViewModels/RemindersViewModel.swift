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
    var reminders: [Reminder] = []{
        didSet { save() }
    }
    var now = Date()
    private let storageKey = "savedReminders"

        init() { load() }

  
    // MARK: - Derived state
    func isDone(_ reminder: Reminder) -> Bool { reminder.isDone(on: now) }

        // Today's list: everything except finished plants that were archived
        var todayReminders: [Reminder] {
            reminders.filter { !($0.isArchived && isDone($0)) }
        }
        var isEmpty: Bool { reminders.isEmpty }
        var completedCount: Int { todayReminders.filter { isDone($0) }.count }
        var progress: Double {
            guard !todayReminders.isEmpty else { return 0 }
            return Double(completedCount) / Double(todayReminders.count)
        }
    // An empty today list also counts as all done
      var allDone: Bool {
          !reminders.isEmpty && todayReminders.allSatisfy { isDone($0) }
      }
    var progressMessage: String {
        if completedCount == 0 {
            return "waiting for a sip 💦"
        }
        return "\(completedCount) of your plants feel loved today ✨"
    }
    
    // MARK: - Actions
    func add(_ reminder: Reminder) {
            now = Date()
            // Finished plants leave today's list when a new one is added
            for i in reminders.indices where isDone(reminders[i]) {
                reminders[i].isArchived = true
            }
            reminders.append(reminder)
            NotificationManager.shared.requestPermission()   // asks only the first time
            NotificationManager.shared.schedule(for: reminder)
        }

        func toggle(_ reminder: Reminder) {
            guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }
            now = Date()
            // Checked: remember the date. Unchecked: forget it.
            reminders[index].lastCompletedDate = isDone(reminders[index]) ? nil : now
            reminders[index].isArchived = false
        }

        func delete(_ reminder: Reminder) {
            reminders.removeAll { $0.id == reminder.id }
            NotificationManager.shared.cancel(for: reminder)   // no alerts for a deleted plant
        }

        func update(_ reminder: Reminder) {
            guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }
            reminders[index] = reminder
            NotificationManager.shared.schedule(for: reminder)   // new frequency, new schedule
        }

        // Called when the app comes back to the foreground, so a new day is noticed
        func refresh() { now = Date() }

        // MARK: - Saving
        private func save() {
            if let data = try? JSONEncoder().encode(reminders) {
                UserDefaults.standard.set(data, forKey: storageKey)
            }
        }

        private func load() {
            guard let data = UserDefaults.standard.data(forKey: storageKey),
                  let saved = try? JSONDecoder().decode([Reminder].self, from: data) else { return }
            reminders = saved
        }
    }
