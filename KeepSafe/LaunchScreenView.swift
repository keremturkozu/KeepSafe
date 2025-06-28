//
//  LaunchScreenView.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var titleOffset: CGFloat = 30
    @State private var titleOpacity: Double = 0.0
    @State private var subtitleOpacity: Double = 0.0
    @State private var backgroundOpacity: Double = 0.0
    @State private var showPulse: Bool = false
    @State private var navigateToMain = false
    
    @EnvironmentObject private var userDefaults: UserDefaultsManager
    
    var body: some View {
        ZStack {
            // Premium Gradient Background
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 0.1, green: 0.3, blue: 0.7), location: 0.0),
                    .init(color: Color(red: 0.2, green: 0.4, blue: 0.8), location: 0.3),
                    .init(color: Color(red: 0.3, green: 0.5, blue: 0.9), location: 0.7),
                    .init(color: Color(red: 0.4, green: 0.6, blue: 1.0), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(backgroundOpacity)
            .ignoresSafeArea()
            
            // Animated particles background
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 10...30))
                    .position(
                        x: CGFloat.random(in: 50...350),
                        y: CGFloat.random(in: 100...700)
                    )
                    .scaleEffect(showPulse ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: Double.random(in: 2...4))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: showPulse
                    )
            }
            
            VStack(spacing: 30) {
                Spacer()
                
                // App Icon with Animation
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .opacity(logoOpacity)
                        .scaleEffect(showPulse ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: showPulse)
                    
                    // Main Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white,
                                        Color.white.opacity(0.9)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        Image(systemName: "cube.box.fill")
                            .font(.system(size: 60, weight: .medium))
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
                    }
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                }
                
                // App Name
                VStack(spacing: 12) {
                    Text("Fridge")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .offset(y: titleOffset)
                        .opacity(titleOpacity)
                    
                    Text("Grocery List & Alarms")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(subtitleOpacity)
                }
                
                Spacer()
                
                // Loading indicator
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                        .opacity(subtitleOpacity)
                    
                    Text("Loading your fresh experience...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .opacity(subtitleOpacity)
                }
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            startAnimations()
            
            // Navigate after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                navigateToMain = true
            }
        }
                 .fullScreenCover(isPresented: $navigateToMain) {
             RootView()
                 .environmentObject(userDefaults)
         }
    }
    
    private func startAnimations() {
        // Background fade in
        withAnimation(.easeInOut(duration: 0.8)) {
            backgroundOpacity = 1.0
        }
        
        // Logo animations
        withAnimation(.spring(response: 1.2, dampingFraction: 0.6).delay(0.3)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Title animations
        withAnimation(.easeOut(duration: 0.8).delay(0.8)) {
            titleOffset = 0
            titleOpacity = 1.0
        }
        
        // Subtitle and loading
        withAnimation(.easeOut(duration: 0.6).delay(1.2)) {
            subtitleOpacity = 1.0
        }
        
        // Start pulse effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showPulse = true
        }
    }
}

 