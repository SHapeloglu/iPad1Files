# iPad1Files Integration Contracts

## Purpose

This document is the authoritative contract between iPad1Files and companion iPad1 applications.

If code changes one of these paths or URL schemes, update this file in the same commit.

## Shared filesystem root

```text
/var/mobile/Media/iPad1Files
```

## Common folders

```text
Downloads   downloaded/incoming files
Documents   general documents
PDFs        PDF-focused content
Images      image content
Music       audio
Videos      video
Archives    archives
Shared      explicitly cross-app content
Temp        disposable data
AppData     application-specific state
```

## iPad1PDFReader

### Goal

A PDF downloaded or placed in iPad1Files should open directly in iPad1PDFReader without copying it into another isolated folder.

### URL scheme contract

Sender:

```text
ipad1pdf://open?path=<percent-encoded-absolute-path>
```

Example conceptual path:

```text
/var/mobile/Media/iPad1Files/PDFs/book.pdf
```

### Required PDF Reader work

- register `ipad1pdf`
- parse `path`
- validate that the file exists
- open the absolute path
- refresh library when returning foreground
- scan at least:
  - `/var/mobile/Media/iPad1Files/PDFs`
  - `/var/mobile/Media/iPad1Files/Downloads`

### Status

Sender hook exists in iPad1Files beta1.
Receiver work is not yet complete.

## iPad1FTPDownloader

### Goal

FTP downloads should land in the shared ecosystem instead of a private/inconsistent folder.

### Default destination

```text
/var/mobile/Media/iPad1Files/Downloads
```

### Recommended behavior

```text
FTP server
   ↓
iPad1FTPDownloader
   ↓
Shared Downloads
   ↓
iPad1Files
   ↓
Open / Open With
```

### Future optional classification

After download, the user may optionally move/classify:

```text
.pdf        → PDFs/
.jpg/.png   → Images/
.mp3        → Music/
.mp4        → Videos/
.zip        → Archives/
```

Do not auto-move without a clearly defined user-facing rule.

### Status

Contract defined; companion-app integration pending.

## iPad1VNC

### Goal

Use the shared ecosystem for files that users may want to inspect, transfer, or keep across apps.

### Recommended AppData root

```text
/var/mobile/Media/iPad1Files/AppData/iPad1VNC
```

Suggested structure:

```text
profiles/
screenshots/
logs/
transfers/
```

### Notes

Credentials/keys must not be casually exposed as ordinary shared user files.
Sensitive material may require a separate protected strategy.

### Status

Contract defined; migration/integration pending.

## Open With

Current registry scaffold:

```text
IP1AppRegistry
IP1AppLauncher
```

Beta2 should evolve this into a simple extension → application mapping.

Initial target:

```text
.pdf → iPad1PDFReader
```

Future mappings may include archive/media apps.

## App independence

Companion apps should still launch if iPad1Files.app is not installed, where feasible.

The shared storage contract is more important than a hard runtime dependency on the GUI app.

## Change-control rule

Any change to:

- canonical root
- common folder names
- URL schemes
- AppData namespaces

must update:

```text
INTEGRATION.md
SESSION.md
README.md
```
