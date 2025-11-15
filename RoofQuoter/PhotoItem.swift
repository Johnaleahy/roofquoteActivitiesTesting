//
//  PhotoItem.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import Foundation
import SwiftData

/// Represents a photo item with metadata
@Model
final class PhotoItem {
    /// Unique identifier
    var id: UUID

    /// Image data stored externally for efficiency
    @Attribute(.externalStorage)
    var imageData: Data

    /// Optional user-provided title/caption
    var title: String?

    /// Tags for categorization
    var tags: [String]

    /// When the photo was added
    var dateTaken: Date

    /// Initialize a new photo item
    /// - Parameters:
    ///   - imageData: The image data
    ///   - title: Optional title/caption
    ///   - tags: Array of tags (defaults to empty)
    ///   - dateTaken: When photo was taken (defaults to now)
    init(
        imageData: Data,
        title: String? = nil,
        tags: [String] = [],
        dateTaken: Date = Date()
    ) {
        self.id = UUID()
        self.imageData = imageData
        self.title = title
        self.tags = tags
        self.dateTaken = dateTaken
    }
}
