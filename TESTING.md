# iPad1Files Physical Device Testing

## Target

```text
Device: iPad 1
OS target: iOS 5.1.1
IP: 192.168.1.100
Package: com.olap.ipad1files
Version: 1.0.0-beta1
```

## 1. Clean build

```bash
cd ~/projects/iPad1Files-v1.0.0-beta1
make clean
rm -rf .theos
make package FINALPACKAGE=1
```

Expected:

```text
packages/com.olap.ipad1files_1.0.0-beta1_iphoneos-arm.deb
```

Result:

- [ ] PASS
- [ ] FAIL

Notes:

```text

```

## 2. Install

```bash
scp \
-o HostKeyAlgorithms=+ssh-rsa \
-o PubkeyAcceptedAlgorithms=+ssh-rsa \
packages/com.olap.ipad1files_1.0.0-beta1_iphoneos-arm.deb \
root@192.168.1.100:/var/mobile/
```

Then install:

```bash
dpkg -i /var/mobile/com.olap.ipad1files_1.0.0-beta1_iphoneos-arm.deb
killall SpringBoard
```

- [ ] package installs
- [ ] icon appears
- [ ] app launches
- [ ] no immediate crash

## 3. Shared root

Verify:

```bash
ls -la /var/mobile/Media/iPad1Files
```

Expected folders:

- [ ] Downloads
- [ ] Documents
- [ ] PDFs
- [ ] Images
- [ ] Music
- [ ] Videos
- [ ] Archives
- [ ] Shared
- [ ] Temp
- [ ] AppData

Check ownership/permissions:

```bash
ls -ld /var/mobile/Media/iPad1Files
ls -la /var/mobile/Media/iPad1Files
```

- [ ] app can create files/folders
- [ ] app can rename
- [ ] app can delete

## 4. Folder operations

- [ ] create `Test`
- [ ] create `Türkçe Deneme`
- [ ] rename `Test`
- [ ] navigate into nested folders
- [ ] return to parent folders
- [ ] hidden-file toggle works

## 5. Single-file operations

Place sample files in Downloads.

- [ ] rename one file
- [ ] copy one file
- [ ] move one file
- [ ] delete one file
- [ ] file info is correct
- [ ] duplicate destination produces collision-safe name

Expected example:

```text
sample.pdf
sample (2).pdf
```

## 6. Multi-select

- [ ] select multiple files
- [ ] copy multiple files
- [ ] move multiple files
- [ ] bulk delete prompts confirmation
- [ ] cancel bulk delete preserves files

## 7. Recursive folders

Create a nested structure:

```text
TestTree/
├── A/
│   └── a.txt
└── B/
    └── b.txt
```

- [ ] copy folder recursively
- [ ] move folder recursively
- [ ] delete copied tree
- [ ] file contents remain intact

## 8. Favorites

- [ ] add favorite
- [ ] open favorite
- [ ] remove favorite
- [ ] close/reopen app
- [ ] favorites persist after restart

Storage expected:

```text
/var/mobile/Media/iPad1Files/AppData/iPad1Files/favorites.plist
```

## 9. Search

- [ ] search finds case-insensitive match
- [ ] search is scoped to current folder
- [ ] clearing search restores full list

## 10. Text preview

Test:

```text
.txt
.log
.md
.csv
.json
.xml
.plist
```

- [ ] UTF-8 text opens
- [ ] Turkish characters display acceptably
- [ ] unreadable file reports error rather than crashing

## 11. Image preview

Test several image sizes.

- [ ] JPG opens
- [ ] PNG opens
- [ ] zoom works
- [ ] returning to browser works
- [ ] large image does not immediately crash the app

Record problematic dimensions/files:

```text

```

## 12. Disk footer

- [ ] free space displays
- [ ] total space displays
- [ ] values are plausible

## 13. Root protection

Verify the UI does not provide an obvious action that deletes:

```text
/var/mobile/Media/iPad1Files
```

- [ ] protected

## 14. Large directory

Create/copy many files into one folder.

- [ ] list opens
- [ ] scrolling remains usable
- [ ] search remains usable
- [ ] no immediate memory crash

Approximate tested item count:

```text

```

## 15. PDF hand-off

Only mark complete after iPad1PDFReader implements the receiver.

- [ ] iPad1PDFReader registers `ipad1pdf`
- [ ] tapping PDF launches reader
- [ ] correct absolute path is passed
- [ ] PDF opens
- [ ] returning to iPad1Files works

## Exit criteria for beta1 stabilization

Before calling beta1 stable:

- [ ] clean build
- [ ] no launch crash
- [ ] core single-file operations pass
- [ ] multi-file operations pass
- [ ] favorites persist
- [ ] shared root permissions are correct
- [ ] no root deletion path
- [ ] major memory issues documented/fixed
- [ ] SESSION.md updated with results
