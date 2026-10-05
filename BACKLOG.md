# BACKLOG.md — iPad1Files

Scheduled work: `TASKS.md` (ZIP Phase 1 edge/security tests → ZIP Phase 2 → remaining integration). This file holds unscheduled items. Respect `INTEGRATION.md`: iPad1Files is the shared filesystem backbone; FTP and PDF engines stay in their own apps.

## Archive formats (deferred in `ARCHITECTURE.md`)

- ZIP64 (files > 4 GB / > 65 535 entries) — check MiniZip support and RAM cost first.
- Encrypted ZIP (read) — password prompt, never cache the password.
- TAR / TGZ / GZ — stream-based, no whole-archive buffering.
- RAR / 7z — only if a small, iOS-5-compatible library exists and physical RAM profiling passes; otherwise reject.

## Unscheduled ideas

- Storage usage view per canonical folder (`Downloads/ Documents/ PDFs/ Images/ Music/ Videos/ Archives/ Shared/ Temp/ AppData/`), computed incrementally.
- `Temp/` auto-cleanup policy (age-based) with user confirmation.
- Recent files list shared with sibling apps via a small plist (read-only for others).
- Image thumbnail cache with a hard cap (memory-pressure aware).
- iPad1VNC AppData integration details once VNC's beta4 lands.

## Out of scope

FTP/HTTP transfer engines (iPad1FTPDownloader), PDF rendering (iPad1PDFReader), media playback (iPad1Player), shell (iPad1Terminal).
