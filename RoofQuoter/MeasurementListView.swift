//
//  MeasurementListView.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import SwiftUI
import SwiftData

struct MeasurementListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Measurement.createdDate, order: .reverse) private var measurements: [Measurement]
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            Group {
                if measurements.isEmpty {
                    ContentUnavailableView {
                        Label("No Measurements", systemImage: "ruler")
                    } description: {
                        Text("Add measurements to track roof dimensions")
                    } actions: {
                        Button("Add Measurement") {
                            showingAddSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        ForEach(measurements) { measurement in
                            MeasurementRow(measurement: measurement)
                        }
                        .onDelete(perform: deleteMeasurements)
                    }
                }
            }
            .navigationTitle("Measurements")
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
#endif
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Label("Add Measurement", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddMeasurementView()
            }
        }
    }

    private func deleteMeasurements(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(measurements[index])
            }
        }
    }
}

struct MeasurementRow: View {
    let measurement: Measurement

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(measurement.measurementDescription)
                .font(.headline)

            HStack(spacing: 16) {
                Label {
                    Text("L: \(measurement.lengthFormatted)")
                } icon: {
                    Image(systemName: "ruler")
                        .foregroundStyle(.blue)
                }
                .font(.subheadline)

                Label {
                    Text("W: \(measurement.widthFormatted)")
                } icon: {
                    Image(systemName: "ruler.fill")
                        .foregroundStyle(.green)
                }
                .font(.subheadline)
            }

            HStack {
                Label {
                    Text("Area: \(measurement.areaFormatted)")
                } icon: {
                    Image(systemName: "square.grid.3x3")
                        .foregroundStyle(.orange)
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                Spacer()

                Text(measurement.createdDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MeasurementListView()
        .modelContainer(for: Measurement.self, inMemory: true)
}
