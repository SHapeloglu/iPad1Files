# iPad1Files Session / New Chat Handoff

## Read this first

This file is the primary handoff document for a new chat or a new developer session.

Do not assume beta1 is fully validated just because the code exists. The next job is physical-device validation, then companion-app integration.

## Date

2026-08-18

## Repository

```text
https://github.com/SHapeloglu/iPad1Files
branch: main
initial beta1 commit: 0e66caf
```

## Local project

```text
user/host: yeliz@DESKTOP-CSC9788
path: ~/projects/iPad1Files-v1.0.0-beta1
```

Important: do not confuse this with the unrelated Contabo/VPS host `root@vmi3389964`.

## Device

```text
Device: iPad 1
Target OS: iOS 5.1.1
Current IP: 192.168.1.100
SSH user: root
```

Legacy SSH options:

```text
-o HostKeyAlgorithms=+ssh-rsa
-o PubkeyAcceptedAlgorithms=+ssh-rsa
```

## Current release

```text
1.0.0-beta1
Package: com.olap.ipad1files
Architecture: iphoneos-arm
Build arch: armv7
Deployment target: iOS 5.1
Memory model: non-ARC / MRC
```

## Why this project exists

iPad1Files is intended to become the shared filesystem backbone for the iPad1 application family.

Existing integration targets:

```text
iPad1PDFReader
iPad1FTPDownloader
iPad1VNC
```

The goal is to avoid each app inventing separate storage locations and file-operation code.

## Canonical shared root

```text
/var/mobile/Media/iPad1Files
```

Directory contract:

```text
Downloads/
Documents/
PDFs/
Images/
Music/
Videos/
Archives/
Shared/
Temp/
AppData/
```

## Implemented in beta1

- browser UI
- folder navigation
- folder-first sorting
- search in current folder
- create folder
- rename
- delete
- file information
- recursive folder size
- hidden-file toggle
- text preview
- image preview
- multi-select
- copy
- move
- destination picker
- bulk-delete confirmation
- collision-safe naming
- favorites
- disk free/total display
- PDF Reader URL hand-off hook
- app registry scaffold
- reusable iPad1FilesKit headers

## Not yet considered proven

The following must be physically validated on the iPad:

- all copy/move/delete flows
- recursive folder behavior
- Turkish-character paths
- duplicate-name handling
- favorites persistence
- large directories
- large-image memory behavior
- permissions on shared root
- root-deletion protection
- PDF URL hand-off in real companion app

Use `TESTING.md`.

## Build

```bash
cd ~/projects/iPad1Files-v1.0.0-beta1
make clean
rm -rf .theos
make package FINALPACKAGE=1
```

Expected package:

```text
packages/com.olap.ipad1files_1.0.0-beta1_iphoneos-arm.deb
```

## Deploy

```bash
scp \
-o HostKeyAlgorithms=+ssh-rsa \
-o PubkeyAcceptedAlgorithms=+ssh-rsa \
packages/com.olap.ipad1files_1.0.0-beta1_iphoneos-arm.deb \
root@192.168.1.100:/var/mobile/
```

Then:

```bash
ssh \
-o HostKeyAlgorithms=+ssh-rsa \
-o PubkeyAcceptedAlgorithms=+ssh-rsa \
root@192.168.1.100
```

On iPad:

```bash
dpkg -i /var/mobile/com.olap.ipad1files_1.0.0-beta1_iphoneos-arm.deb
killall SpringBoard
```

## Integration plan

Read `INTEGRATION.md`.

Priority order:

1. iPad1PDFReader
2. iPad1FTPDownloader
3. iPad1VNC

Do not add SFTP/SMB/WebDAV before stabilizing local storage and these three integrations.

## Immediate next action

Run the beta1 physical-device checklist in `TESTING.md`.

If a compile/runtime bug appears, fix it first, update this file and `TESTING.md`, then commit.

## New chat instruction

A new chat should start with something equivalent to:

```text
We are continuing SHapeloglu/iPad1Files.
Read SESSION.md, ARCHITECTURE.md, INTEGRATION.md, TESTING.md,
TASKS.md, CLAUDE.md and AGENTS.md before changing code.
Continue from the Immediate next action in SESSION.md.
```
