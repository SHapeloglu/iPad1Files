# iPad1Files Architecture

iPad1Files monolitik FTP/PDF uygulaması değil, local filesystem + shared storage + hand-off katmanıdır.

Platform:
```text
iPad 1 / 256 MB / iOS 5.1.1 / armv7 / Theos / Objective-C / non-ARC
```

Core:
- IP1SharedStorage: canonical folders
- IP1FileManager: local operations + collision-safe naming
- IP1FileItem: metadata
- IP1FileTypeDetector: extension detection
- IP1FavoritesManager: favorites
- IP1DiskInfo: disk
- IP1AppRegistry: extension -> app
- IP1AppLauncher: URL hand-off

İlk mapping: `.pdf -> iPad1PDFReader`.

FTP/SFTP/SMB/WebDAV engines, PDF engine features, OCR/AI kapsam dışıdır.
