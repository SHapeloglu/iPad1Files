# iPad1Files Tasks

## Current milestone

`v1.0.0-beta1` physical-device stabilization.

## Completed implementation

- [x] Shared `/var/mobile/Media/iPad1Files` root
- [x] Standard directory tree
- [x] Directory browser
- [x] Folder-first sorting
- [x] Current-folder search
- [x] Create folder
- [x] Rename
- [x] Delete
- [x] File information
- [x] Recursive folder size
- [x] Hidden-file toggle
- [x] Text preview
- [x] Image preview
- [x] Multi-selection
- [x] Copy destination picker
- [x] Move destination picker
- [x] Bulk-delete confirmation
- [x] Collision-safe destination names
- [x] Favorites persistence
- [x] Free/total disk-space footer
- [x] PDF Reader launch contract
- [x] App registry scaffold
- [x] Shared kit headers
- [x] armv7 / iOS 5.1 / MRC build configuration
- [x] Initial beta1 GitHub push

## Physical-device validation

Detailed procedure is in `TESTING.md`.

- [ ] Clean Theos build
- [ ] Install on iPad 1 at `192.168.1.100`
- [ ] Confirm launch
- [ ] Confirm shared root creation and permissions
- [ ] Single-file operations
- [ ] Multi-file operations
- [ ] Recursive folder operations
- [ ] Turkish-character paths
- [ ] Collision naming
- [ ] Favorites persistence
- [ ] Disk-space footer
- [ ] Text preview
- [ ] Image preview and memory behavior
- [ ] Hidden files
- [ ] Large directory performance
- [ ] Root-deletion protection

## beta2 integration

- [ ] Add home/root shortcut screen
- [ ] Add lightweight legacy-safe icons
- [ ] Add Open With registry UI
- [ ] Implement iPad1PDFReader URL receiver
- [ ] Make iPad1PDFReader scan shared PDFs
- [ ] Make iPad1FTPDownloader use shared Downloads
- [ ] Add FTP completion → Open With workflow
- [ ] Move iPad1VNC screenshots/logs/transfers toward AppData contract
- [ ] Validate all integration contracts from `INTEGRATION.md`

## v1.1

- [ ] HTTP download manager
- [ ] Download queue
- [ ] Pause/resume where feasible
- [ ] ZIP extraction
- [ ] ZIP creation
- [ ] Archive safety checks

## Network roadmap

- [ ] FTP module
- [ ] SFTP module
- [ ] WebDAV module
- [ ] SMB module
- [ ] Saved connections
- [ ] Network favorites
- [ ] iOS 5-compatible credential strategy

## Release checklist

- [ ] `git diff --check`
- [ ] clean Theos build
- [ ] physical-device smoke test
- [ ] package/control/plist versions agree
- [ ] README version agrees
- [ ] SESSION updated
- [ ] TESTING updated
- [ ] no `.deb` committed
- [ ] no `.theos` committed
