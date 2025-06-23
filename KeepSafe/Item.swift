//
//  Item.swift
//  KeepSafe
//
//  Created by Kerem Türközü on 23.06.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var name: String
    var expirationDate: Date
    var imageData: Data?
    var createdDate: Date
    var id: UUID
    var category: String
    
    init(name: String, expirationDate: Date, imageData: Data? = nil, category: String = "Food & Drinks") {
        self.name = name
        self.expirationDate = expirationDate
        self.imageData = imageData
        self.createdDate = Date()
        self.id = UUID()
        self.category = category
    }
    
    var isExpired: Bool {
        expirationDate < Date()
    }
    
    var daysUntilExpiration: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
    }
    
    var statusColor: String {
        let days = daysUntilExpiration
        if isExpired { return "red" }
        else if days <= 3 { return "orange" }
        else if days <= 7 { return "yellow" }
        else { return "green" }
    }
}
