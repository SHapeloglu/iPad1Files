# iPad1Files

iPad1Files is the shared file-management backbone for the jailbroken iPad 1 application ecosystem running iOS 5.1.1.

Its goal is broader than being an iFile-style browser: companion apps should share one storage contract, one set of filesystem rules, and one lightweight Objective-C integration layer.

## Ecosystem role

Designed to serve:

- iPad1PDFReader
- iPad1FTPDownloader
- iPad1VNC
- future iPad1Media
- future iPad1Archive
- future iPad1Browser / network utilities

## Compatibility

- Device: iPad 1
- Architecture: armv7
- Deployment target: iOS 5.1
- Primary physical target: iOS 5.1.1
- Build system: Theos
- Language: Objective-C
- Memory management: manual reference counting (`-fno-objc-arc`)
- Frameworks: UIKit, Foundation, CoreGraphics
- No Swift
- Avoid APIs introduced after iOS 5 unless optional and runtime-guarded

## Shared storage contract

Canonical root:

```text
/var/mobile/Media/iPad1Files/
```

Standard layout:

```text
/var/mobile/Media/iPad1Files/
├── Downloads/
├── Documents/
├── PDFs/
├── Images/
├── Music/
├── Videos/
├── Archives/
├── Shared/
├── Temp/
└── AppData/
```

Application-specific state belongs under:

```text
/var/mobile/Media/iPad1Files/AppData/<ApplicationName>/
```

## v1.0.0-beta1 implemented features

- directory browser
- folder-first sorting
- current-folder search
- create folder
- rename
- delete
- file information
- recursive folder-size calculation
- show/hide hidden files
- text preview
- image preview with zoom
- multi-selection mode
- copy selected items
- move selected items
- destination-folder browser
- safe bulk-delete confirmation
- collision-safe destination naming such as `file (2).pdf`
- persistent favorites
- free/total disk-space footer
- PDF Reader launch hook through `ipad1pdf://`
- common application registry scaffold
- shared `iPad1FilesKit` headers
- shared storage bootstrap
- URL scheme: `ipad1files://`

## Shared kit

Reusable components:

```text
IP1FileItem
IP1FileManager
IP1FileTypeDetector
IP1SharedStorage
IP1AppLauncher
IP1AppRegistry
IP1FavoritesManager
IP1DiskInfo
```

Example:

```objc
#import "iPad1FilesKit.h"

NSArray *pdfs = [[IP1FileManager sharedManager]
    filesWithExtension:@"pdf"
    underPath:[[IP1SharedStorage sharedStorage] rootPath]];
```

## Companion-app integration

See `INTEGRATION.md` for the authoritative contracts.

### iPad1PDFReader

Current hand-off contract:

```text
ipad1pdf://open?path=<percent-encoded-absolute-path>
```

The PDF Reader still needs to register this URL scheme and parse the `path` parameter before this integration is complete.

### iPad1FTPDownloader

Target default destination:

```text
/var/mobile/Media/iPad1Files/Downloads/
```

### iPad1VNC

Recommended shared application state:

```text
/var/mobile/Media/iPad1Files/AppData/iPad1VNC/
├── profiles/
├── screenshots/
├── logs/
└── transfers/
```

## Build

Local project path:

```text
~/projects/iPad1Files-v1.0.0-beta1
```

Build:

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

## Deploy to physical iPad

Current iPad IP:

```text
192.168.1.100
```

Copy package:

```bash
scp \
-o HostKeyAlgorithms=+ssh-rsa \
-o PubkeyAcceptedAlgorithms=+ssh-rsa \
packages/com.olap.ipad1files_1.0.0-beta1_iphoneos-arm.deb \
root@192.168.1.100:/var/mobile/
```

Connect:

```bash
ssh \
-o HostKeyAlgorithms=+ssh-rsa \
-o PubkeyAcceptedAlgorithms=+ssh-rsa \
root@192.168.1.100
```

Install on iPad:

```bash
dpkg -i /var/mobile/com.olap.ipad1files_1.0.0-beta1_iphoneos-arm.deb
killall SpringBoard
```

## Repository

```text
https://github.com/SHapeloglu/iPad1Files
branch: main
initial beta1 commit: 0e66caf
```

## Current status

`1.0.0-beta1` is implemented and pushed to GitHub. The complete local file workflow still needs systematic physical-device validation. Read `SESSION.md`, `TESTING.md`, and `INTEGRATION.md` before starting new feature work.

## Roadmap

### beta2

- home/root shortcut screen
- lightweight icons
- Open With registry UI
- real iPad1PDFReader URL receiver
- iPad1FTPDownloader shared-download integration
- iPad1VNC AppData integration
- fixes found during physical-device regression testing

### v1.1

- HTTP download manager
- ZIP create/extract
- queued downloads

### later

- FTP
- SFTP
- WebDAV
- SMB
- media previews
- network browser
