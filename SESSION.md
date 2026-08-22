# iPad1Files Session / New Chat Handoff

Date: 2026-08-18

Repo:
```text
https://github.com/SHapeloglu/iPad1Files
branch: main
```

Known commits before this update:
```text
0e66caf beta1 source foundation
12b7525 Complete new-chat handoff documentation
```

Local:
```text
yeliz@DESKTOP-CSC9788
~/projects/iPad1Files-v1.0.0-beta1
```

Physical:
```text
iPad 1 / 256 MB / iOS 5.1.1 / armv7 / non-ARC
IP: 192.168.1.100
```

Locked decision: iPad1Files is the shared filesystem backbone, not a monolithic FTP/PDF/network app.

Owns: browser, copy/move/rename/delete, multi-select, search, favorites, disk info, preview, shared folders, collision-safe naming, Open With, URL hand-off.

Does NOT own: FTP/SFTP/SMB/WebDAV engines, PDF annotation/search/reflow/page editing, OCR, AI/ML, background indexing.

Canonical:
```text
/var/mobile/Media/iPad1Files
```

Flow:
```text
iPad1FTPDownloader -> Shared Downloads -> iPad1Files -> Open With -> iPad1PDFReader
```

PDF:
```text
.pdf -> iPad1PDFReader
ipad1pdf://open?path=<percent-encoded-absolute-path>
```

Current source update: generic registry Open With, FileBrowser registry dispatch, user-controlled Downloads classification, scope cleanup. Physical test pending.

## Immediate next action
1. Apply/push this update.
2. Clean build.
3. Fix iOS5/MRC compile issues if any.
4. Install to 192.168.1.100.
5. Complete TESTING.md.
6. Update SESSION with results.
7. Then companion repos: PDFReader receiver, FTPDownloader shared Downloads, VNC AppData.

## New chat bootstrap
```text
https://github.com/SHapeloglu/iPad1Files projesine devam ediyoruz.
Önce SESSION.md, ARCHITECTURE.md, INTEGRATION.md, TESTING.md,
TASKS.md, CLAUDE.md, AGENTS.md ve README.md dosyalarını oku.
SESSION.md içindeki "Immediate next action" bölümünden devam et.
Mevcut mimari kararları bozma.
iPad 1 / 256 MB RAM / iOS 5.1.1 / armv7 / non-ARC kısıtlarından sapma.
```
