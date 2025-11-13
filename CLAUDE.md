# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RoofQuoter is a SwiftUI application for iOS/macOS using SwiftData for data persistence. The app is built with Xcode and targets modern Apple platforms.

## Project Structure

```
RoofQuoter/
├── RoofQuoter.xcodeproj/          # Xcode project
├── RoofQuoter/                     # Main app source
│   ├── RoofQuoterApp.swift        # App entry point with SwiftData setup
│   ├── ContentView.swift          # Main UI view
│   ├── Item.swift                 # SwiftData model
│   ├── Assets.xcassets/           # Images and assets
│   └── RoofQuoter.entitlements    # App sandbox entitlements
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

**UI Layer:**
- SwiftUI with NavigationSplitView for master-detail layout
- Platform-specific UI adjustments using `#if os(iOS)` and `#if os(macOS)` compiler directives
- Uses `@Query` for reactive data fetching from SwiftData
- Uses `@Environment(\.modelContext)` to access the model context for CRUD operations

**Testing:**
- Unit tests use the modern Swift Testing framework (`import Testing`, `@Test` macro)
- UI tests use XCTest framework
- Preview environment uses in-memory model containers for isolation

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

**Platform-specific code:**
- Use `#if os(iOS)` for iOS-only code (e.g., EditButton in toolbar)
- Use `#if os(macOS)` for macOS-only code (e.g., navigation split view column width)
