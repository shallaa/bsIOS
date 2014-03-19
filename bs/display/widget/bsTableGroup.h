#import "bsDisplay.h"

#define kbsTableStyle       100701 //readonly
#define kbsTableSeparator   100702
#define kbsTableSeparatorColor 100703
#define kbsTableRowHeight   100704

@interface bsTableGroup : bsDisplay /*<UITableViewDelegate, UITableViewDataSource>*/ {
    
    UITableView *table_;
}

@property (nonatomic, readonly) UITableView *tableView;

@end
