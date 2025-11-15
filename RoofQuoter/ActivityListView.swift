//
//  ActivityListView.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import SwiftUI
import SwiftData

struct ActivityListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ActivityLog.timestamp, order: .reverse) private var activityLogs: [ActivityLog]
    @Query private var activityTypes: [ActivityType]
    @State private var showingLogForm = false

    var body: some View {
        NavigationSplitView {
            List {
                Section {
                    QuickActionsView(activityTypes: activityTypes, modelContext: modelContext)
                }

                Section("Recent Activity") {
                    ForEach(activityLogs) { log in
                        ActivityLogRow(log: log)
                    }
                    .onDelete(perform: deleteLogs)
                }
            }
            .navigationTitle("Activity Tracker")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingLogForm = true }) {
                        Label("Log Activity", systemImage: "plus.circle.fill")
                    }
                }
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
#endif
            }
            .sheet(isPresented: $showingLogForm) {
                ActivityLogFormView()
            }
        } detail: {
            VStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 60))
                    .foregroundStyle(.secondary)
                Text("Select an activity to view details")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func deleteLogs(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(activityLogs[index])
            }
        }
    }
}

struct ActivityLogRow: View {
    let log: ActivityLog

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let activityType = log.activityType {
                    Image(systemName: activityType.iconName ?? "circle.fill")
                        .foregroundStyle(Color(hex: activityType.color ?? "#999999"))
                    Text(activityType.name)
                        .font(.headline)
                } else {
                    Text("Unknown Activity")
                        .font(.headline)
                }
                Spacer()
                Text(log.timeOfDay)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack {
                if let reps = log.reps {
                    Label("\(reps) reps", systemImage: "number.circle")
                        .font(.caption)
                }
                if let minutes = log.minutes {
                    Label("\(minutes) min", systemImage: "clock")
                        .font(.caption)
                }
                if let count = log.count {
                    Label("\(count) calls", systemImage: "phone")
                        .font(.caption)
                }
            }
            .foregroundStyle(.secondary)

            if let notes = log.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

struct QuickActionsView: View {
    let activityTypes: [ActivityType]
    let modelContext: ModelContext

    var body: some View {
        VStack(spacing: 12) {
            Text("Quick Actions")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 10) {
                // +10 Push-ups button
                if let pushUps = activityTypes.first(where: { $0.name == "Push-ups" }) {
                    QuickActionButton(
                        activityType: pushUps,
                        value: 10,
                        label: "+10 Push-ups",
                        modelContext: modelContext
                    )
                }

                // +20 Sit-ups button
                if let sitUps = activityTypes.first(where: { $0.name == "Sit-ups" }) {
                    QuickActionButton(
                        activityType: sitUps,
                        value: 20,
                        label: "+20 Sit-ups",
                        modelContext: modelContext
                    )
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct QuickActionButton: View {
    let activityType: ActivityType
    let value: Int
    let label: String
    let modelContext: ModelContext

    var body: some View {
        Button(action: {
            logActivity()
        }) {
            HStack {
                Image(systemName: activityType.iconName ?? "circle.fill")
                    .font(.caption)
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .background(Color(hex: activityType.color ?? "#999999").opacity(0.15))
            .foregroundColor(Color(hex: activityType.color ?? "#999999"))
            .cornerRadius(8)
        }
    }

    private func logActivity() {
        let log = ActivityLog(
            activityType: activityType,
            reps: value
        )

        withAnimation {
            modelContext.insert(log)
        }
    }
}

// Helper to create Color from hex string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ActivityListView()
        .modelContainer(for: [ActivityType.self, ActivityLog.self], inMemory: true)
}
