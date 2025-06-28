//
//  PremiumManager.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import Foundation
import SwiftUI

@MainActor
class PremiumManager: ObservableObject {
    @Published var isPremium: Bool = false
    
    static let shared = PremiumManager()
    
    private init() {
        // Initialize premium status
        checkPremiumStatus()
    }
    
    func checkPremiumStatus() {
        // This will be updated by StoreKitManager
        // For now, we'll use UserDefaults as a fallback
        isPremium = UserDefaults.standard.bool(forKey: "isPremiumActive")
    }
    
    func setPremiumStatus(_ status: Bool) {
        isPremium = status
        UserDefaults.standard.set(status, forKey: "isPremiumActive")
    }
    
    // Premium feature limits
    var maxProducts: Int {
        return isPremium ? Int.max : 3
    }
    
    var maxShoppingItems: Int {
        return isPremium ? Int.max : 3
    }
    
    var hasCloudSync: Bool {
        return isPremium
    }
    
    var hasAnalytics: Bool {
        return isPremium
    }
    
    var hasSmartNotifications: Bool {
        return isPremium
    }
    
    var hasCustomThemes: Bool {
        return isPremium
    }
} 