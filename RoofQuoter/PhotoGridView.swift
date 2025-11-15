//
//  PhotoGridView.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import SwiftUI
import SwiftData

struct PhotoGridView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PhotoItem.dateTaken, order: .reverse) private var photoItems: [PhotoItem]
    @State private var showingAddSheet = false
    @State private var selectedPhoto: PhotoItem?

    // Adaptive grid columns
    private let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if photoItems.isEmpty {
                    ContentUnavailableView {
                        Label("No Roof Photos", systemImage: "house.fill")
                    } description: {
                        Text("Add roof photos from your library to get started")
                    } actions: {
                        Button("Add Roof Photos") {
                            showingAddSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(photoItems) { photo in
                                PhotoGridCell(photo: photo)
                                    .onTapGesture {
                                        selectedPhoto = photo
                                    }
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            deletePhoto(photo)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Roof Details")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Label("Add Roof Photos", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddPhotoSheet()
            }
            .sheet(item: $selectedPhoto) { photo in
                PhotoDetailView(photo: photo)
            }
        }
    }

    private func deletePhoto(_ photo: PhotoItem) {
        withAnimation {
            modelContext.delete(photo)
        }
    }
}

struct PhotoGridCell: View {
    let photo: PhotoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
#if os(iOS)
            if let uiImage = UIImage(data: photo.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(12)
            } else {
                placeholderImage
            }
#else
            if let nsImage = NSImage(data: photo.imageData) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(12)
            } else {
                placeholderImage
            }
#endif

            if let title = photo.title, !title.isEmpty {
                Text(title)
                    .font(.caption)
                    .lineLimit(2)
                    .foregroundStyle(.primary)
            }
        }
    }

    private var placeholderImage: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 150)
            .cornerRadius(12)
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
    }
}

struct PhotoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let photo: PhotoItem

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Zoomable photo viewer
                GeometryReader { geometry in
                    ZStack {
#if os(iOS)
                        if let uiImage = UIImage(data: photo.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(scale)
                                .offset(offset)
                                .gesture(magnificationGesture)
                                .gesture(dragGesture)
                                .onTapGesture(count: 2) {
                                    resetZoom()
                                }
                        } else {
                            ContentUnavailableView("Image not available", systemImage: "photo")
                        }
#else
                        if let nsImage = NSImage(data: photo.imageData) {
                            Image(nsImage: nsImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(scale)
                                .offset(offset)
                                .gesture(magnificationGesture)
                                .gesture(dragGesture)
                                .onTapGesture(count: 2) {
                                    resetZoom()
                                }
                        } else {
                            ContentUnavailableView("Image not available", systemImage: "photo")
                        }
#endif
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                }

                // Photo metadata
                VStack(spacing: 8) {
                    if let title = photo.title {
                        Text(title)
                            .font(.headline)
                    }

                    if !photo.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(photo.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }

                    Text(photo.dateTaken.formatted(date: .long, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
#if os(iOS)
                .background(Color(uiColor: .systemBackground).opacity(0.95))
#else
                .background(Color(nsColor: .windowBackgroundColor).opacity(0.95))
#endif
            }
            .navigationTitle("Roof Photo")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }

                if scale != 1.0 || offset != .zero {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Reset") {
                            resetZoom()
                        }
                    }
                }
            }
        }
    }

    // Pinch to zoom gesture
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScale
                lastScale = value
                scale *= delta
                // Limit zoom range
                scale = min(max(scale, 1.0), 5.0)
            }
            .onEnded { _ in
                lastScale = 1.0
                if scale < 1.0 {
                    withAnimation {
                        scale = 1.0
                        offset = .zero
                    }
                }
            }
    }

    // Pan gesture for moving zoomed image
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }

    // Reset zoom and position
    private func resetZoom() {
        withAnimation(.spring()) {
            scale = 1.0
            lastScale = 1.0
            offset = .zero
            lastOffset = .zero
        }
    }
}

#Preview {
    PhotoGridView()
        .modelContainer(for: PhotoItem.self, inMemory: true)
}
