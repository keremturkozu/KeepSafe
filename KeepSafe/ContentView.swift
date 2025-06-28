//
//  ContentView.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject private var premiumManager = PremiumManager.shared
    
    private var tabTintColor: Color {
        switch selectedTab {
        case 0: return Color(red: 0.2, green: 0.4, blue: 0.8) // Blue for Products
        case 1: return Color(red: 0.6, green: 0.4, blue: 0.8) // Purple for Add
        case 2: return Color(red: 0.2, green: 0.6, blue: 0.4) // Green for Shopping
        default: return Color(red: 0.2, green: 0.4, blue: 0.8)
        }
    }
    
    var body: some View {
        ZStack {
            // Premium Light Gradient Background
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 0.95, green: 0.97, blue: 1.0), location: 0.0),
                    .init(color: Color(red: 0.92, green: 0.95, blue: 0.98), location: 0.3),
                    .init(color: Color(red: 0.88, green: 0.92, blue: 0.96), location: 0.7),
                    .init(color: Color(red: 0.85, green: 0.90, blue: 0.95), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all)
            
            // Subtle overlay for depth
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.05),
                    Color.clear,
                    Color.purple.opacity(0.03)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all)
            
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    ProductListView(selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: selectedTab == 0 ? "cube.box.fill" : "cube.box")
                            Text("Products")
                        }
                        .tag(0)
                    
                    AddItemView()
                        .tabItem {
                            Image(systemName: selectedTab == 1 ? "plus.circle.fill" : "plus.circle")
                            Text("Add")
                        }
                        .tag(1)
                    
                    ShoppingListView(selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: selectedTab == 2 ? "cart.fill" : "cart")
                            Text("Shopping")
                        }
                        .tag(2)
                }
                .tint(tabTintColor)
                .onChange(of: selectedTab) { _, newValue in
                    updateTabBarAppearance()
                }
                .onAppear {
                    updateTabBarAppearance()
                }
            }
        }
        .preferredColorScheme(.light)
    }
    
    private func updateTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        // Tab bar background with blur effect
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        // Get current tab color
        let currentColor = UIColor(tabTintColor)
        
        // Selected tab styling
        appearance.stackedLayoutAppearance.selected.iconColor = currentColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: currentColor,
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]
        
        // Unselected tab styling
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct ProductListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.expirationDate) private var items: [Item]
    @EnvironmentObject private var notificationManager: NotificationManager
    @State private var searchText = ""
    @State private var showingSettings = false
    @Binding var selectedTab: Int
    
    private var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Clean White Background
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header
                    VStack(spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Products")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.2, green: 0.4, blue: 0.8),
                                                Color(red: 0.3, green: 0.5, blue: 0.9)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("Track your products")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingSettings = true
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 40, height: 40)
                                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // Search Bar (if items exist)
                        if !filteredItems.isEmpty {
                            HStack {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    
                                    TextField("Search products...", text: $searchText)
                                        .foregroundColor(.black)
                                        .tint(Color(red: 0.2, green: 0.4, blue: 0.8))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 10)
                        }
                    }
                    .background(Color.clear)
                    
                    // Content Area
                    if filteredItems.isEmpty {
                        PremiumEmptyStateView(selectedTab: $selectedTab)
                    } else {
                        List {
                            ForEach(filteredItems) { item in
                                PremiumProductRowView(item: item)
                                    .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: deleteItems)
                            
                            // Bottom spacing
                            Color.clear
                                .frame(height: 100)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onAppear {
            // View göründüğünde tüm ürünler için bildirimleri zamanla
            notificationManager.rescheduleAllNotifications(for: items)
            
            // Debug: Bildirim izni ve pending bildirimleri kontrol et
            notificationManager.checkNotificationPermission()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                notificationManager.checkPendingNotifications()
            }
        }
        .onChange(of: items) { _, newItems in
            // Ürünler değiştiğinde bildirimleri güncelle
            notificationManager.rescheduleAllNotifications(for: newItems)
            
            // Debug: Yeni bildirimler zamanlandıktan sonra kontrol et
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                notificationManager.checkPendingNotifications()
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation(.smooth) {
            for index in offsets {
                let item = filteredItems[index]
                // Ürün silinmeden önce bildirimini iptal et
                notificationManager.cancelNotifications(for: item)
                modelContext.delete(item)
            }
        }
    }
}

struct PremiumProductRowView: View {
    let item: Item
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Left: Compact Image
            Group {
                if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(statusColor(for: item).opacity(0.12))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: categoryIcon(for: item.category))
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(statusColor(for: item))
                    }
                }
            }
            
            // Right: Content
            VStack(alignment: .leading, spacing: 2) {
                // Row 1: Product name + Day count
                HStack(alignment: .firstTextBaseline) {
                    Text(item.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer(minLength: 8)
                    
                    HStack(spacing: 2) {
                        Text("\(abs(item.daysUntilExpiration))")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(statusColor(for: item))
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("days")
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(.secondary)
                            Text(item.daysUntilExpiration >= 0 ? "left" : "ago")
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Row 2: Category
                HStack(spacing: 4) {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(item.category)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 1)
                
                // Row 3: Date + Status
                HStack {
                    HStack(spacing: 3) {
                        Image(systemName: "calendar")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text(item.expirationDate, formatter: dateFormatter)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Status Badge
                    Text(statusText(for: item))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(statusColor(for: item))
                        )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 0.8)
                )
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, perform: {}, onPressingChanged: { isPressing in
            isPressed = isPressing
        })
    }
    
    // Helper function for category icons
    private func categoryIcon(for category: String) -> String {
        switch category.lowercased() {
        case "food & drinks", "food", "drinks":
            return "fork.knife.circle.fill"
        case "medicine", "health":
            return "medical.thermometer.fill"
        case "cosmetics", "beauty":
            return "paintbrush.pointed.fill"
        case "cleaning":
            return "bubbles.and.suds.fill"
        default:
            return "cube.box.fill"
        }
    }
    
    private func statusColor(for item: Item) -> Color {
        let days = item.daysUntilExpiration
        if item.isExpired { 
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        }
        else if days <= 3 { 
            return Color(red: 1.0, green: 0.6, blue: 0.0)
        }
        else if days <= 7 { 
            return Color(red: 1.0, green: 0.8, blue: 0.0)
        }
        else { 
            return Color(red: 0.2, green: 0.9, blue: 0.6)
        }
    }
    
    private func statusText(for item: Item) -> String {
        if item.isExpired { return "Expired" }
        else if item.daysUntilExpiration <= 3 { return "Expiring Soon" }
        else if item.daysUntilExpiration <= 7 { return "Expiring This Week" }
        else { return "Fresh" }
    }
}

struct PremiumEmptyStateView: View {
    @Binding var selectedTab: Int
    @State private var animateGlow = false
    @State private var animateBounce = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                // Hero Icon with Glow Effect
                ZStack {
                    // Glow Effect
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.cyan.opacity(animateGlow ? 0.3 : 0.1),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 50,
                                endRadius: 120
                            )
                        )
                        .frame(width: 240, height: 240)
                        .scaleEffect(animateGlow ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateGlow)
                    
                    // Main Icon Container
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 120, height: 120)
                            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                        
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.cyan.opacity(0.8),
                                        Color.blue.opacity(0.6),
                                        Color.purple.opacity(0.4)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "cube.transparent")
                            .font(.system(size: 45, weight: .light))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.cyan,
                                        Color.blue
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .scaleEffect(animateBounce ? 1.1 : 1.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).repeatForever(autoreverses: true), value: animateBounce)
                    }
                }
                
                // Text Content
                VStack(spacing: 16) {
                    Text("Your Product Vault")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    
                    Text("Looks empty in here!\nStart building your digital inventory by adding your first product.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 32)
                }
                
                // CTA Button
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        selectedTab = 1
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        
                        Text("Add First Product")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.2, green: 0.4, blue: 0.8),
                                Color(red: 0.3, green: 0.5, blue: 0.9)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.3), radius: 15, x: 0, y: 8)
                }
                .scaleEffect(animateBounce ? 1.05 : 1.0)
            }
            
            Spacer()
            Spacer()
        }
        .onAppear {
            animateGlow = true
            animateBounce = true
        }
    }
}

struct AddItemView: View {
    @State private var animateCards = false
    @State private var productCardPressed = false
    @State private var shoppingCardPressed = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Clean White Background
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                // Header Section
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Add Something New")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.2, green: 0.4, blue: 0.8),
                                        Color(red: 0.3, green: 0.5, blue: 0.9)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .multilineTextAlignment(.center)
                        
                        Text("Choose what you'd like to track")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 60)
                }
                
                Spacer()
                
                // Cards Section - Centered
                VStack(spacing: 32) {
                    // Product Tracking Card
                    NavigationLink(destination: AddProductView()) {
                        VStack(spacing: 20) {
                            // Icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.1),
                                                Color(red: 0.3, green: 0.5, blue: 0.9).opacity(0.05)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "cube.box.fill")
                                    .font(.system(size: 36, weight: .medium))
                                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                            }
                            
                            // Content
                            VStack(spacing: 8) {
                                Text("Track Products")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("Add products with\nexpiration dates and photos")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                
                                HStack(spacing: 6) {
                                    Text("Start tracking")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                                }
                                .padding(.top, 8)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white)
                                .shadow(color: Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.15), radius: 20, x: 0, y: 10)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.2), lineWidth: 2)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(productCardPressed ? 0.95 : (animateCards ? 1.0 : 0.9))
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: productCardPressed)
                    .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, perform: {}, onPressingChanged: { isPressing in
                        productCardPressed = isPressing
                    })
                    
                    // Shopping List Card
                    NavigationLink(destination: AddShoppingItemView()) {
                        VStack(spacing: 20) {
                            // Icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.1),
                                                Color(red: 0.3, green: 0.7, blue: 0.5).opacity(0.05)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "cart.fill")
                                    .font(.system(size: 36, weight: .medium))
                                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.4))
                            }
                            
                            // Content
                            VStack(spacing: 8) {
                                Text("Shopping List")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("Add items to your\nshopping list")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                
                                HStack(spacing: 6) {
                                    Text("Add items")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.4))
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.4))
                                }
                                .padding(.top, 8)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white)
                                .shadow(color: Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.15), radius: 20, x: 0, y: 10)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.2), lineWidth: 2)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(shoppingCardPressed ? 0.95 : (animateCards ? 1.0 : 0.9))
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: shoppingCardPressed)
                    .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, perform: {}, onPressingChanged: { isPressing in
                        shoppingCardPressed = isPressing
                    })
                }
                .padding(.horizontal, 32)
                
                Spacer()
                Spacer()
            }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            animateCards = true
        }
    }
}

struct ShoppingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var shoppingItems: [ShoppingItem]
    @State private var searchText = ""
    @State private var showingSettings = false
    @Binding var selectedTab: Int
    
    private var filteredItems: [ShoppingItem] {
        if searchText.isEmpty {
            return shoppingItems.sorted { !$0.isCompleted && $1.isCompleted }
        } else {
            return shoppingItems.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                .sorted { !$0.isCompleted && $1.isCompleted }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Clean White Background
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header
                    VStack(spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Shopping List")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.2, green: 0.6, blue: 0.4),
                                                Color(red: 0.3, green: 0.7, blue: 0.5)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("Never forget to buy")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingSettings = true
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 40, height: 40)
                                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.4))
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // Search Bar (if items exist)
                        if !filteredItems.isEmpty {
                            HStack {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    
                                    TextField("Search shopping items...", text: $searchText)
                                        .foregroundColor(.black)
                                        .tint(Color(red: 0.2, green: 0.6, blue: 0.4))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 10)
                        }
                    }
                    .background(Color.clear)
                    
                    // Content Area
                    if filteredItems.isEmpty {
                        PremiumEmptyShoppingView(selectedTab: $selectedTab)
                    } else {
                        List {
                            ForEach(filteredItems) { item in
                                PremiumShoppingRowView(item: item)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 24, bottom: 5, trailing: 24))
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: deleteShoppingItems)
                            
                            // Bottom spacing
                            Color.clear
                                .frame(height: 100)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
    
    private func deleteShoppingItems(offsets: IndexSet) {
        withAnimation(.smooth) {
            for index in offsets {
                modelContext.delete(filteredItems[index])
            }
        }
    }
}

struct PremiumShoppingRowView: View {
    let item: ShoppingItem
    @Environment(\.modelContext) private var modelContext
    @State private var isPressed = false
    @State private var showCheckmark = false
    
    var body: some View {
        ZStack {
            // Modern background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            item.isCompleted ? 
                            Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.3) : 
                            Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.2), 
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
            
            HStack(spacing: 16) {
                // Checkbox with Animation
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        item.isCompleted.toggle()
                        showCheckmark = item.isCompleted
                    }
                    
                    // Haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    try? modelContext.save()
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                item.isCompleted ? 
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.2, green: 0.6, blue: 0.4), 
                                        Color(red: 0.3, green: 0.7, blue: 0.5)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.clear, Color.clear]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(
                                        item.isCompleted ? Color.clear : Color.gray.opacity(0.6),
                                        lineWidth: 2
                                    )
                            )
                            .scaleEffect(showCheckmark ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showCheckmark)
                        
                        if item.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .scaleEffect(showCheckmark ? 1.0 : 0.0)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1), value: showCheckmark)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.name)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(item.isCompleted ? .gray : .black)
                        .strikethrough(item.isCompleted)
                        .animation(.easeInOut(duration: 0.3), value: item.isCompleted)
                    
                    HStack(spacing: 6) {
                        Image(systemName: categoryIcon(for: item.category))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(item.category)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        if item.isCompleted {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption2)
                                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.4))
                                
                                Text("Done")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.4))
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.1))
                            .clipShape(Capsule())
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .opacity(item.isCompleted ? 0.7 : 1.0)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onAppear {
            showCheckmark = item.isCompleted
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, perform: {}, onPressingChanged: { isPressing in
            isPressed = isPressing
        })
    }
    
    private func categoryIcon(for category: String) -> String {
        switch category {
        case "Food & Drinks": return "fork.knife"
        case "Household": return "house.fill"
        case "Personal Care": return "person.fill"
        case "Electronics": return "bolt.fill"
        case "Clothing": return "tshirt.fill"
        case "Health": return "cross.fill"
        case "Pet Supplies": return "pawprint.fill"
        default: return "tag.fill"
        }
    }
}

struct PremiumEmptyShoppingView: View {
    @Binding var selectedTab: Int
    @State private var animateCart = false
    @State private var animateItems = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                // Animated Shopping Cart
                ZStack {
                    // Background Glow
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.green.opacity(animateCart ? 0.3 : 0.1),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 40,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .scaleEffect(animateCart ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: animateCart)
                    
                    // Cart Icon
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 100, height: 100)
                            .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
                        
                        Image(systemName: "cart.fill")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.green,
                                        Color.mint
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .rotationEffect(.degrees(animateItems ? 5 : -5))
                            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animateItems)
                    }
                    
                    // Floating Items
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: ["leaf.fill", "drop.fill", "star.fill"][index])
                            .font(.title3)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        [Color(red: 0.2, green: 0.8, blue: 0.4), Color(red: 0.1, green: 0.6, blue: 0.9), Color(red: 0.9, green: 0.7, blue: 0.2)][index],
                                        [Color(red: 0.3, green: 0.9, blue: 0.5), Color(red: 0.2, green: 0.7, blue: 1.0), Color(red: 1.0, green: 0.8, blue: 0.3)][index]
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .offset(
                                x: [60, -60, 0][index],
                                y: [-40, -20, -60][index]
                            )
                            .scaleEffect(animateItems ? 1.2 : 0.8)
                            .opacity(animateItems ? 1.0 : 0.7)
                            .animation(
                                .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.3),
                                value: animateItems
                            )
                    }
                }
                
                // Text Content
                VStack(spacing: 16) {
                    Text("Shopping Made Simple")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    
                    Text("Your shopping list is waiting!\nAdd items you need and never forget them again.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 32)
                }
                
                // CTA Button
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        selectedTab = 1
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "cart.badge.plus")
                            .font(.title3)
                        
                        Text("Start Shopping List")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.2, green: 0.6, blue: 0.4),
                                Color(red: 0.3, green: 0.7, blue: 0.5)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.3), radius: 15, x: 0, y: 8)
                }
                .scaleEffect(animateCart ? 1.05 : 1.0)
            }
            
            Spacer()
            Spacer()
        }
        .onAppear {
            animateCart = true
            animateItems = true
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingPremium = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Modern Light Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.97, green: 0.98, blue: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        VStack(spacing: 16) {
                            Text("Settings")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.2, green: 0.4, blue: 0.8),
                                            Color(red: 0.3, green: 0.5, blue: 0.9)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("Customize your Fridge experience")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 24)
                        
                        // Settings Cards
                        VStack(spacing: 16) {
                            // Premium Section
                            Button(action: {
                                showingPremium = true
                            }) {
                                HStack(spacing: 16) {
                                    // Premium Icon
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color(red: 1.0, green: 0.8, blue: 0.0),
                                                        Color(red: 1.0, green: 0.6, blue: 0.0)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "crown.fill")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(.black)
                                    }
                                    
                                    // Content
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Upgrade to Premium")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.black)
                                        
                                        Text("Unlock all features")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    // Arrow
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray.opacity(0.6))
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 1.0, green: 0.8, blue: 0.0).opacity(0.1),
                                            Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.05)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(red: 1.0, green: 0.8, blue: 0.0).opacity(0.3), lineWidth: 2)
                                )
                                .shadow(color: Color(red: 1.0, green: 0.8, blue: 0.0).opacity(0.2), radius: 12, x: 0, y: 6)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Settings Section
                            VStack(spacing: 12) {
                                // Notifications
                                Button(action: {
                                    print("Notifications button tapped")
                                    // Ayarlar sayfasına yönlendir
                                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(settingsURL)
                                    }
                                }) {
                                    ModernSettingsRowContent(icon: "bell.fill", title: "Notifications", subtitle: "Manage notification settings", color: Color(red: 1.0, green: 0.6, blue: 0.2))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Support Section
                            VStack(spacing: 12) {
                                // Privacy
                                NavigationLink(destination: PrivacyView()) {
                                    ModernSettingsRowContent(icon: "lock.shield.fill", title: "Privacy", subtitle: "Data & security", color: Color(red: 0.2, green: 0.7, blue: 0.5))
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Help & Support
                                Button(action: {
                                    print("Help & Support button tapped")
                                    sendSupportEmail()
                                }) {
                                    ModernSettingsRowContent(icon: "questionmark.circle.fill", title: "Help & Support", subtitle: "Contact support", color: Color(red: 0.3, green: 0.5, blue: 0.9))
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // About
                                NavigationLink(destination: AboutView()) {
                                    ModernSettingsRowContent(icon: "info.circle.fill", title: "About", subtitle: "App information", color: Color(red: 0.6, green: 0.4, blue: 0.8))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingPremium) {
            PremiumView()
        }
    }
    
    private func sendSupportEmail() {
        let email = "turkozukerem@gmail.com"
        let subject = "Fridge Support Request"
        let body = "Hello,\n\nI need help with Fridge app.\n\nDevice: \(UIDevice.current.model)\niOS Version: \(UIDevice.current.systemVersion)\nApp Version: 1.0\n\nDescription:\n"
        
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let mailURL = "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)"
        
        if let url = URL(string: mailURL) {
            UIApplication.shared.open(url)
        }
    }
}

struct ModernSettingsRowContent: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Container
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.97, green: 0.98, blue: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            // App Icon
                            Image(systemName: "cube.box.fill")
                                .font(.system(size: 80, weight: .medium))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.2, green: 0.4, blue: 0.8),
                                            Color(red: 0.3, green: 0.5, blue: 0.9)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            VStack(spacing: 8) {
                                Text("Fridge")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                                
                                Text("Version 1.0")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 40)
                        
                        // Description
                        VStack(spacing: 24) {
                            VStack(spacing: 16) {
                                Text("Your Smart Expiration Tracker")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                
                                Text("Fridge helps you track product expiration dates and never waste food again. Get intelligent notifications before your products expire and maintain a smart shopping list.")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                            
                            // Features
                            VStack(spacing: 16) {
                                FeatureRowView(icon: "cube.box.fill", title: "Product Tracking", description: "Track expiration dates with photos")
                                FeatureRowView(icon: "bell.fill", title: "Smart Notifications", description: "Get alerts before products expire")
                                FeatureRowView(icon: "cart.fill", title: "Shopping Lists", description: "Organize your shopping needs")
                                FeatureRowView(icon: "crown.fill", title: "Premium Features", description: "Unlimited products and advanced features")
                            }
                        }
                        
                        // Developer Info
                        VStack(spacing: 16) {
                            Divider()
                                .padding(.horizontal, 40)
                            
                            VStack(spacing: 8) {
                                Text("Developed by")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("Kerem Türközü")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text("© 2025 Fridge. All rights reserved.")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRowView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.97, green: 0.98, blue: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 60, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.5))
                            
                            Text("Privacy Policy")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 40)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Effective Date: 06.28.2025")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("Developer Contact: turkozukerem@gmail.com")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            
                            PrivacySectionView(
                                title: "1. Introduction",
                                content: "Thank you for using Fridge: Grocery List & Alarms. This privacy policy explains how your data is handled when you use the app."
                            )
                            
                            PrivacySectionView(
                                title: "2. No Personal Data Collection",
                                content: "We do not collect, store, or share any personal information or data from users. All data (such as expiry dates or shopping list items) is stored locally on your device only."
                            )
                            
                            PrivacySectionView(
                                title: "3. Notifications",
                                content: "The app requests permission to send you notifications. These are used to remind you:\n\n• 3 days before a product's expiry date\n• On the expiry date itself\n\nNotification permissions are optional and you can control them from your device settings at any time."
                            )
                            
                            PrivacySectionView(
                                title: "4. No Third-Party Access",
                                content: "This app does not use any third-party services, analytics tools, or ad networks. Your data is not shared with anyone."
                            )
                            
                            PrivacySectionView(
                                title: "5. Children's Privacy",
                                content: "This app does not target children under the age of 13 and does not collect any data from them."
                            )
                            
                            PrivacySectionView(
                                title: "6. Contact",
                                content: "If you have any questions or concerns about this privacy policy, please contact us at:\nturkozukerem@gmail.com"
                            )
                            
                            PrivacySectionView(
                                title: "7. Changes to This Policy",
                                content: "This policy may be updated if necessary. Any changes will be reflected on this page with a revised \"Effective Date\"."
                            )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationTitle("Privacy")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacySectionView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            Text(content)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.gray)
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

