//
//  UserDefaultsManager.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import Foundation

class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()
    
    // MARK: - Keys
    private enum Keys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let notificationsEnabled = "notificationsEnabled"
        static let selectedLanguage = "selectedLanguage"
        static let appVersion = "appVersion"
        static let lastSyncDate = "lastSyncDate"
        static let preferredDateFormat = "preferredDateFormat"
        static let sortPreference = "sortPreference"
    }
    
    // MARK: - Properties
    @Published var hasSeenOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenOnboarding, forKey: Keys.hasSeenOnboarding)
        }
    }
    
    @Published var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: Keys.notificationsEnabled)
        }
    }
    
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: Keys.selectedLanguage)
        }
    }
    
    @Published var preferredDateFormat: String {
        didSet {
            UserDefaults.standard.set(preferredDateFormat, forKey: Keys.preferredDateFormat)
        }
    }
    
    @Published var sortPreference: String {
        didSet {
            UserDefaults.standard.set(sortPreference, forKey: Keys.sortPreference)
        }
    }
    
    // MARK: - Initialization
    private init() {
        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: Keys.hasSeenOnboarding)
        self.notificationsEnabled = UserDefaults.standard.object(forKey: Keys.notificationsEnabled) as? Bool ?? true
        self.selectedLanguage = UserDefaults.standard.string(forKey: Keys.selectedLanguage) ?? "en"
        self.preferredDateFormat = UserDefaults.standard.string(forKey: Keys.preferredDateFormat) ?? "medium"
        self.sortPreference = UserDefaults.standard.string(forKey: Keys.sortPreference) ?? "expiration"
    }
    
    // MARK: - Methods
    func setAppVersion(_ version: String) {
        UserDefaults.standard.set(version, forKey: Keys.appVersion)
    }
    
    func getAppVersion() -> String? {
        return UserDefaults.standard.string(forKey: Keys.appVersion)
    }
    
    func setLastSyncDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: Keys.lastSyncDate)
    }
    
    func getLastSyncDate() -> Date? {
        return UserDefaults.standard.object(forKey: Keys.lastSyncDate) as? Date
    }
    
    func resetAllSettings() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        // Reset published properties
        hasSeenOnboarding = false
        notificationsEnabled = true
        selectedLanguage = "en"
        preferredDateFormat = "medium"
        sortPreference = "expiration"
    }
    
    func exportSettings() -> [String: Any] {
        return [
            Keys.hasSeenOnboarding: hasSeenOnboarding,
            Keys.notificationsEnabled: notificationsEnabled,
            Keys.selectedLanguage: selectedLanguage,
            Keys.preferredDateFormat: preferredDateFormat,
            Keys.sortPreference: sortPreference
        ]
    }
    
    func importSettings(_ settings: [String: Any]) {
        if let hasSeenOnboarding = settings[Keys.hasSeenOnboarding] as? Bool {
            self.hasSeenOnboarding = hasSeenOnboarding
        }
        if let notificationsEnabled = settings[Keys.notificationsEnabled] as? Bool {
            self.notificationsEnabled = notificationsEnabled
        }
        if let selectedLanguage = settings[Keys.selectedLanguage] as? String {
            self.selectedLanguage = selectedLanguage
        }
        if let preferredDateFormat = settings[Keys.preferredDateFormat] as? String {
            self.preferredDateFormat = preferredDateFormat
        }
        if let sortPreference = settings[Keys.sortPreference] as? String {
            self.sortPreference = sortPreference
        }
    }
} 