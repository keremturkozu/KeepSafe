//
//  OnBoardingView.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var currentPage = 0
    @EnvironmentObject private var userDefaults: UserDefaultsManager
    
    private let pages: [OnBoardingPage] = [
        OnBoardingPage(
            image: "cube.transparent.fill",
            title: "Track Everything",
            description: "Keep your products safe with smart expiration tracking. Never waste food or medicine again.",
            color: Color.cyan
        ),
        OnBoardingPage(
            image: "camera.metering.center.weighted",
            title: "Visual Recognition",
            description: "Capture your products with stunning photos. Our smart gallery makes identification effortless.",
            color: Color.blue
        ),
        OnBoardingPage(
            image: "bell.and.waves.left.and.right.fill",
            title: "Intelligent Alerts",
            description: "Get beautiful, timely notifications. Our premium notification system keeps you informed in style.",
            color: Color.purple
        )
    ]
    
    var body: some View {
                    ZStack {
            // Premium Light Background
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
            
            // Glass morphism overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    pages[currentPage].color.opacity(0.2),
                    Color.clear,
                    pages[currentPage].color.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all)
            .animation(.easeInOut(duration: 0.6), value: currentPage)
            
            VStack(spacing: 0) {
                // Skip Button - Modern Design
                HStack {
                    Spacer()
                    Button("Skip") {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            userDefaults.hasSeenOnboarding = true
                        }
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                }
                
                // Page Content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        PremiumOnBoardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                // Premium Page Indicator
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        ZStack {
                            if index == currentPage {
                                Capsule()
                                    .frame(width: 24, height: 8)
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                pages[currentPage].color,
                                                pages[currentPage].color.opacity(0.8)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: pages[currentPage].color, radius: 8, x: 0, y: 2)
                            } else {
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(.gray.opacity(0.4))
                            }
                        }
                        .scaleEffect(index == currentPage ? 1.2 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                    }
                }
                .padding(.vertical, 32)
                
                // Premium Bottom Buttons
                VStack(spacing: 16) {
                    if currentPage == pages.count - 1 {
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                userDefaults.hasSeenOnboarding = true
                            }
                        }) {
                            HStack(spacing: 12) {
                                Text("Get Started")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
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
                            .shadow(color: Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.3), radius: 20, x: 0, y: 10)
                        }
                        .padding(.horizontal, 32)
                    } else {
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                currentPage += 1
                            }
                        }) {
                            HStack(spacing: 12) {
                                Text("Continue")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        pages[currentPage].color,
                                        pages[currentPage].color.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: pages[currentPage].color.opacity(0.3), radius: 15, x: 0, y: 8)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .preferredColorScheme(.light)
    }
}

struct PremiumOnBoardingPageView: View {
    let page: OnBoardingPage
    @State private var animateIcon = false
    @State private var animateGlow = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Premium Icon with Glow Effect
            ZStack {
                // Glow Effect
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                page.color.opacity(animateGlow ? 0.4 : 0.2),
                                page.color.opacity(animateGlow ? 0.2 : 0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 40,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)
                    .scaleEffect(animateGlow ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateGlow)
                
                // Icon Container
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    page.color.opacity(0.8),
                                    page.color.opacity(0.4),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: page.image)
                        .font(.system(size: 50, weight: .light))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    page.color,
                                    page.color.opacity(0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(animateIcon ? 1.1 : 1.0)
                        .rotationEffect(.degrees(animateIcon ? 5 : -5))
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateIcon)
                }
            }
            .padding(.bottom, 60)
            
            // Content with Glass Effect
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(page.color.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 32)
            
            Spacer()
            Spacer()
        }
        .onAppear {
            animateIcon = true
            animateGlow = true
        }
    }
}

struct OnBoardingPage {
    let image: String
    let title: String
    let description: String
    let color: Color
}

#Preview {
    OnBoardingView()
        .environmentObject(UserDefaultsManager.shared)
} 