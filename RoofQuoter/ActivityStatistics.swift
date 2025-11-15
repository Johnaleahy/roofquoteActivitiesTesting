//
//  ActivityStatistics.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import Foundation

/// Helper struct for calculating activity statistics
struct ActivityStatistics {
    /// Calculate the total for a specific tracking field
    /// - Parameters:
    ///   - logs: Array of activity logs
    ///   - field: The tracking field to sum
    /// - Returns: Total value
    static func total(for logs: [ActivityLog], field: TrackingField) -> Int {
        var sum = 0

        for log in logs {
            switch field {
            case .reps:
                sum += log.reps ?? 0
            case .minutes:
                sum += log.minutes ?? 0
            case .count:
                sum += log.count ?? 0
            case .notes:
                // Notes field doesn't have numeric total
                break
            }
        }

        return sum
    }

    /// Calculate the average for a specific tracking field
    /// - Parameters:
    ///   - logs: Array of activity logs
    ///   - field: The tracking field to average
    /// - Returns: Average value, or 0 if no logs
    static func average(for logs: [ActivityLog], field: TrackingField) -> Double {
        guard !logs.isEmpty else { return 0 }

        let totalValue = total(for: logs, field: field)
        return Double(totalValue) / Double(logs.count)
    }

    /// Calculate the current streak (consecutive days with at least one log)
    /// - Parameters:
    ///   - logs: Array of activity logs (should be sorted by date)
    /// - Returns: Number of consecutive days
    static func currentStreak(for logs: [ActivityLog]) -> Int {
        guard !logs.isEmpty else { return 0 }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Group logs by day
        var logsByDay: [Date: [ActivityLog]] = [:]
        for log in logs {
            let day = calendar.startOfDay(for: log.timestamp)
            logsByDay[day, default: []].append(log)
        }

        // Get sorted unique days
        let sortedDays = logsByDay.keys.sorted(by: >)

        // Check if there's activity today or yesterday (streak must be recent)
        guard let mostRecentDay = sortedDays.first,
              calendar.dateComponents([.day], from: mostRecentDay, to: today).day ?? 0 <= 1 else {
            return 0
        }

        // Count consecutive days
        var streak = 0
        var currentDay = today

        for day in sortedDays {
            let daysDiff = calendar.dateComponents([.day], from: day, to: currentDay).day ?? 0

            if daysDiff == 0 {
                // Same day
                streak += 1
                currentDay = calendar.date(byAdding: .day, value: -1, to: currentDay) ?? currentDay
            } else if daysDiff == 1 {
                // Previous day
                streak += 1
                currentDay = calendar.date(byAdding: .day, value: -1, to: currentDay) ?? currentDay
            } else {
                // Gap in days, streak broken
                break
            }
        }

        return streak
    }

    /// Get logs within a specific date range
    /// - Parameters:
    ///   - logs: Array of all logs
    ///   - startDate: Start of date range
    ///   - endDate: End of date range
    /// - Returns: Filtered array of logs
    static func logs(_ logs: [ActivityLog], between startDate: Date, and endDate: Date) -> [ActivityLog] {
        return logs.filter { log in
            log.timestamp >= startDate && log.timestamp <= endDate
        }
    }

    /// Get logs for today
    /// - Parameter logs: Array of all logs
    /// - Returns: Filtered array of today's logs
    static func logsToday(_ logs: [ActivityLog]) -> [ActivityLog] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()

        return Self.logs(logs, between: today, and: tomorrow)
    }

    /// Get logs for this week
    /// - Parameter logs: Array of all logs
    /// - Returns: Filtered array of this week's logs
    static func logsThisWeek(_ logs: [ActivityLog]) -> [ActivityLog] {
        let calendar = Calendar.current
        let now = Date()

        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
              let weekEnd = calendar.date(byAdding: .weekOfYear, value: 1, to: weekStart) else {
            return []
        }

        return Self.logs(logs, between: weekStart, and: weekEnd)
    }

    /// Get logs for this month
    /// - Parameter logs: Array of all logs
    /// - Returns: Filtered array of this month's logs
    static func logsThisMonth(_ logs: [ActivityLog]) -> [ActivityLog] {
        let calendar = Calendar.current
        let now = Date()

        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
              let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart) else {
            return []
        }

        return Self.logs(logs, between: monthStart, and: monthEnd)
    }

    /// Group logs by activity type
    /// - Parameter logs: Array of logs
    /// - Returns: Dictionary mapping activity type names to their logs
    static func groupByActivityType(_ logs: [ActivityLog]) -> [String: [ActivityLog]] {
        var grouped: [String: [ActivityLog]] = [:]

        for log in logs {
            let typeName = log.activityType?.name ?? "Unknown"
            grouped[typeName, default: []].append(log)
        }

        return grouped
    }
}
