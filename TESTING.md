# iPad1Files Physical Device Testing

Target: iPad 1 / 256 MB / iOS 5.1.1 / armv7 / IP 192.168.1.100.

Build:
```bash
cd ~/projects/iPad1Files-v1.0.0-beta1
make clean
rm -rf .theos
make package FINALPACKAGE=1
```

- [ ] compile/package/install/launch
- [ ] create/rename/delete/copy/move
- [ ] multi-select
- [ ] collision-safe naming
- [ ] Turkish paths
- [ ] favorites/search/disk
- [ ] text/image preview
- [ ] root protection
- [ ] large directory/image memory

Open With:
- [ ] PDFReader yokken crash yok
- [ ] receiver sonrası registry resolve
- [ ] percent-encoded absolute path
- [ ] no duplicate PDF

Downloads:
- [ ] PDF -> PDFs suggestion
- [ ] image -> Images
- [ ] audio -> Music
- [ ] archive -> Archives
- [ ] no auto-move
