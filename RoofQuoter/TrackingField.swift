//
//  TrackingField.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import Foundation

/// Defines the types of fields that can be tracked for an activity
enum TrackingField: String, Codable, CaseIterable {
    case reps        // For counting repetitions (e.g., push-ups)
    case minutes     // For duration tracking (e.g., guitar practice, sales calls)
    case count       // For simple counting (e.g., number of calls)
    case notes       // For text notes (e.g., sales call outcomes)

    /// Display name for the field
    var displayName: String {
        switch self {
        case .reps:
            return "Reps"
        case .minutes:
            return "Minutes"
        case .count:
            return "Count"
        case .notes:
            return "Notes"
        }
    }

    /// Icon for the field (SF Symbol name)
    var iconName: String {
        switch self {
        case .reps:
            return "number.circle"
        case .minutes:
            return "clock"
        case .count:
            return "number.square"
        case .notes:
            return "note.text"
        }
    }
}
