//
//  AddShoppingItemView.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import SwiftUI
import SwiftData

struct AddShoppingItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var itemName = ""
    @State private var quantity = 1
    @State private var selectedCategory = "Food & Drinks"
    @State private var notes = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isAddingItem = false
    
    private let categories = ["Food & Drinks", "Health & Beauty", "Household", "Electronics", "Clothing", "Other"]
    
    var body: some View {
        ZStack {
            // Premium Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.93, green: 0.98, blue: 0.95),
                    Color(red: 0.88, green: 0.96, blue: 0.92)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Premium Header with Glass Effect
                ZStack {
                    // Glass morphism background
                    RoundedRectangle(cornerRadius: 0)
                        .fill(.ultraThinMaterial)
                        .frame(height: 100)
                    
                    HStack {
                        Button(action: { dismiss() }) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.4))
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 2) {
                            Text("Add Shopping Item")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("Build your shopping list")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Shopping Badge
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.2, green: 0.6, blue: 0.4),
                                        Color(red: 0.3, green: 0.7, blue: 0.5)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "cart.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
                
                ScrollView {
                    LazyVStack(spacing: 28) {
                        // Form Fields Section
                        VStack(spacing: 24) {
                            // Item Name
                            PremiumShoppingFormField(
                                title: "Item Name",
                                subtitle: "What do you need to buy?",
                                icon: "bag.fill"
                            ) {
                                TextField("Enter item name", text: $itemName)
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(itemName.isEmpty ? Color.gray.opacity(0.2) : Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.5), lineWidth: 1.5)
                                    )
                            }
                            
                            // Quantity with Premium Design
                            PremiumShoppingFormField(
                                title: "Quantity",
                                subtitle: "How many do you need?",
                                icon: "number.circle.fill"
                            ) {
                                HStack(spacing: 20) {
                                    // Decrease Button
                                    Button(action: {
                                        if quantity > 1 {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                quantity -= 1
                                            }
                                        }
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(.ultraThinMaterial)
                                                .frame(width: 50, height: 50)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.3), lineWidth: 1.5)
                                                )
                                            
                                            Image(systemName: "minus")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(quantity > 1 ? Color(red: 0.2, green: 0.6, blue: 0.4) : Color.gray)
                                        }
                                    }
                                    .disabled(quantity <= 1)
                                    .scaleEffect(quantity <= 1 ? 0.9 : 1.0)
                                    .animation(.easeInOut(duration: 0.1), value: quantity)
                                    
                                    Spacer()
                                    
                                    // Quantity Display
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(.ultraThinMaterial)
                                            .frame(width: 80, height: 50)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.3), lineWidth: 1.5)
                                            )
                                        
                                        Text("\(quantity)")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Spacer()
                                    
                                    // Increase Button
                                    Button(action: {
                                        if quantity < 99 {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                quantity += 1
                                            }
                                        }
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(.ultraThinMaterial)
                                                .frame(width: 50, height: 50)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.3), lineWidth: 1.5)
                                                )
                                            
                                            Image(systemName: "plus")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(quantity < 99 ? Color(red: 0.2, green: 0.6, blue: 0.4) : Color.gray)
                                        }
                                    }
                                    .disabled(quantity >= 99)
                                    .scaleEffect(quantity >= 99 ? 0.9 : 1.0)
                                    .animation(.easeInOut(duration: 0.1), value: quantity)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 20)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.2), lineWidth: 1.5)
                                )
                            }
                            
                            // Category Selection
                            PremiumShoppingFormField(
                                title: "Category",
                                subtitle: "Choose the item category",
                                icon: "folder.fill"
                            ) {
                                Menu {
                                    ForEach(categories, id: \.self) { category in
                                        Button(category) {
                                            selectedCategory = category
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.4))
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.3), lineWidth: 1.5)
                                    )
                                }
                            }
                            
                            // Notes Section
                            PremiumShoppingFormField(
                                title: "Notes",
                                subtitle: "Additional details (optional)",
                                icon: "note.text"
                            ) {
                                TextField("Add notes...", text: $notes, axis: .vertical)
                                    .font(.system(size: 16, weight: .medium))
                                    .lineLimit(3...6)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.3), lineWidth: 1.5)
                                    )
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Premium Add Button
                        Button(action: addShoppingItem) {
                            HStack(spacing: 16) {
                                if isAddingItem {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.9)
                                } else {
                                    Image(systemName: "cart.fill.badge.plus")
                                        .font(.system(size: 20, weight: .semibold))
                                }
                                
                                Text(isAddingItem ? "Adding to List..." : "Add to Shopping List")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
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
                            .shadow(
                                color: Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.4),
                                radius: 20,
                                x: 0,
                                y: 10
                            )
                            .scaleEffect(isAddingItem ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: isAddingItem)
                        }
                        .disabled(itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isAddingItem)
                        .opacity(itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 30)
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Result", isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func addShoppingItem() {
        guard !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter an item name"
            showingAlert = true
            return
        }
        
        isAddingItem = true
        
        // Simulate loading delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            let newItem = ShoppingItem(
                name: itemName.trimmingCharacters(in: .whitespacesAndNewlines),
                quantity: quantity,
                category: selectedCategory,
                notes: trimmedNotes.isEmpty ? nil : trimmedNotes
            )
            
            modelContext.insert(newItem)
            
            do {
                try modelContext.save()
                isAddingItem = false
                dismiss()
            } catch {
                isAddingItem = false
                alertMessage = "Failed to save item: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}

// Premium Shopping Form Field Component
struct PremiumShoppingFormField<Content: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let content: () -> Content
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.4))
            }
            
            content()
        }
    }
}

#Preview {
    AddShoppingItemView()
} 