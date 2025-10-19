//
//  NotePriority.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/19.
//

enum NotePriority: String, CaseIterable, Codable, Hashable, Sendable {
    case high
    case medium
    case low
}

extension NotePriority: Identifiable {
    var id: NotePriority { self }
}

extension NotePriority {
    var labelTitle: String {
        switch self {
        case .high:
            return "High"
        case .medium:
            return "Medium"
        case .low:
            return "Low"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .high:
            return "arrow.up"
        case .medium:
            return "arrow.right"
        case .low:
            return "arrow.down"
        }
    }
}
