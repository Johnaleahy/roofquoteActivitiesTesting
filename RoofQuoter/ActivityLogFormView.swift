//
//  ActivityLogFormView.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import SwiftUI
import SwiftData

struct ActivityLogFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var activityTypes: [ActivityType]

    @State private var selectedActivityType: ActivityType?
    @State private var reps: String = ""
    @State private var minutes: String = ""
    @State private var count: String = ""
    @State private var notes: String = ""
    @State private var timestamp: Date = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Activity Type")) {
                    if activityTypes.isEmpty {
                        Text("No activity types available")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Type", selection: $selectedActivityType) {
                            Text("Select Activity").tag(nil as ActivityType?)
                            ForEach(activityTypes) { type in
                                HStack {
                                    if let iconName = type.iconName {
                                        Image(systemName: iconName)
                                    }
                                    Text(type.name)
                                }
                                .tag(type as ActivityType?)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

                if let activityType = selectedActivityType {
                    Section(header: Text("Details")) {
                        DatePicker("Time", selection: $timestamp)

                        if activityType.tracks(.reps) {
                            HStack {
                                Image(systemName: "number.circle")
                                    .foregroundStyle(.secondary)
#if os(iOS)
                                TextField("Reps", text: $reps)
                                    .keyboardType(.numberPad)
#else
                                TextField("Reps", text: $reps)
#endif
                            }
                        }

                        if activityType.tracks(.minutes) {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(.secondary)
#if os(iOS)
                                TextField("Minutes", text: $minutes)
                                    .keyboardType(.numberPad)
#else
                                TextField("Minutes", text: $minutes)
#endif
                            }
                        }

                        if activityType.tracks(.count) {
                            HStack {
                                Image(systemName: "number.square")
                                    .foregroundStyle(.secondary)
#if os(iOS)
                                TextField("Count", text: $count)
                                    .keyboardType(.numberPad)
#else
                                TextField("Count", text: $count)
#endif
                            }
                        }

                        if activityType.tracks(.notes) {
                            HStack(alignment: .top) {
                                Image(systemName: "note.text")
                                    .foregroundStyle(.secondary)
                                TextField("Notes", text: $notes, axis: .vertical)
                                    .lineLimit(3...6)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Log Activity")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveActivityLog()
                    }
                    .disabled(selectedActivityType == nil)
                }
            }
        }
    }

    private func saveActivityLog() {
        guard let activityType = selectedActivityType else { return }

        let newLog = ActivityLog(
            activityType: activityType,
            timestamp: timestamp,
            reps: Int(reps),
            minutes: Int(minutes),
            count: Int(count),
            notes: notes.isEmpty ? nil : notes
        )

        withAnimation {
            modelContext.insert(newLog)
        }

        dismiss()
    }
}

#Preview {
    ActivityLogFormView()
        .modelContainer(for: [ActivityType.self, ActivityLog.self], inMemory: true)
}
