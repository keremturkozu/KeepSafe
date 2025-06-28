//
//  AddProductView.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddProductView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var notificationManager: NotificationManager
    @StateObject private var premiumManager = PremiumManager.shared
    @Query private var items: [Item]
    @State private var showingPremiumView = false
    
    @State private var productName = ""
    @State private var expirationDate = Date()
    @State private var selectedImage: UIImage?
    @State private var selectedCategory = "Food & Drinks"
    @State private var showingImagePicker = false
    @State private var showingImageOptions = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isAddingProduct = false
    
    private let categories = ["Food & Drinks", "Health & Beauty", "Household", "Electronics", "Clothing", "Other"]
    
    var body: some View {
        ZStack {
            // Premium Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.90, green: 0.95, blue: 1.0)
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
                                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 2) {
                            Text("Add Product")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("Track expiration dates")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Premium Badge
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.2, green: 0.4, blue: 0.8),
                                        Color(red: 0.3, green: 0.5, blue: 0.9)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
                
                ScrollView {
                    LazyVStack(spacing: 28) {
                        // Product Photo Section with Enhanced Design
                        VStack(spacing: 20) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Product Photo")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                    Text("Add a clear photo of your product")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                            }
                            
                            Button(action: {
                                showingImageOptions = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(.ultraThinMaterial)
                                        .frame(height: 220)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.3),
                                                            Color(red: 0.3, green: 0.5, blue: 0.9).opacity(0.1)
                                                        ]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 2
                                                )
                                        )
                                    
                                    if let selectedImage = selectedImage {
                                        Image(uiImage: selectedImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 220)
                                            .clipShape(RoundedRectangle(cornerRadius: 24))
                                    } else {
                                        VStack(spacing: 16) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.1))
                                                    .frame(width: 80, height: 80)
                                                
                                                Image(systemName: "camera.fill")
                                                    .font(.system(size: 32, weight: .medium))
                                                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                                            }
                                            
                                            VStack(spacing: 4) {
                                                Text("Tap to add photo")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(.primary)
                                                
                                                Text("Take a clear photo of your product")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Form Fields Section
                        VStack(spacing: 24) {
                            // Product Name
                            PremiumFormField(
                                title: "Product Name",
                                subtitle: "Enter the name of your product",
                                icon: "tag.fill"
                            ) {
                                TextField("Enter product name", text: $productName)
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(productName.isEmpty ? Color.gray.opacity(0.2) : Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.5), lineWidth: 1.5)
                                    )
                            }
                            
                            // Category Selection
                            PremiumFormField(
                                title: "Category",
                                subtitle: "Choose the product category",
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
                                            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.3), lineWidth: 1.5)
                                    )
                                }
                            }
                            
                            // Expiration Date
                            PremiumFormField(
                                title: "Expiration Date",
                                subtitle: "When does this product expire?",
                                icon: "calendar.circle.fill"
                            ) {
                                DatePicker(
                                    "",
                                    selection: $expirationDate,
                                    in: Date()...,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(CompactDatePickerStyle())
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.3), lineWidth: 1.5)
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Premium Add Button
                        Button(action: addProduct) {
                            HStack(spacing: 16) {
                                if isAddingProduct {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.9)
                                } else {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                }
                                
                                Text(isAddingProduct ? "Adding Product..." : "Add Product")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
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
                            .shadow(
                                color: Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.4),
                                radius: 20,
                                x: 0,
                                y: 10
                            )
                            .scaleEffect(isAddingProduct ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: isAddingProduct)
                        }
                        .disabled(productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isAddingProduct)
                        .opacity(productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 30)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingImageOptions) {
            PhotoSelectionView(selectedImage: $selectedImage)
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
        }
        .alert("Result", isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $showingPremiumView) {
            if #available(iOS 15.0, *) {
                PremiumView()
            }
        }
    }
    
    private func addProduct() {
        guard !productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter a product name"
            showingAlert = true
            return
        }
        
        // Check premium limits
        if !premiumManager.isPremium && items.count >= premiumManager.maxProducts {
            showingPremiumView = true
            return
        }
        
        isAddingProduct = true
        
        // Simulate loading delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let newItem = Item(
                name: productName.trimmingCharacters(in: .whitespacesAndNewlines),
                expirationDate: expirationDate,
                imageData: selectedImage?.jpegData(compressionQuality: 0.8),
                category: selectedCategory
            )
            
            modelContext.insert(newItem)
            
            do {
                try modelContext.save()
                
                // Yeni ürün için bildirim zamanla
                notificationManager.scheduleExpirationNotification(for: newItem)
                
                // Debug: Bildirim zamanlandıktan sonra kontrol et
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    print("🎯 DEBUG: Checking notifications after adding \(newItem.name)")
                    print("🗓️ Expiration date: \(newItem.expirationDate)")
                    print("📅 Days until expiration: \(newItem.daysUntilExpiration)")
                    notificationManager.checkPendingNotifications()
                }
                
                isAddingProduct = false
                dismiss()
            } catch {
                isAddingProduct = false
                alertMessage = "Failed to save product: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}

// Premium Form Field Component
struct PremiumFormField<Content: View>: View {
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
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
            }
            
            content()
        }
    }
}

// Photo Selection View with Camera and Gallery Options
struct PhotoSelectionView: View {
    @Binding var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle Bar
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 6)
                .padding(.top, 12)
            
            // Header
            VStack(spacing: 8) {
                Text("Add Photo")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Choose how to add your product photo")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)
            
            // Options
            HStack(spacing: 20) {
                // Camera Option
                Button(action: {
                    sourceType = .camera
                    showingImagePicker = true
                }) {
                    VStack(spacing: 16) {
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
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("Take Photo")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Use camera")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Gallery Option
                Button(action: {
                    sourceType = .photoLibrary
                    showingImagePicker = true
                }) {
                    VStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.2, green: 0.6, blue: 0.4),
                                            Color(red: 0.3, green: 0.7, blue: 0.5)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "photo.fill")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("Choose Photo")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("From gallery")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.top, 40)
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
                .onDisappear {
                    if selectedImage != nil {
                        dismiss()
                    }
                }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    AddProductView()
} 