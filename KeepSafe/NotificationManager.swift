//
//  NotificationManager.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import Foundation
import UserNotifications
import SwiftData

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    // Request notification permission
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("Notification permission granted")
                } else {
                    print("Notification permission denied")
                }
            }
        }
    }
    
    // Schedule notification for product
    func scheduleExpirationNotification(for item: Item) {
        let identifier = "expiration_\(item.id.uuidString)"
        
        // First cancel existing notification
        cancelNotification(with: identifier)
        
        // Calculate days until expiration
        let daysUntilExpiration = item.daysUntilExpiration
        
        // Determine notification date
        let notificationDate: Date
        let notificationTitle: String
        let notificationBody: String
        
        if daysUntilExpiration <= 3 {
            // If 3 days or less remaining, send notification immediately
            notificationDate = Date().addingTimeInterval(5) // 5 seconds later
            notificationTitle = "🚨 Expiration Alert!"
            
            if daysUntilExpiration <= 0 {
                notificationBody = "\(item.name) has expired!"
            } else if daysUntilExpiration == 1 {
                notificationBody = "\(item.name) expires tomorrow!"
            } else {
                notificationBody = "\(item.name) expires in \(daysUntilExpiration) days!"
            }
        } else {
            // If more than 3 days, schedule notification 3 days before
            guard let threeDaysBeforeExpiration = Calendar.current.date(byAdding: .day, value: -3, to: item.expirationDate),
                  threeDaysBeforeExpiration > Date() else {
                return // Don't schedule if notification date is in the past
            }
            
            notificationDate = threeDaysBeforeExpiration
            notificationTitle = "⏰ Expiration Reminder"
            notificationBody = "\(item.name) expires in 3 days!"
        }
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationBody
        content.sound = .default
        content.categoryIdentifier = "EXPIRATION_REMINDER"
        
        // Add notification badge
        content.badge = NSNumber(value: 1)
        
        // Add additional information
        content.userInfo = [
            "itemId": item.id.uuidString,
            "itemName": item.name,
            "expirationDate": item.expirationDate.timeIntervalSince1970
        ]
        
        // Determine trigger type
        let trigger: UNNotificationTrigger
        
        if daysUntilExpiration <= 3 {
            // Time interval trigger for urgent cases (5 seconds later)
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        } else {
            // Calendar trigger for normal cases
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        }
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error)")
            } else {
                if daysUntilExpiration <= 3 {
                    print("⚡ Urgent notification scheduled for \(item.name) in 5 seconds")
                } else {
                    print("⏰ Normal notification scheduled for \(item.name) at \(notificationDate)")
                }
            }
        }
    }
    
    // Cancel specific notification
    func cancelNotification(with identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // Cancel all notifications for product
    func cancelNotifications(for item: Item) {
        let identifier = "expiration_\(item.id.uuidString)"
        cancelNotification(with: identifier)
    }
    
    // Cancel all notifications
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // Check pending notifications (for debug)
    func checkPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📱 Pending notifications: \(requests.count)")
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    print("📅 Calendar: \(request.identifier): \(request.content.title)")
                    print("   Scheduled for: \(trigger.dateComponents)")
                } else if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                    print("⏱️ TimeInterval: \(request.identifier): \(request.content.title)")
                    print("   In \(trigger.timeInterval) seconds")
                } else {
                    print("❓ Unknown: \(request.identifier): \(request.content.title)")
                }
            }
        }
    }
    
    // Check notification permission status (for debug)
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                print("🔔 Notification permission status: \(settings.authorizationStatus.rawValue)")
                switch settings.authorizationStatus {
                case .notDetermined:
                    print("❓ Permission not determined")
                case .denied:
                    print("❌ Permission denied")
                case .authorized:
                    print("✅ Permission authorized")
                case .provisional:
                    print("📝 Provisional permission")
                case .ephemeral:
                    print("⏰ Ephemeral permission")
                @unknown default:
                    print("🤷‍♂️ Unknown permission status")
                }
                
                print("🔊 Alert setting: \(settings.alertSetting.rawValue)")
                print("🔔 Sound setting: \(settings.soundSetting.rawValue)")
                print("🎯 Badge setting: \(settings.badgeSetting.rawValue)")
            }
        }
    }
    
    // Reschedule notifications for all products
    func rescheduleAllNotifications(for items: [Item]) {
        // First cancel all existing notifications
        cancelAllNotifications()
        
        // Schedule new notification for each product
        for item in items {
            scheduleExpirationNotification(for: item)
        }
    }
} 