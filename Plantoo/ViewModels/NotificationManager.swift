//
//  NotificationManager.swift
//  Plantoo
//
//  Created by subhia  on 15/11/2026.
//
import UserNotifications

// Talks to iOS about notifications. The ViewModel calls it, the Views never do.
final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()   // one shared instance for the whole app
    private let center = UNUserNotificationCenter.current()

    override init() {
        super.init()
        center.delegate = self   // needed to show banners while the app is open
    }

    // iOS shows the permission pop-up only once, so calling this again is safe
    func requestPermission() {
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    // Repeats every N days, where N comes from the plant's WateringDays
    func schedule(for reminder: Reminder) {
        cancel(for: reminder)   // remove the old one first, so editing doesn't create duplicates

        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your plant!"   // text from the design
        content.sound = .default

        // Days to seconds (24 hours x 60 minutes x 60 seconds), because notification triggers use seconds
        let seconds = TimeInterval(reminder.wateringDays.intervalInDays * 24 * 60 * 60)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: true)

        // The reminder's id is the notification's id, so we can cancel it later
        let request = UNNotificationRequest(identifier: reminder.id.uuidString,
                                            content: content,
                                            trigger: trigger)
        center.add(request)
    }

    func cancel(for reminder: Reminder) {
        center.removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
    }
    // Without this, iOS hides notifications while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
