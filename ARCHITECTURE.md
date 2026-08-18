# iPad1Files Architecture

## Mission

iPad1Files is the filesystem backbone of the iPad1 application ecosystem.

```text
iPad1Files.app
    └── user-facing browser and file operations

iPad1FilesKit
    └── reusable storage/file/application-integration primitives
```

## Platform constraints

```text
Device: iPad 1
Architecture: armv7
Deployment: iOS 5.1
Primary runtime: iOS 5.1.1
Build: Theos
Language: Objective-C
Memory: Manual Reference Counting
```

Do not introduce post-iOS-5 APIs unless they are optional and runtime-guarded.

## Canonical storage

```text
/var/mobile/Media/iPad1Files
```

Standard folders:

```text
Downloads
Documents
PDFs
Images
Music
Videos
Archives
Shared
Temp
AppData
```

Application-specific state:

```text
AppData/<ApplicationName>/
```

## Core classes

### IP1SharedStorage

Defines and creates the canonical shared directory tree.

### IP1FileManager

Owns filesystem operations:

- browse
- create folder
- rename
- delete
- copy
- move
- recursive extension search
- recursive size
- collision-safe destinations

Filesystem behavior belongs here, not duplicated in controllers.

### IP1FileItem

Small metadata object used by the UI.

### IP1FileTypeDetector

Legacy-friendly extension-based type mapping.

### IP1FavoritesManager

Stores persistent favorites in:

```text
AppData/iPad1Files/favorites.plist
```

### IP1DiskInfo

Reports filesystem capacity/free-space information.

### IP1AppLauncher

Owns cross-application URL hand-offs.

### IP1AppRegistry

Registry scaffold for future Open With behavior.

## UI controllers

### FileBrowserViewController

Implemented responsibilities:

- current-directory rendering
- current-folder search
- navigation
- multi-selection
- copy/move/delete action dispatch
- hidden-file toggle
- preview routing

### FolderPickerViewController

Implemented destination browser for copy/move.

### FavoritesViewController

Implemented favorite-folder navigation.

### TextViewerViewController

Implemented lightweight text preview.

### ImageViewerViewController

Implemented zoomable image preview.

### FileInfoViewController

Implemented file/folder metadata screen.

## Cross-app contracts

Authoritative details live in `INTEGRATION.md`.

Current intended ecosystem:

```text
                 iPad1Files
                /     |     \
               /      |      \
      PDFReader   FTPDownloader   VNC
```

## Safety rules

- Never expose a path that can delete the canonical shared root.
- Confirm destructive bulk operations.
- Never silently overwrite existing destinations.
- Use collision-safe names.
- Keep temporary content inside `Temp`.
- Keep app metadata inside `AppData/<ApplicationName>`.
- Report operation failure instead of silently continuing.

## Memory/performance rules

iPad 1 is memory-constrained.

- browse only the current directory in normal UI
- avoid recursive tree loading
- avoid large thumbnail caches
- keep previews simple
- stream future network transfers instead of buffering whole files
- avoid unnecessary background services
- respect MRC ownership/release rules

## Implemented in beta1

The following are no longer “future” items:

- multi-select
- copy workflow
- move workflow
- destination picker
- favorites
- bulk-delete confirmation
- free/total disk-space display
- app registry scaffold

## Future modular direction

```text
iPad1Core
├── iPad1FilesKit
├── iPad1NetworkKit
├── iPad1UIKit
└── iPad1Compatibility
```

Network protocols should remain separate from the local filesystem core.
