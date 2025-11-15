//
//  ActivityDataSeeder.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import Foundation
import SwiftData

/// Helper for seeding default activity types on first launch
struct ActivityDataSeeder {
    /// Seed default activity types if they don't exist
    /// - Parameter modelContext: The SwiftData model context
    static func seedDefaultActivityTypes(in modelContext: ModelContext) {
        // Check if activity types already exist
        let descriptor = FetchDescriptor<ActivityType>()

        do {
            let existingTypes = try modelContext.fetch(descriptor)

            // Only seed if no activity types exist
            guard existingTypes.isEmpty else {
                print("Activity types already exist, skipping seed")
                return
            }

            print("Seeding default activity types...")

            // Create Push-ups activity
            let pushUps = ActivityType(
                name: "Push-ups",
                category: "Fitness",
                trackingFields: [.reps],
                iconName: "figure.strengthtraining.traditional",
                color: "#FF5733"
            )
            modelContext.insert(pushUps)

            // Create Sit-ups activity
            let sitUps = ActivityType(
                name: "Sit-ups",
                category: "Fitness",
                trackingFields: [.reps],
                iconName: "figure.core.training",
                color: "#E74C3C"
            )
            modelContext.insert(sitUps)

            // Create Guitar Practice activity
            let guitarPractice = ActivityType(
                name: "Guitar Practice",
                category: "Music",
                trackingFields: [.minutes],
                iconName: "guitars",
                color: "#3498DB"
            )
            modelContext.insert(guitarPractice)

            // Create Sales Calls activity
            let salesCalls = ActivityType(
                name: "Sales Calls",
                category: "Work",
                trackingFields: [.minutes, .count, .notes],
                iconName: "phone.fill",
                color: "#2ECC71"
            )
            modelContext.insert(salesCalls)

            // Save the context
            try modelContext.save()

            print("Successfully seeded 4 default activity types")

        } catch {
            print("Error seeding activity types: \(error)")
        }
    }
}
