//
//  StoreKitManager.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import Foundation
import StoreKit
import SwiftUI

@available(iOS 15.0, *)
@MainActor
class StoreKitManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchasedSubscriptions: [Product] = []
    @Published var subscriptionGroupStatus: Product.SubscriptionInfo.RenewalInfo?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let productIds = ["com.keepsafe.premium.weekly"]
    
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await Product.products(for: productIds)
            await updateSubscriptionStatus()
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            print("Failed to load products: \(error)")
        }
        
        isLoading = false
    }
    
    func purchase(_ product: Product) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updateSubscriptionStatus()
                await transaction.finish()
                
            case .userCancelled:
                errorMessage = "Purchase was cancelled"
                
            case .pending:
                errorMessage = "Purchase is pending approval"
                
            @unknown default:
                errorMessage = "Unknown purchase result"
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            print("Purchase failed: \(error)")
        }
        
        isLoading = false
    }
    
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
        } catch {
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
            print("Failed to restore purchases: \(error)")
        }
        
        isLoading = false
    }
    
    func updateSubscriptionStatus() async {
        var purchasedSubscriptions: [Product] = []
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                if let subscription = products.first(where: { $0.id == transaction.productID }) {
                    purchasedSubscriptions.append(subscription)
                }
            } catch {
                print("Failed to verify transaction: \(error)")
            }
        }
        
        self.purchasedSubscriptions = purchasedSubscriptions
        
        // Check subscription status
        subscriptionGroupStatus = nil // Reset status
        
        for subscription in purchasedSubscriptions {
            guard let subscriptionInfo = subscription.subscription else { continue }
            
            do {
                let statuses = try await subscriptionInfo.status
                for status in statuses {
                    switch status.state {
                    case .subscribed:
                        do {
                            let renewalInfo = try checkVerified(status.renewalInfo)
                            subscriptionGroupStatus = renewalInfo
                        } catch {
                            print("Failed to verify renewal info: \(error)")
                        }
                    case .expired, .revoked, .inGracePeriod:
                        subscriptionGroupStatus = nil
                    default:
                        break
                    }
                }
            } catch {
                print("Failed to get subscription status: \(error)")
            }
        }
        
        // Update PremiumManager
        PremiumManager.shared.setPremiumStatus(isPremiumActive)
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            
            for await verificationResult in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(verificationResult)
                    await self.updateSubscriptionStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    var isPremiumActive: Bool {
        return !purchasedSubscriptions.isEmpty
    }
    
    var weeklyProduct: Product? {
        return products.first { $0.id == "com.keepsafe.premium.weekly" }
    }
}

enum StoreError: Error {
    case failedVerification
}

extension StoreError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "User transaction verification failed"
        }
    }
} 
