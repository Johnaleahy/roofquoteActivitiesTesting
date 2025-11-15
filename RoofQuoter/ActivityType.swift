//
//  ActivityType.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import Foundation
import SwiftData

/// Represents a user-editable activity type that can be tracked
@Model
final class ActivityType {
    /// Unique identifier
    var id: UUID

    /// Name of the activity (e.g., "Push-ups", "Guitar Practice")
    var name: String

    /// Category for grouping (e.g., "Fitness", "Music", "Work")
    var category: String

    /// SF Symbol name for visual representation
    var iconName: String?

    /// Hex color code for visual distinction (e.g., "#FF5733")
    var color: String?

    /// Array of tracking fields this activity uses
    var trackingFields: [TrackingField]

    /// When this activity type was created
    var createdDate: Date

    /// Relationship to activity logs
    @Relationship(deleteRule: .cascade, inverse: \ActivityLog.activityType)
    var logs: [ActivityLog]?

    /// Relationship to goals
    @Relationship(deleteRule: .cascade, inverse: \ActivityGoal.activityType)
    var goals: [ActivityGoal]?

    /// Initialize a new activity type
    /// - Parameters:
    ///   - name: Name of the activity
    ///   - category: Category for grouping
    ///   - trackingFields: Fields to track for this activity
    ///   - iconName: Optional SF Symbol name
    ///   - color: Optional hex color code
    init(
        name: String,
        category: String,
        trackingFields: [TrackingField],
        iconName: String? = nil,
        color: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.trackingFields = trackingFields
        self.iconName = iconName
        self.color = color
        self.createdDate = Date()
    }

    /// Check if this activity type tracks a specific field
    /// - Parameter field: The tracking field to check
    /// - Returns: True if this activity tracks the specified field
    func tracks(_ field: TrackingField) -> Bool {
        return trackingFields.contains(field)
    }
}
