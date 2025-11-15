//
//  AddPhotoSheet.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddPhotoSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isProcessing = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if isProcessing {
                    ProgressView("Adding roof photos...")
                        .padding()
                } else {
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 10,
                        matching: .images
                    ) {
                        Label("Select Roof Photos from Library", systemImage: "house.fill")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding()

                    if !selectedItems.isEmpty {
                        Text("\(selectedItems.count) roof photo(s) selected")
                            .foregroundStyle(.secondary)

                        Button("Add Roof Photos") {
                            Task {
                                await processPhotos()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                Spacer()
            }
            .navigationTitle("Add Roof Photos")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func processPhotos() async {
        isProcessing = true

        for item in selectedItems {
            if let data = try? await item.loadTransferable(type: Data.self) {
                let photoItem = PhotoItem(imageData: data)
                modelContext.insert(photoItem)
            }
        }

        isProcessing = false
        dismiss()
    }
}

#Preview {
    AddPhotoSheet()
        .modelContainer(for: PhotoItem.self, inMemory: true)
}
