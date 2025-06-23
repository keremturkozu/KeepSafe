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
                                Text("KeepSafe")
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
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(filteredItems) { item in
                                    PremiumProductRowView(item: item)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation(.smooth) {
            for index in offsets {
                modelContext.delete(filteredItems[index])
            }
        }
    }
}

struct PremiumProductRowView: View {
    let item: Item
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Compact Image with Status Badge Below
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.08))
                        .frame(width: 60, height: 60)
                    
                    Group {
                        if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            Image(systemName: "cube.box.fill")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                        }
                    }
                    
                    // Status indicator
                    VStack {
                        HStack {
                            Spacer()
                            Circle()
                                .fill(statusColor(for: item))
                                .frame(width: 8, height: 8)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1.5)
                                )
                        }
                        Spacer()
                    }
                    .padding(4)
                }
                
                // Status badge below image
                Text(statusText(for: item))
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(statusColor(for: item))
                    .clipShape(Capsule())
            }
            
            // Content Section - Clean and Compact
            VStack(alignment: .leading, spacing: 4) {
                // Product name and days
                HStack(alignment: .top) {
                    Text(item.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 1) {
                        Text("\(abs(item.daysUntilExpiration))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(statusColor(for: item))
                        
                        Text(item.daysUntilExpiration >= 0 ? "days left" : "expired")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Category
                HStack(spacing: 4) {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 8))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                    
                    Text(item.category)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                // Expiration date
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                    
                    Text(item.expirationDate, formatter: dateFormatter)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, perform: {}, onPressingChanged: { isPressing in
            isPressed = isPressing
        })
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
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(filteredItems) { item in
                                    PremiumShoppingRowView(item: item)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
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
                            
                            Text("Customize your KeepSafe experience")
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
                            
                            // Account Section
                            VStack(spacing: 12) {
                                ModernSettingsRowView(icon: "person.circle.fill", title: "Profile", subtitle: "Manage your account", color: Color(red: 0.2, green: 0.4, blue: 0.8))
                                ModernSettingsRowView(icon: "gearshape.fill", title: "General Settings", subtitle: "App preferences", color: Color(red: 0.5, green: 0.5, blue: 0.5))
                                ModernSettingsRowView(icon: "bell.fill", title: "Notifications", subtitle: "Alert preferences", color: Color(red: 1.0, green: 0.6, blue: 0.2))
                            }
                            
                            // Support Section
                            VStack(spacing: 12) {
                                ModernSettingsRowView(icon: "lock.shield.fill", title: "Privacy", subtitle: "Data & security", color: Color(red: 0.2, green: 0.7, blue: 0.5))
                                ModernSettingsRowView(icon: "questionmark.circle.fill", title: "Help & Support", subtitle: "Get assistance", color: Color(red: 0.3, green: 0.5, blue: 0.9))
                                ModernSettingsRowView(icon: "info.circle.fill", title: "About", subtitle: "App information", color: Color(red: 0.6, green: 0.4, blue: 0.8))
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
}

struct ModernSettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Handle tap action here
        }) {
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
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, perform: {}, onPressingChanged: { isPressing in
            isPressed = isPressing
        })
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

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

