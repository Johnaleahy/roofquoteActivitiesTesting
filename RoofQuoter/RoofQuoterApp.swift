//
//  RoofQuoterApp.swift
//  RoofQuoter
//
//  Created by John Leahy on 2025-11-13.
//

import SwiftUI
import SwiftData

@main
struct RoofQuoterApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            PhotoItem.self,
            Measurement.self,
            ActivityType.self,
            ActivityLog.self,
            ActivityGoal.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        // Seed default activity types on first launch
        let modelContext = ModelContext(sharedModelContainer)
        ActivityDataSeeder.seedDefaultActivityTypes(in: modelContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
