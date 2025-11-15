# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RoofQuoter is a SwiftUI application for iOS/macOS using SwiftData for data persistence. The app helps users track roofing projects with three main features:
1. **Activity Tracking** - Track daily activities (push-ups, guitar practice, sales calls)
2. **Roof Details** - Photo gallery for roof photos with zoom and pan
3. **Measurements** - Track roof measurements (length/width in inches)

The app is built with Xcode and targets modern Apple platforms.

## Project Structure

```
RoofQuoter/
├── RoofQuoter.xcodeproj/          # Xcode project
├── RoofQuoter/                     # Main app source
│   ├── RoofQuoterApp.swift        # App entry point with SwiftData setup
│   ├── ContentView.swift          # Main TabView with 3 tabs
│   ├── Item.swift                 # Legacy model (preserved for migration)
│   │
│   ├── Activity Tracking Models:
│   │   ├── TrackingField.swift         # Enum for tracking field types
│   │   ├── ActivityType.swift          # User-editable activity types
│   │   ├── ActivityLog.swift           # Activity log entries
│   │   ├── ActivityGoal.swift          # Goals and targets
│   │   ├── ActivityStatistics.swift    # Helper for calculations
│   │   └── ActivityDataSeeder.swift    # Seeds default activities
│   │
│   ├── Activity Tracking Views:
│   │   ├── ActivityListView.swift      # Main activity list
│   │   └── ActivityLogFormView.swift   # Form to log activities
│   │
│   ├── Roof Details (Photos) Models:
│   │   └── PhotoItem.swift             # Photo storage with metadata
│   │
│   ├── Roof Details (Photos) Views:
│   │   ├── PhotoGridView.swift         # Grid view with zoom support
│   │   └── AddPhotoSheet.swift         # Photo picker interface
│   │
│   ├── Measurements Models:
│   │   └── Measurement.swift           # Length/width measurements
│   │
│   ├── Measurements Views:
│   │   ├── MeasurementListView.swift   # Measurement list
│   │   └── AddMeasurementView.swift    # Form to add measurements
│   │
│   ├── Assets.xcassets/           # Images and assets
│   └── RoofQuoter.entitlements    # App sandbox entitlements
│
├── RoofQuoterTests/                # Unit tests (Swift Testing framework)
└── RoofQuoterUITests/              # UI tests
```

## Building and Running

**Build the app:**
```bash
xcodebuild -project RoofQuoter/RoofQuoter.xcodeproj -scheme RoofQuoter -configuration Debug build
```

**Run tests:**
```bash
xcodebuild test -project RoofQuoter/RoofQuoter.xcodeproj -scheme RoofQuoter -destination 'platform=iOS Simulator,name=iPhone 15'
```

**Run unit tests only:**
```bash
xcodebuild test -project RoofQuoter/RoofQuoter.xcodeproj -scheme RoofQuoter -only-testing:RoofQuoterTests -destination 'platform=iOS Simulator,name=iPhone 15'
```

**Run UI tests only:**
```bash
xcodebuild test -project RoofQuoter/RoofQuoter.xcodeproj -scheme RoofQuoter -only-testing:RoofQuoterUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

**Open in Xcode:**
```bash
open RoofQuoter/RoofQuoter.xcodeproj
```

## Architecture

**Data Layer:**
- Uses SwiftData for persistence (not Core Data)
- ModelContainer is configured in `RoofQuoterApp.swift` with persistent storage
- All models must be decorated with `@Model` and registered in the Schema
- Current Schema includes:
  - `Item` (legacy, preserved for migration)
  - `PhotoItem` (roof photos with `.externalStorage` for images)
  - `Measurement` (length/width measurements)
  - `ActivityType` (user-editable activity types)
  - `ActivityLog` (activity log entries)
  - `ActivityGoal` (goals and targets)

**UI Layer:**
- SwiftUI with TabView for main navigation (3 tabs)
- Platform-specific UI adjustments using `#if os(iOS)` and `#if os(macOS)` compiler directives
- Uses `@Query` for reactive data fetching from SwiftData
- Uses `@Environment(\.modelContext)` to access the model context for CRUD operations
- Uses PhotosPicker for selecting photos from library
- LazyVGrid for photo grid layout
- Zoom/pan gestures for photo viewing

**Testing:**
- Unit tests use the modern Swift Testing framework (`import Testing`, `@Test` macro)
- UI tests use XCTest framework
- Preview environment uses in-memory model containers for isolation

## Features

### 1. Activity Tracking
**Models:**
- `TrackingField` - Enum defining field types (reps, minutes, count, notes)
- `ActivityType` - User-editable activity types with custom fields
- `ActivityLog` - Flexible log entries with timestamp and optional fields
- `ActivityGoal` - Goals with progress tracking
- `ActivityStatistics` - Helper for calculating totals, averages, streaks

**Default Activities:**
- Push-ups (tracks reps)
- Guitar Practice (tracks minutes)
- Sales Calls (tracks minutes, count, notes)

**Features:**
- Log activities with dynamic fields based on type
- Set and track goals (daily/weekly/monthly)
- View statistics (totals, averages, streaks)
- Group by activity type and date range

### 2. Roof Details (Photo Gallery)
**Models:**
- `PhotoItem` - Stores photos with `.externalStorage` attribute for efficient binary data storage
- Properties: imageData, title, tags, dateTaken

**Features:**
- Select photos from library (PhotosPicker)
- Grid view with adaptive columns (2-3 per row)
- Pinch to zoom (1x to 5x)
- Pan/drag when zoomed
- Double-tap to reset zoom
- Full-screen detail view
- Delete photos with context menu
- Cross-platform (iOS and macOS)

### 3. Measurements
**Models:**
- `Measurement` - Stores length and width in inches
- Properties: length, width, description, createdDate
- Computed: areaInSquareInches, areaInSquareFeet

**Features:**
- Add measurements with description
- Units default to inches
- Automatic area calculation (square inches and feet)
- Real-time calculation preview
- List view with formatted dimensions
- Edit mode to delete measurements

## Key Patterns

**Adding a new SwiftData model:**
1. Create the model class with `@Model` decorator
2. Register it in the Schema array in `RoofQuoterApp.swift`
3. The ModelContainer will automatically handle persistence

**Working with SwiftData:**
- Use `@Query` for fetching data in views
- Use `modelContext.insert()` to add new items
- Use `modelContext.delete()` to remove items
- Wrap changes in `withAnimation` for smooth UI transitions

**Storing binary data efficiently:**
- Use `@Attribute(.externalStorage)` for large data like images
- SwiftData stores this data adjacent to the model storage for better performance

**Platform-specific code:**
- Use `#if os(iOS)` for iOS-only code (e.g., `.keyboardType(.decimalPad)`, `.navigationBarTitleDisplayMode(.inline)`)
- Use `#if os(macOS)` for macOS-only code (e.g., navigation split view column width)
- Use conditional imports: `UIImage` (iOS) vs `NSImage` (macOS)
- Use conditional colors: `Color(uiColor:)` (iOS) vs `Color(nsColor:)` (macOS)

**Photo handling:**
- Use PhotosPicker for photo selection (cross-platform)
- Convert photos to Data with `PhotosPickerItem.loadTransferable(type: Data.self)`
- Display with `Image(uiImage:)` on iOS or `Image(nsImage:)` on macOS

**Zoom and pan gestures:**
- Use `MagnificationGesture()` for pinch-to-zoom
- Use `DragGesture()` for panning
- Combine with `@State` for scale and offset tracking
- Limit zoom range (e.g., 1.0 to 5.0)

## Tab Navigation

The app uses a TabView with three tabs:
1. **Activities** (figure.run icon) - Activity tracking and logging
2. **Roof Details** (house.fill icon) - Photo gallery for roof photos
3. **Measurements** (ruler icon) - Measurement tracking

## Data Seeding

On first launch, `ActivityDataSeeder` automatically creates three default activity types:
- Push-ups (Fitness category, tracks reps)
- Guitar Practice (Music category, tracks minutes)
- Sales Calls (Work category, tracks minutes, count, notes)

This only runs if no activity types exist, preventing duplicate seeding.
