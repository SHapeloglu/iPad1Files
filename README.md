# iPad1Files

iPad 1 / iOS 5.1.1 için ortak dosya sistemi omurgası.

```text
/var/mobile/Media/iPad1Files
```

Akış:
```text
iPad1FTPDownloader -> Shared Downloads -> iPad1Files -> Open With -> iPad1PDFReader
```

beta1: browser, copy/move/rename/delete, multi-select, search, favorites, disk info, text/image preview, file info, recursive size, collision-safe naming, app registry, PDF absolute-path hand-off.

Open With:
```text
.pdf -> iPad1PDFReader
ipad1pdf://open?path=<percent-encoded-absolute-path>
```

Build:
```bash
cd ~/projects/iPad1Files-v1.0.0-beta1
make clean
rm -rf .theos
make package FINALPACKAGE=1
```

Device: `192.168.1.100`

Repo: `https://github.com/SHapeloglu/iPad1Files` (`main`).

Önce `SESSION.md` ve `INTEGRATION.md` oku.
