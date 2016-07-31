#import "HomeViewController.h"
#import "JXAddressBook.h"

@interface HomeViewController ()
{
    UITableView *_tableView;

    UISearchBar *_searchBar;
    UISearchDisplayController *_searchController;

    NSArray *_dataArray;
    NSArray *_searchArray;
}

@end

@implementation HomeViewController

#pragma mark -
#pragma mark - Method Demo

- (void)refreshPersonInfoTableView
{
    [JXAddressBook getPersonInfo:^(NSArray *personInfos) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 对获取数据进行排序
            _dataArray = [JXAddressBook sortPersonInfos:personInfos];
            
            NSLog(@"%@", _dataArray);
            
            [_tableView reloadData];
            _tableView.tableHeaderView = _searchBar;
        });
    }];
}
- (void)refreshSearchTableView:(NSString *)searchText
{
    [JXAddressBook searchPersonInfo:searchText addressBookBlock:^(NSArray *personInfos) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 直接获取数据
            _searchArray = personInfos;
            
            NSLog(@"手机通讯录信息  ==  %@", _searchArray);
            
            [_searchController.searchResultsTableView reloadData];
        });
    }];
}

#pragma mark -
#pragma mark - CREATE UI

- (IBAction)refreshAddressBook:(id)sender
{
    [self refreshPersonInfoTableView];
}

- (void)createTableView
{
    _dataArray = [NSArray array];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|
                                  UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
}
- (void)createSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _searchBar.frame.size.height)];
    _tableView.tableHeaderView = _searchBar;
    _searchBar.delegate = self;
    
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
}

#pragma mark -
#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", _dataArray);
    
    [self createTableView];
    [self createSearchBar];
    [self refreshPersonInfoTableView];
}

#pragma mark -
#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_searchController.searchResultsTableView) {
        return 1;
    }
    return _dataArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==_searchController.searchResultsTableView) {
        return @"";
    }
    return JXSpellFromIndex(section);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_searchController.searchResultsTableView) {
        return _searchArray.count;
    }
    return ((NSArray *)[_dataArray objectAtIndex:section]).count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"UITableViewCell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    
    JXPersonInfo *personInfo = nil;
    
    if (tableView == _searchController.searchResultsTableView) {
        personInfo = [_searchArray objectAtIndex:indexPath.row];
    }else {
        NSArray *subArr = [_dataArray objectAtIndex:indexPath.section];
        personInfo = [subArr objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = personInfo.fullName;
    
    if (personInfo.phone.count>0) {
        cell.detailTextLabel.text = [personInfo.phone[0] allObjects][0];
        
//        cell.detailTextLabel.text = [personInfo.phone[0] objectForKey:((NSDictionary *)personInfo.phone[0]).allKeys[0]];
    }else {
        cell.detailTextLabel.text = @"暂无联系方式";

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    JXPersonInfo *personInfo = nil;
    if (tableView==_searchController.searchResultsTableView) {
        personInfo = [_searchArray objectAtIndex:indexPath.row];
    }else {
        personInfo = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    NSLog(@"当前选择的用户信息为:\n%@", personInfo);
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        //        textField.backgroundColor = [UIColor orangeColor];
        textField.placeholder=@"申请备注";
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_searchController.searchResultsTableView) {
        return 0;
    }
    
    if (((NSArray *)[_dataArray objectAtIndex:section]).count==0) {
        return 0;
    }
    return 30;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView==_searchController.searchResultsTableView) {
        return @[];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 27; i++) {
        [arr addObject:JXSpellFromIndex(i)];
    }
    return arr;
}

#pragma mark -
#pragma mark - SearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self refreshSearchTableView:searchText];
}

@end
