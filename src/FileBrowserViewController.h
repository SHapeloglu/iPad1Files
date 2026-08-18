#import <UIKit/UIKit.h>
#import "FolderPickerViewController.h"

@interface FileBrowserViewController : UITableViewController
    <UISearchBarDelegate, UIActionSheetDelegate, UIAlertViewDelegate, FolderPickerViewControllerDelegate> {
    NSString *_path;
    NSArray *_items;
    NSArray *_filteredItems;
    UISearchBar *_searchBar;
    BOOL _showHidden;
    BOOL _selectionMode;
    NSMutableArray *_selectedPaths;
    NSString *_pendingOperation;
}

- (id)initWithPath:(NSString *)path;

@end
