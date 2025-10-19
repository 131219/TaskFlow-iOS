//
//  TaskItem.swift
//  TaskFlow
//
//  Created by Prateek Singh on 10/18/2025.
//

import Foundation
import SwiftData

@Model
final class TaskItem {
    var title: String
    var notes: String?
    var isCompleted: Bool
    var priority: Priority
    var dueDate: Date?
    var createdAt: Date
    
    init(title: String, notes: String? = nil, priority: Priority = .normal, dueDate: Date? = nil) {
        self.title = title
        self.notes = notes
        self.isCompleted = false
        self.priority = priority
        self.dueDate = dueDate
        self.createdAt = Date()
    }
}

enum Priority: String, Codable, CaseIterable {
    case low = "Low"
    case normal = "Normal"
    case medium = "Medium"
    case high = "High"
    
    var displayName: String {
        self.rawValue
    }
}
