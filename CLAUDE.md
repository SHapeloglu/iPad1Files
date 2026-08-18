# CLAUDE.md

## Project

`iPad1Files`

Shared file manager and storage foundation for the jailbroken iPad 1 ecosystem.

Current release: `1.0.0-beta1`

Repository:

```text
https://github.com/SHapeloglu/iPad1Files
branch: main
```

Local working directory:

```text
~/projects/iPad1Files-v1.0.0-beta1
```

## Hard compatibility rules

- iPad 1
- armv7
- iOS 5.1 deployment target
- iOS 5.1.1 physical target
- Theos
- Objective-C
- `-fno-objc-arc`
- no Swift
- do not introduce APIs added after iOS 5 unless optional and guarded

Avoid examples such as:

```text
UIAlertController
UICollectionView
NSURLSession
UIActivityViewController
scene lifecycle APIs
```

Prefer legacy-compatible APIs such as:

```text
UITableView
UINavigationController
UIAlertView
UIActionSheet
UISearchBar
NSFileManager
```

## Stable storage contract

Never casually change:

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

Application-specific metadata:

```text
AppData/<ApplicationName>
```

## Architecture rules

Reusable logic belongs in `IP1*` classes.

Important components:

```text
IP1SharedStorage
IP1FileManager
IP1FileItem
IP1FileTypeDetector
IP1FavoritesManager
IP1DiskInfo
IP1AppLauncher
IP1AppRegistry
```

Do not duplicate low-level filesystem operations inside view controllers.

## Safety rules

- confirm destructive multi-item actions
- never silently overwrite
- preserve collision-safe naming
- do not permit deleting the canonical root
- prefer explicit errors to silent failure

## MRC rules

- balance retain/copy with release
- release retained ivars in `dealloc`
- clear delegates where appropriate
- avoid ownership cycles
- keep allocations conservative

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

## Physical iPad

Current IP:

```text
192.168.1.100
```

Legacy SSH compatibility options:

```text
-o HostKeyAlgorithms=+ssh-rsa
-o PubkeyAcceptedAlgorithms=+ssh-rsa
```

## Integration contracts

Read `INTEGRATION.md`.

Important current contracts:

```text
PDF Reader URL:
ipad1pdf://open?path=<encoded-path>

FTP Downloader destination:
/var/mobile/Media/iPad1Files/Downloads

VNC AppData:
/var/mobile/Media/iPad1Files/AppData/iPad1VNC
```

## Current development priority

Do not jump directly into new network features.

Order:

1. compile beta1
2. install on physical iPad
3. complete `TESTING.md`
4. fix beta1 regressions
5. integrate PDF Reader
6. integrate FTP Downloader
7. integrate VNC
8. only then expand into beta2/v1.1 features

## Before committing

```bash
git status
git diff --check
make clean
rm -rf .theos
make package FINALPACKAGE=1
```

Never commit:

```text
.theos/
packages/
*.deb
obj/
*.dSYM/
```
