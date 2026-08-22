# iPad1Files Entegrasyon Yönergesi

iPad1Files ortak dosya sistemi omurgasıdır; FTP/PDF motorlarını içine almaz.

## Platform
iPad 1 / 256 MB RAM / iOS 5.1.1 / armv7 / Theos / non-ARC-MRC.

## Canonical root
```text
/var/mobile/Media/iPad1Files
Downloads/ Documents/ PDFs/ Images/ Music/ Videos/ Archives/ Shared/ Temp/ AppData/
```

## PDF
```text
.pdf -> iPad1PDFReader
ipad1pdf://open?path=<percent-encoded-absolute-path>
```
`IP1AppRegistry` mapping yapar, `IP1AppLauncher` mevcut absolute path'i yollar. PDF açmak için kopyalanmaz.

## FTP
iPad1FTPDownloader default:
```text
/var/mobile/Media/iPad1Files/Downloads
```
iPad1Files import/kopya yapmaz.

## Kullanıcı kontrollü sınıflandırma
Downloads içinde isteğe bağlı:
```text
.pdf -> PDFs/
.jpg/.png -> Images/
.mp3 -> Music/
.zip -> Archives/
```
Otomatik taşıma yok.

## Scope
iPad1Files: browser, copy/move/rename/delete, multi-select, search, favorites, disk info, Open With, preview, shared folders, collision-safe naming.

Kapsam dışı: FTP/SFTP/SMB/WebDAV motorları; PDF annotation/search/reflow/page editing; OCR; AI/ML; background indexing.

## Memory
Aktif klasör בלבד; büyük thumbnail cache/global tree/index yok.

## Hedef akış
```text
iPad1FTPDownloader -> Shared Downloads -> iPad1Files -> Open With -> iPad1PDFReader
```
