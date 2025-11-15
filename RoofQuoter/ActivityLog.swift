//
//  ActivityLog.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import Foundation
import SwiftData

/// Represents a single activity log entry
@Model
final class ActivityLog {
    /// Unique identifier
    var id: UUID

    /// When this activity occurred
    var timestamp: Date

    /// Number of repetitions (optional, used when activity tracks reps)
    var reps: Int?

    /// Duration in minutes (optional, used when activity tracks duration)
    var minutes: Int?

    /// Simple count (optional, used when activity tracks count)
    var count: Int?

    /// Text notes (optional, used for additional information)
    var notes: String?

    /// Additional tags for categorization
    var tags: [String]

    /// Relationship to the activity type
    var activityType: ActivityType?

    /// Relationship to an associated goal (optional)
    var goal: ActivityGoal?

    /// Initialize a new activity log entry
    /// - Parameters:
    ///   - activityType: The type of activity being logged
    ///   - timestamp: When the activity occurred (defaults to now)
    ///   - reps: Optional repetition count
    ///   - minutes: Optional duration in minutes
    ///   - count: Optional simple count
    ///   - notes: Optional text notes
    ///   - tags: Additional tags (defaults to empty array)
    init(
        activityType: ActivityType? = nil,
        timestamp: Date = Date(),
        reps: Int? = nil,
        minutes: Int? = nil,
        count: Int? = nil,
        notes: String? = nil,
        tags: [String] = []
    ) {
        self.id = UUID()
        self.activityType = activityType
        self.timestamp = timestamp
        self.reps = reps
        self.minutes = minutes
        self.count = count
        self.notes = notes
        self.tags = tags
    }

    /// Get a formatted time of day string
    var timeOfDay: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }

    /// Get a formatted date string
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }

    /// Get a full formatted timestamp
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}
