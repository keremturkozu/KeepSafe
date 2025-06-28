//
//  RatingRequestView.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import SwiftUI
import StoreKit
#if canImport(AppStore)
import AppStore
#endif

struct RatingRequestView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRating: Int = 0
    @State private var showThankYou = false
    @State private var animateStars = false
    @State private var buttonPressed = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.92, green: 0.95, blue: 0.98)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if showThankYou {
                // Thank You View
                VStack(spacing: 32) {
                    // Success Animation
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                            .scaleEffect(animateStars ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateStars)
                    }
                    
                    VStack(spacing: 16) {
                        Text("Thank You! 🎉")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        
                        Text("We appreciate your feedback!\nIt helps us make Fridge even better.")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    
                    Button("Continue") {
                        dismiss()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 40)
                }
            } else {
                // Rating Request View
                VStack(spacing: 40) {
                    // Header
                    VStack(spacing: 24) {
                        // App Icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.2, green: 0.4, blue: 0.8),
                                            Color(red: 0.3, green: 0.5, blue: 0.9)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                            
                            Image(systemName: "cube.box.fill")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 12) {
                            Text("Enjoying Fridge?")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text("We'd love to hear what you think!\nYour rating helps us improve.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                    }
                    
                    // Star Rating
                    VStack(spacing: 24) {
                        Text("Rate your experience")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        HStack(spacing: 12) {
                            ForEach(1...5, id: \.self) { star in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        selectedRating = star
                                    }
                                    
                                    print("⭐ Selected rating: \(star)") // Debug
                                    
                                    // Haptic feedback
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                    impactFeedback.impactOccurred()
                                }) {
                                    Image(systemName: star <= selectedRating ? "star.fill" : "star")
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(star <= selectedRating ? Color.yellow : Color.gray.opacity(0.4))
                                        .scaleEffect(selectedRating == star ? 1.2 : 1.0)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedRating)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                        // Rating description
                        if selectedRating > 0 {
                            Text(ratingDescription(for: selectedRating))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            print("🔘 Button tapped, rating: \(selectedRating)") // Debug
                            buttonPressed = true
                            handleRating()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: selectedRating >= 4 ? "heart.fill" : "paperplane.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text(selectedRating >= 4 ? "Rate in App" : "Send Feedback")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        selectedRating > 0 ? 
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.blue, 
                                                    Color.blue.opacity(0.8)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ) :
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.gray.opacity(0.6), 
                                                    Color.gray.opacity(0.4)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                    )
                                    .shadow(
                                        color: selectedRating > 0 ? Color.blue.opacity(0.3) : Color.clear, 
                                        radius: 8, x: 0, y: 4
                                    )
                            )
                            .scaleEffect(buttonPressed ? 0.95 : 1.0)
                        }
                        .disabled(selectedRating == 0 || buttonPressed)
                        .animation(.easeInOut(duration: 0.2), value: selectedRating)
                        .animation(.easeInOut(duration: 0.1), value: buttonPressed)
                        
                        Button("Maybe Later") {
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.vertical, 12)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)
            }
        }
    }
    
    private func ratingDescription(for rating: Int) -> String {
        switch rating {
        case 1:
            return "We're sorry to hear that. Let us know how we can improve!"
        case 2:
            return "Thanks for the feedback. We'd love to hear your suggestions!"
        case 3:
            return "Thanks! We're working hard to make Fridge even better."
        case 4:
            return "Great! We're so happy you're enjoying Fridge!"
        case 5:
            return "Awesome! You're amazing! 🌟"
        default:
            return ""
        }
    }
    
    private func handleRating() {
        print("🚀 Handling rating: \(selectedRating)")
        
        // Mark as rated
        UserDefaults.standard.set(true, forKey: "hasRatedApp")
        print("✅ Marked as rated in UserDefaults")
        
        if selectedRating >= 4 {
            // High rating - redirect to App Store
            print("📱 High rating (\(selectedRating)) - Requesting App Store review")
            requestAppStoreReview()
        } else {
            // Low rating - send feedback email
            print("📧 Low rating (\(selectedRating)) - Opening feedback email")
            sendFeedbackEmail()
        }
        
        // Show thank you
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showThankYou = true
            }
            print("🎉 Showing thank you message")
            
            // Auto dismiss after showing thank you
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                print("👋 Auto dismissing")
                dismiss()
            }
        }
    }
    
    private func requestAppStoreReview() {
        print("🏪 Requesting in-app review")
        
        // Try native in-app review first (works on real device)
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            #if targetEnvironment(simulator)
                print("⚠️ Native review popup doesn't work in simulator")
                print("📱 Simulating in-app review experience...")
                // Don't open App Store in simulator, just show success message
                showSimulatorRatingMessage()
            #else
                print("✅ Requesting native in-app review popup")
                SKStoreReviewController.requestReview(in: scene)
            #endif
        } else {
            print("❌ No active scene found")
            #if targetEnvironment(simulator)
                showSimulatorRatingMessage()
            #else
                // Only fallback to App Store on real device if absolutely necessary
                print("⚠️ Falling back to App Store (rare case)")
                openAppStoreURL()
            #endif
        }
    }
    
    private func showSimulatorRatingMessage() {
        print("🎭 Simulator: Would show native rating popup on real device")
        // For simulator, we'll just show the thank you message
        // This simulates the native experience without opening App Store
    }
    
    private func openAppStoreURL() {
        // Uygulamanızın App Store ID'sini buraya yazın
        // Şimdilik genel App Store sayfası
        let appStoreURL = "https://apps.apple.com/app/id6747648430" // Gerçek App Store ID'nizi buraya yazın
        
        print("🏪 Opening App Store URL: \(appStoreURL)")
        
        if let url = URL(string: appStoreURL) {
            UIApplication.shared.open(url) { success in
                print(success ? "✅ App Store opened successfully" : "❌ Failed to open App Store")
            }
        } else {
            print("❌ Invalid App Store URL")
        }
    }
    
    private func sendFeedbackEmail() {
        let email = "turkozukerem@gmail.com"
        let subject = "Fridge App Feedback"
        let body = "Hi,\n\nI've rated Fridge \(selectedRating) stars and would like to share some feedback:\n\n[Please share your thoughts here]\n\nDevice: \(UIDevice.current.model)\niOS Version: \(UIDevice.current.systemVersion)\nApp Version: 1.0\n\nThanks!"
        
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let mailURL = "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)"
        
        print("📧 Opening email URL: \(mailURL)")
        
        if let url = URL(string: mailURL) {
            UIApplication.shared.open(url) { success in
                print(success ? "✅ Email app opened successfully" : "❌ Failed to open email app")
            }
        } else {
            print("❌ Invalid email URL")
        }
    }
} 