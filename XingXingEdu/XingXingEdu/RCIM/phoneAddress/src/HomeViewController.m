#import "HomeViewController.h"
#import "XXERongCloudPhoneNumListModel.h"
#import "XXEPhoneAddressBookTableViewCell.h"
#import "JXAddressBook.h"

@interface HomeViewController ()
{
    UITableView *_tableView;

    UISearchBar *_searchBar;
    UISearchDisplayController *_searchController;

    NSArray *_dataArray;
    NSArray *_searchArray;
    
    JXPersonInfo *personInfo;
    //手机 原有 所有 手机号
    NSMutableArray *allPhoneNumArray;
    
    //通过后台判断,获取的已注册 猩猩教室 的用户 modelArray
    NSMutableArray *modelArray;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
    UIImageView *placeholderImageView;

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
            
//            NSLog(@"%@", _dataArray);
            [self createAllPhoneNumDataSource];
            
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
            
//            NSLog(@"手机通讯录信息  ==  %@", _searchArray);
            
            [_searchController.searchResultsTableView reloadData];
        });
    }];
}

#pragma mark -
#pragma mark - CREATE UI

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
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
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    allPhoneNumArray = [[NSMutableArray alloc] init];
    modelArray = [[NSMutableArray alloc] init];
    
//    NSLog(@"%@", _dataArray);
    
    [self createTableView];
    [self createSearchBar];
    [self refreshPersonInfoTableView];
}

#pragma mark -
#pragma mark - SearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self refreshSearchTableView:searchText];
}

- (void)createAllPhoneNumDataSource{
    for (NSArray *phoneArray in _dataArray) {
        
        for (JXPersonInfo *pInfo in phoneArray) {
            NSString *phoneStr = [pInfo.phone[0] allObjects][0];
            if (phoneStr.length == 11) {
                [allPhoneNumArray addObject:phoneStr];
            }else if (phoneStr.length == 13 && [[phoneStr substringToIndex:1] isEqualToString:@"8"]){
                [allPhoneNumArray addObject:[phoneStr substringFromIndex:2]];
            }else if (phoneStr.length == 13 && [phoneStr containsString:@"-"]){
                
                //                NSLog(@"%@ =---== ", phoneStr);
                NSArray *strArray = [phoneStr componentsSeparatedByString:@"-"];
                NSString *newStr = @"";
                for (int k = 0; k < strArray.count ; k ++) {
                    //                    [newStr appendString:strArray[k]];
                    newStr = [NSString stringWithFormat:@"%@%@", newStr, strArray[k]];
                }
                
                [allPhoneNumArray addObject:newStr];
            }else if (phoneStr.length == 15 && [[phoneStr substringToIndex:1] isEqualToString:@"8"] && [phoneStr containsString:@"-"]){
                
                //                NSLog(@"%@ =---== ", phoneStr);
                NSArray *strArray = [[phoneStr substringFromIndex:2] componentsSeparatedByString:@"-"];
                NSString *newStr = @"";
                for (int k = 0; k < strArray.count ; k ++) {
                    //                    [newStr appendString:strArray[k]];
                    newStr = [NSString stringWithFormat:@"%@%@", newStr, strArray[k]];
                }
                
                [allPhoneNumArray addObject:newStr];
            }
            
        }
        
    }
    
    [self submitAllPhoneNumInfo:allPhoneNumArray];
    //    NSLog(@"pppp %@", allPhoneNumArray);
    
}

- (void)submitAllPhoneNumInfo:(NSArray *)phoneNumArray{
    
    NSError *error;
    NSData *jsonData =[NSJSONSerialization dataWithJSONObject:allPhoneNumArray  options:kNilOptions error:&error];
    NSString *jsonString =[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (modelArray.count != 0) {
        [modelArray removeAllObjects];
    }
    
    /*
     【聊天--手机通讯录列表】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/phone_contact_book
     传参:
     phone_group	//用户手机电话通讯录中的手机号,一维数组的json数据
     */
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/phone_contact_book";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"phone_group":jsonString
                             };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"本机 通讯录  === %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            NSDictionary *dict = responseObj[@"data"];
            
            NSArray *array = [XXERongCloudPhoneNumListModel parseResondsData:dict];
            
            [modelArray addObjectsFromArray:array];
        }
        [self customContent];
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showWithStatus:@"获取数据失败"];
    }];
    
}


// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (modelArray.count == 0) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
    }
    
    [_tableView reloadData];
    
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [self.view addSubview:placeholderImageView];
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
}


#pragma mark -
#pragma mark - TableViewDelegate
#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return modelArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXEPhoneAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEPhoneAddressBookTableViewCell" owner:self options:nil]lastObject];
    }
    XXERongCloudPhoneNumListModel *model = modelArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString * head_img;
    if([model.head_img_type integerValue] == 0){
        head_img = [picURL stringByAppendingString:model.head_img];
    }else{
        head_img = model.head_img;
    }
    
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    
    //    NSLog(@"课程  %@", model.teach_course);
    cell.nameLabel.text = model.tname;
    cell.nickNameLabel.text = model.nickname;
    
    cell.addbutton.tag = 100 + indexPath.row;
    ////1:已经是好友  2:自己   3:其他
    if ([model.friend_type integerValue] == 3) {
        [cell.addbutton addTarget:self action:@selector(addbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.addbutton.backgroundColor = UIColorFromRGB(0, 170, 42);
        
    }else{
        [cell.addbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cell.addbutton.backgroundColor = [UIColor whiteColor];
        cell.addbutton.enabled = NO;
        
    }
    
    if ([model.friend_type integerValue] == 1) {
        
        [cell.addbutton setTitle:@"已添加" forState:UIControlStateNormal];
        
    }else if ([model.friend_type integerValue] == 2){
        
        [cell.addbutton setTitle:@"本人" forState:UIControlStateNormal];
        
    }else if ([model.friend_type integerValue] == 3){
        
        [cell.addbutton setTitle:@"添加" forState:UIControlStateNormal];
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

- (void)addbuttonClick:(UIButton *)button{
    
    /*
     【聊天--发起添加好友请求】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/action_friend_request
     传参:
     other_xid	//对方xid  (测试可用xid: 18886390,18886391,18886393(允许任何人通过),18886378(已是好友),18886177(在对方黑名单中))
     */
    XXERongCloudPhoneNumListModel *model = modelArray[button.tag - 100];
    
    NSString *otherXid = model.xid;
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/action_friend_request";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"other_xid":otherXid
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSLog(@"%@", responseObj);
        /*
         ★其他结果需提醒用户
         code:4	//不能请求自己
         code:5	//已经是好友了(不能对好友发起请求)
         code:6	//对方在我的黑名单中,无法发起请求!
         code:7	//您已经在对方黑名单中,无法发起请求!
         code:8	//不能重复对同一个人发起请求!
         code:9	//对方已同意,可以直接聊天了 (对方设置了任何人请求直接通过)
         */

        NSString *codeStr =[NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
         if ([codeStr isEqualToString:@"1"]) {
             [SVProgressHUD showWithStatus:@"请求发送成功!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"4"]) {
            [SVProgressHUD showWithStatus:@"不能请求自己!"];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }else if ([codeStr isEqualToString:@"5"]) {
            [SVProgressHUD showWithStatus:@"对方已经是您的好友!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"6"]) {
            [SVProgressHUD showWithStatus:@"对方在我的黑名单中,无法发起请求!"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }else if ([codeStr isEqualToString:@"7"]) {
            [SVProgressHUD showWithStatus:@"您已经在对方黑名单中,无法发起请求!"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }else if ([codeStr isEqualToString:@"8"]) {
            [SVProgressHUD showWithStatus:@"不能重复对同一个人发起请求!"];

        }else if ([codeStr isEqualToString:@"9"]) {
            [SVProgressHUD showWithStatus:@"对方已同意,可以直接聊天了!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"10"]) {
            [SVProgressHUD showWithStatus:@"添加成功!"];
            
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self.navigationController popViewControllerAnimated:YES];
           });


        }else{
            [SVProgressHUD showWithStatus:@"请求发送失败!"];
        }

    } failure:^(NSError *error) {
        //
        [SVProgressHUD showWithStatus:@"获取数据失败!"];
    }];
    
    
}



@end
