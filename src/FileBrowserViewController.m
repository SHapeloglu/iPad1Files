#import <objc/runtime.h>
#import "FileBrowserViewController.h"
#import "IP1FileManager.h"
#import "IP1FileItem.h"
#import "IP1FileTypeDetector.h"
#import "IP1AppLauncher.h"
#import "IP1FavoritesManager.h"
#import "IP1DiskInfo.h"
#import "FavoritesViewController.h"
#import "FileInfoViewController.h"
#import "TextViewerViewController.h"
#import "ImageViewerViewController.h"

@implementation FileBrowserViewController

- (id)initWithPath:(NSString *)path {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _path = [path copy];
        _showHidden = NO;
        _selectionMode = NO;
        _selectedPaths = [[NSMutableArray alloc] init];
        self.title = ([[_path lastPathComponent] length] > 0) ? [_path lastPathComponent] : @"Files";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"Bu klasörde ara";
    self.tableView.tableHeaderView = _searchBar;

    [self configureNavigation];
    [self reloadFiles];
    [self updateFooter];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadFiles];
    [self updateFooter];
}

- (void)configureNavigation {
    if (_selectionMode) {
        UIBarButtonItem *cancel =
            [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                          target:self
                                                          action:@selector(cancelSelection)] autorelease];
        self.navigationItem.leftBarButtonItem = cancel;

        UIBarButtonItem *done =
            [[[UIBarButtonItem alloc] initWithTitle:@"İşlem"
                                             style:UIBarButtonItemStyleDone
                                            target:self
                                            action:@selector(showSelectionActions)] autorelease];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:done];
    } else {
        self.navigationItem.leftBarButtonItem = nil;

        UIBarButtonItem *add =
            [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                          target:self
                                                          action:@selector(addFolder)] autorelease];

        UIBarButtonItem *select =
            [[[UIBarButtonItem alloc] initWithTitle:@"Seç"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(beginSelection)] autorelease];

        UIBarButtonItem *actions =
            [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                          target:self
                                                          action:@selector(showFolderActions)] autorelease];

        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:add, select, actions, nil];
    }
}

- (NSArray *)displayItems {
    return ([_searchBar.text length] > 0) ? _filteredItems : _items;
}

- (void)reloadFiles {
    NSError *error = nil;
    NSArray *newItems =
        [[IP1FileManager sharedManager] contentsOfDirectory:_path showHidden:_showHidden error:&error];

    [_items release];
    _items = [newItems retain];

    [self filterWithText:_searchBar.text];
    [self.tableView reloadData];

    if (!_items && error) {
        UIAlertView *alert =
            [[[UIAlertView alloc] initWithTitle:@"Klasör açılamadı"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"Tamam"
                              otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (void)updateFooter {
    unsigned long long free = [IP1DiskInfo freeBytesAtPath:_path];
    unsigned long long total = [IP1DiskInfo totalBytesAtPath:_path];

    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 36)] autorelease];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"Boş: %@ / Toplam: %@",
                  [IP1DiskInfo formattedBytes:free],
                  [IP1DiskInfo formattedBytes:total]];
    self.tableView.tableFooterView = label;
}

- (void)filterWithText:(NSString *)text {
    [_filteredItems release];
    _filteredItems = nil;
    if ([text length] == 0) return;

    NSMutableArray *matches = [NSMutableArray array];
    for (IP1FileItem *item in _items) {
        if ([item.name rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [matches addObject:item];
        }
    }
    _filteredItems = [matches copy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    (void)tableView; (void)section;
    return [[self displayItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"FileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier] autorelease];
    }

    IP1FileItem *item = [[self displayItems] objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [item formattedSize];

    if (_selectionMode) {
        cell.accessoryType = [_selectedPaths containsObject:item.path]
            ? UITableViewCellAccessoryCheckmark
            : UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = item.isDirectory
            ? UITableViewCellAccessoryDisclosureIndicator
            : UITableViewCellAccessoryDetailDisclosureButton;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IP1FileItem *item = [[self displayItems] objectAtIndex:indexPath.row];

    if (_selectionMode) {
        if ([_selectedPaths containsObject:item.path]) [_selectedPaths removeObject:item.path];
        else [_selectedPaths addObject:item.path];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        self.title = [NSString stringWithFormat:@"%lu seçili", (unsigned long)[_selectedPaths count]];
        return;
    }

    if (item.isDirectory) {
        FileBrowserViewController *browser =
            [[[FileBrowserViewController alloc] initWithPath:item.path] autorelease];
        [self.navigationController pushViewController:browser animated:YES];
        return;
    }

    IP1FileType type = [IP1FileTypeDetector typeForPath:item.path];

    if (type == IP1FileTypeText) {
        TextViewerViewController *viewer =
            [[[TextViewerViewController alloc] initWithPath:item.path] autorelease];
        [self.navigationController pushViewController:viewer animated:YES];
        return;
    }

    if (type == IP1FileTypeImage) {
        ImageViewerViewController *viewer =
            [[[ImageViewerViewController alloc] initWithPath:item.path] autorelease];
        [self.navigationController pushViewController:viewer animated:YES];
        return;
    }

    if (type == IP1FileTypePDF && [IP1AppLauncher canOpenPDFReader]) {
        [IP1AppLauncher openPDFReaderWithPath:item.path];
        return;
    }

    [self showActionsForItem:item];
}

- (void)tableView:(UITableView *)tableView
 accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    (void)tableView;
    if (_selectionMode) return;
    IP1FileItem *item = [[self displayItems] objectAtIndex:indexPath.row];
    [self showActionsForItem:item];
}

- (void)beginSelection {
    _selectionMode = YES;
    [_selectedPaths removeAllObjects];
    self.title = @"0 seçili";
    [self configureNavigation];
    [self.tableView reloadData];
}

- (void)cancelSelection {
    _selectionMode = NO;
    [_selectedPaths removeAllObjects];
    self.title = [_path lastPathComponent];
    [self configureNavigation];
    [self.tableView reloadData];
}

- (void)showSelectionActions {
    if ([_selectedPaths count] == 0) return;

    UIActionSheet *sheet =
        [[[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%lu öğe", (unsigned long)[_selectedPaths count]]
                                     delegate:self
                            cancelButtonTitle:nil
                       destructiveButtonTitle:@"Sil"
                            otherButtonTitles:@"Kopyala", @"Taşı", nil] autorelease];
    [sheet addButtonWithTitle:@"Vazgeç"];
    sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    objc_setAssociatedObject(sheet, "IP1SelectionSheet", @"YES", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [sheet showInView:self.view];
}

- (void)startDestinationOperation:(NSString *)operation {
    [_pendingOperation release];
    _pendingOperation = [operation copy];

    FolderPickerViewController *picker =
        [[[FolderPickerViewController alloc] initWithPath:@"/var/mobile/Media/iPad1Files"] autorelease];
    picker.delegate = self;
    picker.actionTitle = [operation isEqualToString:@"copy"] ? @"Buraya Kopyala" : @"Buraya Taşı";

    UINavigationController *nav =
        [[[UINavigationController alloc] initWithRootViewController:picker] autorelease];

    UIBarButtonItem *cancel =
        [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                      target:self
                                                      action:@selector(dismissPicker)] autorelease];
    picker.navigationItem.leftBarButtonItem = cancel;

    [self presentModalViewController:nav animated:YES];
}

- (void)dismissPicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)folderPicker:(FolderPickerViewController *)picker didChoosePath:(NSString *)path {
    (void)picker;
    NSError *error = nil;
    BOOL ok = YES;

    for (NSString *source in _selectedPaths) {
        BOOL itemOK;
        if ([_pendingOperation isEqualToString:@"copy"]) {
            itemOK = [[IP1FileManager sharedManager] copyItemAtPath:source toDirectory:path error:&error];
        } else {
            itemOK = [[IP1FileManager sharedManager] moveItemAtPath:source toDirectory:path error:&error];
        }
        if (!itemOK) {
            ok = NO;
            break;
        }
    }

    [self dismissModalViewControllerAnimated:YES];

    if (!ok) {
        UIAlertView *alert =
            [[[UIAlertView alloc] initWithTitle:@"İşlem tamamlanamadı"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"Tamam"
                              otherButtonTitles:nil] autorelease];
        [alert show];
    }

    [self cancelSelection];
    [self reloadFiles];
}

- (void)showActionsForItem:(IP1FileItem *)item {
    BOOL favorite = [[IP1FavoritesManager sharedManager] isFavorite:item.path];

    UIActionSheet *sheet =
        [[[UIActionSheet alloc] initWithTitle:item.name
                                     delegate:self
                            cancelButtonTitle:nil
                       destructiveButtonTitle:nil
                            otherButtonTitles:@"Bilgi",
                                              favorite ? @"Favorilerden Çıkar" : @"Favorilere Ekle",
                                              @"Yeniden Adlandır",
                                              @"Sil",
                                              nil] autorelease];

    [sheet addButtonWithTitle:@"Vazgeç"];
    sheet.destructiveButtonIndex = 3;
    sheet.cancelButtonIndex = sheet.numberOfButtons - 1;

    objc_setAssociatedObject(sheet, "IP1FileItem", item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];

    if (objc_getAssociatedObject(actionSheet, "IP1SelectionSheet")) {
        if ([title isEqualToString:@"Sil"]) {
            UIAlertView *alert =
                [[[UIAlertView alloc] initWithTitle:@"Toplu Silme"
                                            message:[NSString stringWithFormat:@"%lu öğe kalıcı olarak silinsin mi?",
                                                     (unsigned long)[_selectedPaths count]]
                                           delegate:self
                                  cancelButtonTitle:@"Vazgeç"
                                  otherButtonTitles:@"Sil", nil] autorelease];
            alert.tag = 200;
            [alert show];
        } else if ([title isEqualToString:@"Kopyala"]) {
            [self startDestinationOperation:@"copy"];
        } else if ([title isEqualToString:@"Taşı"]) {
            [self startDestinationOperation:@"move"];
        }
        return;
    }

    IP1FileItem *item = objc_getAssociatedObject(actionSheet, "IP1FileItem");

    if ([title isEqualToString:@"Bilgi"]) {
        FileInfoViewController *info =
            [[[FileInfoViewController alloc] initWithPath:item.path] autorelease];
        [self.navigationController pushViewController:info animated:YES];
    } else if ([title isEqualToString:@"Favorilere Ekle"] ||
               [title isEqualToString:@"Favorilerden Çıkar"]) {
        [[IP1FavoritesManager sharedManager] toggleFavorite:item.path];
    } else if ([title isEqualToString:@"Yeniden Adlandır"]) {
        [self promptRename:item];
    } else if ([title isEqualToString:@"Sil"]) {
        [self confirmDelete:item];
    } else if ([title isEqualToString:@"Gizli Dosyaları Göster"] ||
               [title isEqualToString:@"Gizli Dosyaları Gizle"]) {
        _showHidden = !_showHidden;
        [self reloadFiles];
    } else if ([title isEqualToString:@"Favoriler"]) {
        FavoritesViewController *favorites = [[[FavoritesViewController alloc] init] autorelease];
        [self.navigationController pushViewController:favorites animated:YES];
    } else if ([title isEqualToString:@"Yenile"]) {
        [self reloadFiles];
        [self updateFooter];
    }
}

- (void)addFolder {
    UIAlertView *alert =
        [[[UIAlertView alloc] initWithTitle:@"Yeni Klasör"
                                    message:@"Klasör adını yazın"
                                   delegate:self
                          cancelButtonTitle:@"Vazgeç"
                          otherButtonTitles:@"Oluştur", nil] autorelease];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 100;
    [alert show];
}

- (void)promptRename:(IP1FileItem *)item {
    UIAlertView *alert =
        [[[UIAlertView alloc] initWithTitle:@"Yeniden Adlandır"
                                    message:nil
                                   delegate:self
                          cancelButtonTitle:@"Vazgeç"
                          otherButtonTitles:@"Kaydet", nil] autorelease];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setText:item.name];
    alert.tag = 101;
    objc_setAssociatedObject(alert, "IP1RenameItem", item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
}

- (void)confirmDelete:(IP1FileItem *)item {
    UIAlertView *alert =
        [[[UIAlertView alloc] initWithTitle:@"Sil"
                                    message:[NSString stringWithFormat:@"%@ silinsin mi?", item.name]
                                   delegate:self
                          cancelButtonTitle:@"Vazgeç"
                          otherButtonTitles:@"Sil", nil] autorelease];

    alert.tag = 102;
    objc_setAssociatedObject(alert, "IP1DeleteItem", item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) return;

    NSError *error = nil;
    BOOL success = NO;

    if (alertView.tag == 100) {
        NSString *name = [[alertView textFieldAtIndex:0] text];
        success = [[IP1FileManager sharedManager] createFolderNamed:name inDirectory:_path error:&error];
    } else if (alertView.tag == 101) {
        IP1FileItem *item = objc_getAssociatedObject(alertView, "IP1RenameItem");
        NSString *name = [[alertView textFieldAtIndex:0] text];
        success = [[IP1FileManager sharedManager] renameItemAtPath:item.path toName:name error:&error];
    } else if (alertView.tag == 102) {
        IP1FileItem *item = objc_getAssociatedObject(alertView, "IP1DeleteItem");
        success = [[IP1FileManager sharedManager] deleteItemAtPath:item.path error:&error];
    } else if (alertView.tag == 200) {
        success = YES;
        for (NSString *path in _selectedPaths) {
            if (![[IP1FileManager sharedManager] deleteItemAtPath:path error:&error]) {
                success = NO;
                break;
            }
        }
        [self cancelSelection];
    }

    if (!success && error) {
        UIAlertView *errorAlert =
            [[[UIAlertView alloc] initWithTitle:@"İşlem başarısız"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"Tamam"
                              otherButtonTitles:nil] autorelease];
        [errorAlert show];
    }

    [self reloadFiles];
    [self updateFooter];
}

- (void)showFolderActions {
    UIActionSheet *sheet =
        [[[UIActionSheet alloc] initWithTitle:_path
                                     delegate:self
                            cancelButtonTitle:nil
                       destructiveButtonTitle:nil
                            otherButtonTitles:
                              [[IP1FavoritesManager sharedManager] isFavorite:_path]
                                ? @"Favorilerden Çıkar"
                                : @"Favorilere Ekle",
                              @"Favoriler",
                              _showHidden ? @"Gizli Dosyaları Gizle" : @"Gizli Dosyaları Göster",
                              @"Yenile",
                              nil] autorelease];

    [sheet addButtonWithTitle:@"Vazgeç"];
    sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    objc_setAssociatedObject(sheet, "IP1FileItem",
                             [IP1FileItem itemWithPath:_path],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [sheet showInView:self.view];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    (void)searchBar;
    [self filterWithText:searchText];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)dealloc {
    _searchBar.delegate = nil;
    [_path release];
    [_items release];
    [_filteredItems release];
    [_searchBar release];
    [_selectedPaths release];
    [_pendingOperation release];
    [super dealloc];
}

@end
