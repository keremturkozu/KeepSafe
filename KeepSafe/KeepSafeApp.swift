//
//  KeepSafeApp.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct KeepSafeApp: App {
    @StateObject private var notificationManager = NotificationManager.shared
    
    init() {
        // Bildirim delegate'ini ayarla
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            ShoppingItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environmentObject(UserDefaultsManager.shared)
                .environmentObject(notificationManager)
                .onAppear {
                    // Uygulama başladığında bildirim izni iste
                    notificationManager.requestPermission()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

struct RootView: View {
    @EnvironmentObject private var userDefaults: UserDefaultsManager
    @StateObject private var premiumManager = PremiumManager.shared
    @State private var showPremiumView = false
    @State private var showRatingRequest = false
    
    var body: some View {
        Group {
            if userDefaults.hasSeenOnboarding {
                ContentView()
                    .environmentObject(userDefaults)
                    .onAppear {
                        checkForPremiumAndRating()
                    }
            } else {
                OnBoardingView()
                    .environmentObject(userDefaults)
            }
        }
        .sheet(isPresented: $showPremiumView) {
            PremiumView()
        }
        .sheet(isPresented: $showRatingRequest) {
            RatingRequestView()
        }
        .onChange(of: userDefaults.hasSeenOnboarding) { _, hasSeenOnboarding in
            if hasSeenOnboarding {
                // OnBoarding tamamlandı, premium göster
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if !premiumManager.isPremium {
                        showPremiumView = true
                    }
                }
            }
        }
    }
    
    private func checkForPremiumAndRating() {
        // Premium kontrolü
        if !premiumManager.isPremium {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showPremiumView = true
            }
        }
        
        // Rating kontrolü
        let hasRated = UserDefaults.standard.bool(forKey: "hasRatedApp")
        if !hasRated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showRatingRequest = true
            }
        }
    }
}


