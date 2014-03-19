#import "bsDisplay.h"

//TableView
//이건 delegate를 통해 기능이 엄청 많은데다가 TableView 내장 View를 메서드를 정의했느냐에 따라서 생성해준다.
//그래서 필요없는 메서드자체를 정의하면 무조건 View를 커스터마이징 할 수 밖에 없어진다. ... 이 무슨 ㅡㅡ;;;
//결국 TableView를 가지고 구현하려면 원래 UITableView를 좀 더 연구해서 돌아가는 방법을 찾던가
//아니면 새로 구현해야한다. 
@class bsTable;
//typedef void (^bsTextFieldWillBeginEditBlock)( NSString *blockKey, bsTextField* textField, BOOL *allowEdit );


#define kbsTableStyle       100701 //readonly
#define kbsTableSeparator   100702
#define kbsTableSeparatorColor 100703
#define kbsTableRowHeight   100704

@interface bsTablePlain : bsDisplay /*<UITableViewDelegate, UITableViewDataSource>*/ {
    
    UITableView *table_;
}

@property (nonatomic, readonly) UITableView *tableView;

@end
