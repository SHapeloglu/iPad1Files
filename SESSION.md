# iPad1Files — Authoritative Session / New Chat Handoff

> **This file is the authoritative handoff document for this repository.**
>
> A new chat or coding agent should be able to continue from this file alone.
> If another Markdown file conflicts with `SESSION.md`, **`SESSION.md` takes precedence**
> unless this file is explicitly updated later.

## 1. Project identity

Repository:

```text
https://github.com/SHapeloglu/iPad1Files
```

Branch:

```text
main
```

Current known HEAD:

```text
c1518f1 Align iPad1Files with shared filesystem integration policy
```

Earlier important commits:

```text
12b7525 Complete new-chat handoff documentation
0e66caf Add iPad1Files v1.0.0-beta1 shared filesystem foundation
```

Local development machine:

```text
yeliz@DESKTOP-CSC9788
```

Local checkout:

```text
~/projects/iPad1Files-v1.0.0-beta1
```

Do not confuse this project with unrelated work on the Contabo VPS.

## 2. Hard platform constraints

These constraints must not be changed:

```text
Device: iPad 1
RAM: 256 MB
OS: iOS 5.1.1
Architecture: armv7
Build system: Theos
Language: Objective-C
Memory management: non-ARC / MRC
```

Rules:

- no Swift
- no migration to modern-only iOS APIs
- prefer UIKit/Foundation APIs available on iOS 5
- preserve MRC ownership/release discipline
- keep memory use conservative
- physical-device behavior is the final authority

## 3. Physical device

Current iPad IP:

```text
192.168.1.100
```

SSH user:

```text
root
```

Legacy OpenSSH compatibility flags:

```text
-o HostKeyAlgorithms=+ssh-rsa
-o PubkeyAcceptedAlgorithms=+ssh-rsa
```

## 4. Project mission

iPad1Files is the **shared filesystem backbone** of the iPad1 application family.

It is not intended to become a monolithic application containing every specialist engine.

It owns:

```text
file/folder browser
copy
move
rename
delete
multi-select
search
favorites
disk information
lightweight preview
shared folder management
collision-safe naming
Open With
application URL hand-off
```

It does NOT own:

```text
FTP transport engine
FTP upload/download implementation
SFTP client
SMB client
WebDAV client
PDF annotation engine
PDF search/reflow engine
PDF page editing
OCR
AI/ML
background filesystem indexing
```

## 5. Companion application responsibilities

### iPad1FTPDownloader

Owns FTP/network transfer responsibilities.

Default shared-download target:

```text
/var/mobile/Media/iPad1Files/Downloads
```

iPad1Files must not import or duplicate the downloaded file.

### iPad1PDFReader

Owns PDF rendering and PDF-specific features.

iPad1Files only hands off the existing absolute file path.

### iPad1VNC

Owns VNC/remote-desktop responsibilities.

Shareable VNC state may use:

```text
/var/mobile/Media/iPad1Files/AppData/iPad1VNC
```

## 6. Canonical shared filesystem

Stable ecosystem contract:

```text
/var/mobile/Media/iPad1Files
```

Standard children:

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

App-specific state belongs under:

```text
/var/mobile/Media/iPad1Files/AppData/<ApplicationName>/
```

## 7. Intended ecosystem flow

```text
iPad1FTPDownloader
       ↓
Shared Downloads
       ↓
iPad1Files
       ↓
Open With
       ↓
iPad1PDFReader
```

Use the same physical file whenever possible.

## 8. Open With architecture

`IP1AppRegistry` is the authoritative:

```text
extension → application
```

mapping layer.

Initial mapping:

```text
.pdf → iPad1PDFReader
```

`IP1AppLauncher` performs URL hand-off.

PDF URL contract:

```text
ipad1pdf://open?path=<percent-encoded-absolute-path>
```

Rules:

- detect extension
- resolve app through `IP1AppRegistry`
- hand off through `IP1AppLauncher`
- send the existing absolute path
- do not copy a PDF merely to open it

Current status:

- generic registry-based hand-off exists in iPad1Files source
- `.pdf → iPad1PDFReader` is the first registration
- iPad1PDFReader receiver still needs to be completed/verified in its own repo

## 9. Downloads classification policy

For files directly inside:

```text
/var/mobile/Media/iPad1Files/Downloads
```

iPad1Files may offer explicit user-controlled moves such as:

```text
.pdf               → PDFs/
.jpg/.jpeg/.png    → Images/
.mp3/.m4a/.aac/.wav → Music/
.zip/.rar/.7z/.tar/.gz → Archives/
```

Never auto-move downloaded files.

## 10. Implemented beta1 capabilities

Current source includes:

- shared storage bootstrap
- file/folder browser
- folder-first sorting
- create folder
- rename
- delete
- file information
- current-folder search
- hidden-file toggle
- text preview
- image preview with zoom
- recursive folder size
- multi-selection
- copy workflow
- move workflow
- destination-folder picker
- safe bulk-delete confirmation
- collision-safe destination naming
- favorites persistence
- free/total disk-space footer
- `IP1AppRegistry`
- `IP1AppLauncher`
- generic registry-based Open With dispatch
- `.pdf → iPad1PDFReader` mapping
- user-controlled Downloads classification shortcuts
- shared iPad1FilesKit headers

## 11. Not yet considered proven

Do not claim these are fully working until physical-device testing confirms them:

- clean build after latest integration-policy source changes
- copy/move/delete regression status
- recursive folder operations
- Turkish-character paths
- collision-safe naming on device
- favorites persistence
- large directory performance
- large image memory behavior
- root-deletion protection
- Open With fallback behavior
- PDFReader receiver hand-off
- Downloads classification shortcuts
- absence of unexpected auto-move behavior

## 12. Memory policy

Safe:

```text
list only active folder
extension-based type detection
small metadata objects
URL hand-off
```

Use care:

```text
very large directories
large image preview
recursive size calculation
```

Do not add:

```text
large thumbnail caches
whole-filesystem trees in RAM
background indexing
OCR
AI/ML
```

## 13. Build

```bash
cd ~/projects/iPad1Files-v1.0.0-beta1
make clean
rm -rf .theos
make package FINALPACKAGE=1
```

After building:

```bash
ls -lh packages/
```

Use the exact generated `.deb` filename.

## 14. Deploy

Example:

```bash
scp -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa packages/<EXACT_DEB_FILENAME> root@192.168.1.100:/var/mobile/
```

SSH:

```bash
ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa root@192.168.1.100
```

On iPad:

```bash
dpkg -i /var/mobile/<EXACT_DEB_FILENAME>
killall SpringBoard
```

If needed:

```bash
su mobile -c "/usr/bin/uicache"
```

## 15. Git hygiene

Never commit:

```text
.theos/
packages/
*.deb
obj/
*.dSYM/
```

Before committing:

```bash
git status -sb
git diff --check
```

Do not stage unrelated files.

## 16. Current repository state

Latest known pushed source commit:

```text
c1518f1 Align iPad1Files with shared filesystem integration policy
```

That commit introduced/confirmed:

- generic registry-based Open With
- FileBrowser registry dispatch
- user-controlled Downloads classification
- iPad1Files scope cleanup

The changes are committed and pushed, but not yet physically validated.

## 17. Immediate next action

Start here in the next chat:

1. Enter the real local repo:

```bash
cd ~/projects/iPad1Files-v1.0.0-beta1
```

2. Verify Git state:

```bash
git status -sb
git log -3 --oneline
```

3. Clean-build current `main`:

```bash
make clean
rm -rf .theos
make package FINALPACKAGE=1
```

4. If compilation fails, fix only the iOS 5 / armv7 / MRC compatibility problem without changing the architecture.

5. Inspect the exact package:

```bash
ls -lh packages/
```

6. Install on physical iPad `192.168.1.100`.

7. Run beta1 regression tests, especially:

```text
copy/move/delete
multi-select
favorites
Turkish paths
collision naming
large directory
large image
Open With fallback
Downloads classification
```

8. Record actual pass/fail results in this `SESSION.md`.

9. Commit and push stabilization fixes/results.

10. Only after iPad1Files beta1 is stable, continue companion-app integration in this order:

```text
1. iPad1PDFReader — register ipad1pdf and open absolute path
2. iPad1FTPDownloader — use shared Downloads
3. iPad1VNC — adopt appropriate AppData/iPad1VNC paths
```

Do not start FTP/SFTP/SMB/WebDAV engine development inside iPad1Files.

## 18. New chat bootstrap

For a new chat, this message alone should be enough:

```text
https://github.com/SHapeloglu/iPad1Files

SESSION.md dosyasını oku.
SESSION.md bu proje için authoritative handoff belgesidir.
Başka bir MD dosyasıyla çelişirse SESSION.md'yi esas al.
"Immediate next action" bölümünden devam et.
Mevcut mimari kararları bozma.
iPad 1 / 256 MB RAM / iOS 5.1.1 / armv7 / non-ARC kısıtlarından sapma.
Fiziksel cihazda doğrulanmamış özellikleri çalışıyor kabul etme.
```
