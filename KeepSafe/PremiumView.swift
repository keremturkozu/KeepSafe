//
//  PremiumView.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import SwiftUI
import StoreKit

@available(iOS 15.0, *)
struct PremiumView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storeManager = StoreKitManager()
    @State private var animateFeatures = false
    @State private var animateButton = false
    @State private var selectedFeature = 0
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private let features = [
        PremiumFeature(
            icon: "crown.fill",
            title: "Premium Features",
            description: "Unlock unlimited product tracking, advanced notifications, and exclusive themes",
            color: Color(red: 1.0, green: 0.8, blue: 0.0)
        ),
        PremiumFeature(
            icon: "cloud.fill",
            title: "Cloud Sync",
            description: "Sync your data across all devices with secure cloud backup and restore",
            color: Color(red: 0.2, green: 0.6, blue: 1.0)
        ),
        PremiumFeature(
            icon: "chart.line.uptrend.xyaxis",
            title: "Analytics",
            description: "Get detailed insights about your product usage patterns and savings",
            color: Color(red: 0.3, green: 0.8, blue: 0.5)
        ),
        PremiumFeature(
            icon: "bell.badge.fill",
            title: "Smart Notifications",
            description: "Advanced notification system with custom timing and priority levels",
            color: Color(red: 1.0, green: 0.4, blue: 0.4)
        )
    ]
    
    var body: some View {
        ZStack {
            // Premium Background
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 0.05, green: 0.1, blue: 0.2), location: 0.0),
                    .init(color: Color(red: 0.1, green: 0.15, blue: 0.3), location: 0.3),
                    .init(color: Color(red: 0.15, green: 0.2, blue: 0.4), location: 0.7),
                    .init(color: Color(red: 0.2, green: 0.25, blue: 0.5), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating Elements
            GeometryReader { geometry in
                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: CGFloat.random(in: 20...80))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .scaleEffect(animateFeatures ? 1.2 : 0.8)
                        .opacity(animateFeatures ? 0.6 : 0.3)
                        .animation(
                            .easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                            value: animateFeatures
                        )
                }
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    // Close Button
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    
                    // Hero Section
                    VStack(spacing: 24) {
                        // Premium Crown Icon
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 1.0, green: 0.8, blue: 0.0).opacity(0.3),
                                            Color.clear
                                        ]),
                                        center: .center,
                                        startRadius: 50,
                                        endRadius: 120
                                    )
                                )
                                .frame(width: 200, height: 200)
                                .scaleEffect(animateFeatures ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateFeatures)
                            
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 120, height: 120)
                                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                                
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 50, weight: .light))
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 1.0, green: 0.8, blue: 0.0),
                                                Color(red: 1.0, green: 0.6, blue: 0.0)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .scaleEffect(animateFeatures ? 1.1 : 1.0)
                                    .rotationEffect(.degrees(animateFeatures ? 5 : -5))
                                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateFeatures)
                            }
                        }
                        
                        // Title & Subtitle
                        VStack(spacing: 12) {
                            Text("KeepSafe Premium")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white,
                                            Color.white.opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("Unlock the full potential of your product tracking experience")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        
                        // Price Tag
                        VStack(spacing: 8) {
                            if let weeklyProduct = storeManager.weeklyProduct {
                                HStack(alignment: .top, spacing: 4) {
                                    Text("$")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))
                                        .offset(y: 4)
                                    
                                    Text(weeklyProduct.displayPrice)
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("/week")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.6))
                                        .offset(y: 20)
                                }
                            } else {
                                HStack(alignment: .top, spacing: 4) {
                                    Text("$")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))
                                        .offset(y: 4)
                                    
                                    Text("4.99")
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("/week")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.6))
                                        .offset(y: 20)
                                }
                            }
                            
                            Text("7-day free trial")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color(red: 1.0, green: 0.8, blue: 0.0).opacity(0.2))
                                )
                        }
                    }
                    .padding(.top, 40)
                    
                    // Features Section
                    VStack(spacing: 20) {
                        ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                            PremiumFeatureRowView(feature: feature, index: index)
                                .scaleEffect(animateFeatures ? 1.0 : 0.9)
                                .opacity(animateFeatures ? 1.0 : 0.0)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.1),
                                    value: animateFeatures
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 50)
                    
                    // CTA Section
                    VStack(spacing: 20) {
                        // Subscribe Button
                        Button(action: {
                            Task {
                                await handlePurchase()
                            }
                        }) {
                            HStack(spacing: 12) {
                                if storeManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "crown.fill")
                                        .font(.title3)
                                }
                                
                                Text(storeManager.isPremiumActive ? "Already Subscribed" : "Start Free Trial")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        storeManager.isPremiumActive ? Color.gray : Color(red: 1.0, green: 0.8, blue: 0.0),
                                        storeManager.isPremiumActive ? Color.gray.opacity(0.8) : Color(red: 1.0, green: 0.6, blue: 0.0)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color(red: 1.0, green: 0.8, blue: 0.0).opacity(0.4), radius: 20, x: 0, y: 10)
                            .scaleEffect(animateButton ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateButton)
                        }
                        .disabled(storeManager.isLoading || storeManager.isPremiumActive)
                        .opacity(storeManager.isPremiumActive ? 0.7 : 1.0)
                        
                        // Restore Purchases Button
                        Button(action: {
                            Task {
                                await handleRestorePurchases()
                            }
                        }) {
                            HStack(spacing: 8) {
                                if storeManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.6)
                                } else {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 14, weight: .medium))
                                }
                                
                                Text("Restore Purchases")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white.opacity(0.7))
                        }
                        .disabled(storeManager.isLoading)
                        
                        Text("Cancel anytime • No commitments")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 40)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            animateFeatures = true
            animateButton = true
            Task {
                await storeManager.loadProducts()
            }
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onChange(of: storeManager.errorMessage) { errorMessage in
            if let error = errorMessage {
                alertTitle = "Error"
                alertMessage = error
                showingAlert = true
            }
        }
    }
    
    // MARK: - Purchase Functions
    private func handlePurchase() async {
        guard let weeklyProduct = storeManager.weeklyProduct else {
            alertTitle = "Error"
            alertMessage = "Product not available. Please try again later."
            showingAlert = true
            return
        }
        
        await storeManager.purchase(weeklyProduct)
        
        if storeManager.isPremiumActive {
            alertTitle = "Welcome to Premium!"
            alertMessage = "Thank you for subscribing to KeepSafe Premium. Enjoy all the premium features!"
            showingAlert = true
        }
    }
    
    private func handleRestorePurchases() async {
        await storeManager.restorePurchases()
        
        if storeManager.isPremiumActive {
            alertTitle = "Purchases Restored"
            alertMessage = "Your premium subscription has been successfully restored."
            showingAlert = true
        } else {
            alertTitle = "No Purchases Found"
            alertMessage = "No active subscriptions were found for this account."
            showingAlert = true
        }
    }
}

struct PremiumFeatureRowView: View {
    let feature: PremiumFeature
    let index: Int
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Container
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(feature.color.opacity(0.2))
                    .frame(width: 56, height: 56)
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(feature.color.opacity(0.4), lineWidth: 1)
                    .frame(width: 56, height: 56)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(feature.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(feature.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(feature.description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Checkmark
            ZStack {
                Circle()
                    .fill(feature.color.opacity(0.2))
                    .frame(width: 28, height: 28)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(feature.color)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isHovered.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isHovered = false
            }
        }
    }
}

struct PremiumFeature {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

#Preview {
    PremiumView()
} 