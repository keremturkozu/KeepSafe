//
//  NotificationDelegate.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    static let shared = NotificationDelegate()
    
    override init() {
        super.init()
    }
    
    // Called when notification arrives while app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is open
        completionHandler([.alert, .sound, .badge])
    }
    
    // Called when user taps on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        
        if identifier.hasPrefix("expiration_") {
            // Expiration notification - redirect to product list
            // Navigation logic can be added here if needed
            print("User tapped expiration notification: \(identifier)")
        }
        
        completionHandler()
    }
} 