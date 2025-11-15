//
//  Measurement.swift
//  RoofQuoter
//
//  Created by Claude Code
//

import Foundation
import SwiftData

/// Represents a measurement with length and width (in inches)
@Model
final class Measurement {
    /// Unique identifier
    var id: UUID

    /// Length in inches
    var length: Double

    /// Width in inches
    var width: Double

    /// Description of what this measurement is for
    var measurementDescription: String

    /// When this measurement was created
    var createdDate: Date

    /// Initialize a new measurement
    /// - Parameters:
    ///   - length: Length in inches
    ///   - width: Width in inches
    ///   - description: Description of the measurement
    ///   - createdDate: When created (defaults to now)
    init(
        length: Double,
        width: Double,
        description: String,
        createdDate: Date = Date()
    ) {
        self.id = UUID()
        self.length = length
        self.width = width
        self.measurementDescription = description
        self.createdDate = createdDate
    }

    /// Calculate area in square inches
    var areaInSquareInches: Double {
        return length * width
    }

    /// Calculate area in square feet
    var areaInSquareFeet: Double {
        return areaInSquareInches / 144.0
    }

    /// Formatted length string
    var lengthFormatted: String {
        return String(format: "%.2f\"", length)
    }

    /// Formatted width string
    var widthFormatted: String {
        return String(format: "%.2f\"", width)
    }

    /// Formatted area in square feet
    var areaFormatted: String {
        return String(format: "%.2f sq ft", areaInSquareFeet)
    }
}
