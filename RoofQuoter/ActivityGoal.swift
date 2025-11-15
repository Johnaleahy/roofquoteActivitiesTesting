//
//  ActivityGoal.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import Foundation
import SwiftData

/// Represents a goal or target for an activity
@Model
final class ActivityGoal {
    /// Unique identifier
    var id: UUID

    /// Target value to achieve (e.g., 100 reps, 30 minutes)
    var targetValue: Int

    /// Period for the goal (e.g., "daily", "weekly", "monthly")
    var period: String

    /// Which tracking field this goal applies to
    var fieldType: TrackingField

    /// Whether this goal is currently active
    var isActive: Bool

    /// When this goal was created
    var createdDate: Date

    /// Relationship to the activity type
    var activityType: ActivityType?

    /// Relationship to associated logs
    @Relationship(deleteRule: .nullify, inverse: \ActivityLog.goal)
    var logs: [ActivityLog]?

    /// Initialize a new activity goal
    /// - Parameters:
    ///   - activityType: The activity type this goal applies to
    ///   - targetValue: Target value to achieve
    ///   - fieldType: Which field to track
    ///   - period: Time period (daily/weekly/monthly)
    ///   - isActive: Whether this goal is active (defaults to true)
    init(
        activityType: ActivityType? = nil,
        targetValue: Int,
        fieldType: TrackingField,
        period: String = "daily",
        isActive: Bool = true
    ) {
        self.id = UUID()
        self.activityType = activityType
        self.targetValue = targetValue
        self.fieldType = fieldType
        self.period = period
        self.isActive = isActive
        self.createdDate = Date()
    }

    /// Calculate progress toward this goal based on logs
    /// - Parameter logs: Array of activity logs to consider
    /// - Returns: Progress value (sum of the tracked field)
    func calculateProgress(from logs: [ActivityLog]) -> Int {
        var total = 0

        for log in logs {
            switch fieldType {
            case .reps:
                total += log.reps ?? 0
            case .minutes:
                total += log.minutes ?? 0
            case .count:
                total += log.count ?? 0
            case .notes:
                // Notes field doesn't have numeric progress
                break
            }
        }

        return total
    }

    /// Calculate progress percentage
    /// - Parameter logs: Array of activity logs to consider
    /// - Returns: Progress as a percentage (0-100+)
    func progressPercentage(from logs: [ActivityLog]) -> Double {
        guard targetValue > 0 else { return 0 }
        let progress = calculateProgress(from: logs)
        return (Double(progress) / Double(targetValue)) * 100.0
    }

    /// Check if the goal has been achieved
    /// - Parameter logs: Array of activity logs to consider
    /// - Returns: True if progress meets or exceeds target
    func isAchieved(from logs: [ActivityLog]) -> Bool {
        return calculateProgress(from: logs) >= targetValue
    }
}
