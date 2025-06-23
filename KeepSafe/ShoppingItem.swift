//
//  ShoppingItem.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import Foundation
import SwiftData

@Model
final class ShoppingItem {
    var name: String
    var isCompleted: Bool
    var category: String
    var quantity: Int
    var notes: String?
    var createdDate: Date
    var id: UUID
    
    init(name: String, quantity: Int = 1, category: String = "General", notes: String? = nil, isCompleted: Bool = false) {
        self.name = name
        self.quantity = quantity
        self.category = category
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdDate = Date()
        self.id = UUID()
    }
} 