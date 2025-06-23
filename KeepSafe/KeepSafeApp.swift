//
//  KeepSafeApp.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import SwiftUI
import SwiftData

@main
struct KeepSafeApp: App {
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
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}

struct RootView: View {
    @StateObject private var userDefaults = UserDefaultsManager.shared
    
    var body: some View {
        if userDefaults.hasSeenOnboarding {
            ContentView()
                .environmentObject(userDefaults)
        } else {
            OnBoardingView()
                .environmentObject(userDefaults)
        }
    }
}


