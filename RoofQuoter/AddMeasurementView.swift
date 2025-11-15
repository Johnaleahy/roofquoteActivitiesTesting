//
//  AddMeasurementView.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import SwiftUI
import SwiftData

struct AddMeasurementView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var length: String = ""
    @State private var width: String = ""
    @State private var measurementDescription: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Description")) {
                    TextField("What are you measuring?", text: $measurementDescription)
                }

                Section(header: Text("Dimensions (inches)")) {
                    HStack {
                        Image(systemName: "ruler")
                            .foregroundStyle(.blue)
                        Text("Length")
                        Spacer()
#if os(iOS)
                        TextField("0.00", text: $length)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
#else
                        TextField("0.00", text: $length)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
#endif
                        Text("\"")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Image(systemName: "ruler.fill")
                            .foregroundStyle(.green)
                        Text("Width")
                        Spacer()
#if os(iOS)
                        TextField("0.00", text: $width)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
#else
                        TextField("0.00", text: $width)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
#endif
                        Text("\"")
                            .foregroundStyle(.secondary)
                    }
                }

                if let lengthValue = Double(length),
                   let widthValue = Double(width),
                   lengthValue > 0 && widthValue > 0 {
                    Section(header: Text("Calculated Area")) {
                        HStack {
                            Image(systemName: "square.grid.3x3")
                                .foregroundStyle(.orange)
                            Text("Square Inches")
                            Spacer()
                            Text(String(format: "%.2f sq in", lengthValue * widthValue))
                                .foregroundStyle(.secondary)
                        }

                        HStack {
                            Image(systemName: "square.grid.3x3.fill")
                                .foregroundStyle(.orange)
                            Text("Square Feet")
                            Spacer()
                            Text(String(format: "%.2f sq ft", (lengthValue * widthValue) / 144.0))
                                .foregroundStyle(.secondary)
                                .bold()
                        }
                    }
                }
            }
            .navigationTitle("Add Measurement")
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
                        saveMeasurement()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private var isValid: Bool {
        guard let lengthValue = Double(length),
              let widthValue = Double(width),
              lengthValue > 0,
              widthValue > 0,
              !measurementDescription.isEmpty else {
            return false
        }
        return true
    }

    private func saveMeasurement() {
        guard let lengthValue = Double(length),
              let widthValue = Double(width) else {
            return
        }

        let measurement = Measurement(
            length: lengthValue,
            width: widthValue,
            description: measurementDescription
        )

        withAnimation {
            modelContext.insert(measurement)
        }

        dismiss()
    }
}

#Preview {
    AddMeasurementView()
        .modelContainer(for: Measurement.self, inMemory: true)
}
